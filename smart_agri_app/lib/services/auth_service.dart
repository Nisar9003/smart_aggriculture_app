import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';

/// A minimal stand-in for FirebaseAuth's User, used only in Demo Mode
/// (when Firebase hasn't been configured yet via `flutterfire configure`).
/// Only `uid` and `phoneNumber` are implemented as real fields because
/// those are the only two properties this app ever reads from a User.
/// Anything else falls back to `null` instead of crashing, so screens
/// never throw a NoSuchMethodError on a field they don't actually use.
class _FakeUser implements User {
  _FakeUser(this._uid, this._phoneNumber);
  final String _uid;
  final String _phoneNumber;

  @override
  String get uid => _uid;

  @override
  String get phoneNumber => _phoneNumber;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

class _FakeUserCredential implements UserCredential {
  _FakeUserCredential(this._user);
  final User _user;

  @override
  User get user => _user;

  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}

/// Wraps Firebase's phone-number OTP flow so screens don't talk to
/// FirebaseAuth directly. Mirrors the "Firebase Authentication (Phone
/// Number Login)" box from the proposal's architecture diagram.
///
/// DEMO MODE: if `flutterfire configure` hasn't been run yet
/// (DefaultFirebaseOptions.isConfigured == false), this falls back to a
/// local fake login (OTP code 123456 or 000000 always works) so the whole
/// app can still be demoed end-to-end without a real backend. Once you
/// configure Firebase for real, this fallback is skipped automatically.
class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  FirebaseAuth? _auth;
  bool _isInitialized = false;
  String? _lastPhoneAttempted;
  User? _demoUser;

  bool get isAvailable => _isInitialized;

  Future<void> ensureInitialized() async {
    if (_isInitialized) return;

    try {
      if (DefaultFirebaseOptions.isConfigured && Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      if (DefaultFirebaseOptions.isConfigured) {
        _auth = FirebaseAuth.instance;
        _isInitialized = true;
      }
    } catch (e, stack) {
      debugPrint('Firebase Auth unavailable: $e');
      debugPrint(stack.toString());
    }
  }

  User? get currentUser {
    if (_auth != null) return _auth!.currentUser;
    return _demoUser;
  }

  Stream<User?> get authStateChanges {
    if (_auth != null) return _auth!.authStateChanges();
    return Stream.value(_demoUser);
  }

  /// Starts the OTP flow. [onCodeSent] fires once Firebase has texted the
  /// code to the phone; the OTP screen uses that verificationId to confirm.
  /// [phoneNumber] must be in full international format, e.g. +923001234567.
  Future<void> sendOtp({
    required String phoneNumber,
    required void Function(String verificationId) onCodeSent,
    required void Function(String message) onError,
  }) async {
    await ensureInitialized();
    _lastPhoneAttempted = phoneNumber;

    if (!_isInitialized || _auth == null) {
      final verificationId = 'demo-${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}';
      onCodeSent(verificationId);
      return;
    }

    await _auth!.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth!.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Mobile number verify nahi ho saka.');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<UserCredential> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    await ensureInitialized();
    if (!_isInitialized || _auth == null) {
      if (smsCode == '123456' || smsCode == '000000') {
        final phone = _lastPhoneAttempted ?? '+92000000000';
        // Stable per-phone-number id, so re-logging-in with the same
        // number in demo mode keeps seeing the same demo crops.
        final uid = 'demo-${phone.replaceAll(RegExp(r'[^0-9]'), '')}';
        _demoUser = _FakeUser(uid, phone);
        return _FakeUserCredential(_demoUser!);
      }
      throw StateError('Demo mode mein sirf 123456 ya 000000 code chalega.');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return _auth!.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await ensureInitialized();
    if (!_isInitialized || _auth == null) {
      _demoUser = null;
      return;
    }
    await _auth!.signOut();
  }
}
