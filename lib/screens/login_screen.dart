import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../firebase_options.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController(text: "+92");
  bool _sending = false;
  String? _error;

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (!phone.startsWith('+') || phone.length < 12) {
      setState(() => _error = "Poora number likhein, jese: +923001234567");
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    final isDemo = !DefaultFirebaseOptions.isConfigured;

    await AuthService.instance.sendOtp(
      phoneNumber: phone,
      onCodeSent: (verificationId) {
        setState(() => _sending = false);
        if (!mounted) return;
        if (isDemo) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Demo OTP: use 123456 or 000000')),
          );
        }
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpScreen(verificationId: verificationId, phoneNumber: phone),
          ),
        );
      },
      onError: (message) {
        setState(() {
          _sending = false;
          _error = message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!DefaultFirebaseOptions.isConfigured) ...[
                const SizedBox(height: 6),
                const Text(
                  'Demo mode: Firebase not configured. Use OTP 123456 to sign in.',
                  style: TextStyle(color: AppColors.danger, fontSize: 13),
                ),
                const SizedBox(height: 10),
              ],
              const Icon(Icons.grass, color: AppColors.primary, size: 56),
              const SizedBox(height: 16),
              Text("Khush Aamdeed", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 26)),
              const SizedBox(height: 6),
              const Text(
                "Apna mobile number darj karein, hum aapko OTP bhejenge.",
                style: TextStyle(color: AppColors.textMuted),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Mobile Number (+92...)",
                  prefixIcon: Icon(Icons.phone_android),
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 10),
                Text(_error!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _sending ? null : _sendOtp,
                  child: _sending
                      ? const SizedBox(
                          height: 20,
                          width: 10,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("OTP Bhejein"),
                ),
              ),
              const SizedBox(height: 14),
              const Center(
                child: Text(
                  "Real Firebase Phone Authentication (Phase 2).\n"
                  "Note: Firebase Console mein test phone numbers add\n"
                  "karke bhi bina real SMS ke test kiya ja sakta hai.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
