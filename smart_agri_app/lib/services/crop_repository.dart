import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';
import '../models/crop_model.dart';
import '../models/task_model.dart';

/// Real-time Firestore data layer for crops. Matches the `crops`
/// collection described in the proposal's Database Design section.
///
/// DEMO MODE: if Firebase hasn't been configured yet (see
/// DefaultFirebaseOptions.isConfigured), crops are kept in a local
/// in-memory list instead — so "Fasal Add Karein" still works fully
/// while you demo the app, even before running `flutterfire configure`.
/// Nothing here is silently a no-op anymore: every write either reaches
/// Firestore, or reaches the in-memory fallback, and updates the UI.
class CropRepository extends ChangeNotifier {
  CropRepository(this.userId) {
    _initialize();
  }

  final String userId;
  FirebaseFirestore? _db;
  StreamSubscription<QuerySnapshot>? _sub;
  bool _firebaseAvailable = false;
  int _demoIdCounter = 0;

  List<Crop> crops = [];
  bool isLoading = true;

  CollectionReference? get _cropsCollection => _db?.collection('crops');

  Future<void> _initialize() async {
    try {
      if (DefaultFirebaseOptions.isConfigured && Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
      }
      if (DefaultFirebaseOptions.isConfigured) {
        _db = FirebaseFirestore.instance;
        _firebaseAvailable = true;
      }
    } catch (e, stack) {
      debugPrint('Firestore unavailable, falling back to demo (in-memory) storage: $e');
      debugPrint(stack.toString());
    }

    if (_firebaseAvailable) {
      _subscribe();
    } else {
      isLoading = false;
      notifyListeners();
    }
  }

  void _subscribe() {
    if (_cropsCollection == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    _sub = _cropsCollection!
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen((snapshot) {
      crops = snapshot.docs
          .map((doc) => Crop.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => b.sowingDate.compareTo(a.sowingDate));
      isLoading = false;
      notifyListeners();
    }, onError: (e) {
      isLoading = false;
      notifyListeners();
    });
  }

  /// Rule-based roadmap generator (Phase 6 in the proposal will replace
  /// the fixed day-offsets below with real agronomy rules / an AI model).
  List<RoadmapTask> generateRoadmap(DateTime sowingDate) {
    int idCounter = 0;
    String nextId() => "t${sowingDate.millisecondsSinceEpoch}_${idCounter++}";

    return [
      RoadmapTask(
        id: nextId(),
        title: "Pehla pani lagayen",
        subtitle: "Bounai ke 15 din baad",
        dueDate: sowingDate.add(const Duration(days: 15)),
        type: TaskType.water,
      ),
      RoadmapTask(
        id: nextId(),
        title: "DAP Khaad dein",
        subtitle: "Andazan 1 bag per acre",
        dueDate: sowingDate.add(const Duration(days: 25)),
        type: TaskType.fertilizer,
      ),
      RoadmapTask(
        id: nextId(),
        title: "Dusra pani lagayen",
        subtitle: "Ugne ke stage par",
        dueDate: sowingDate.add(const Duration(days: 35)),
        type: TaskType.water,
      ),
      RoadmapTask(
        id: nextId(),
        title: "Urea Khaad dein",
        subtitle: "Phool ana shuru hone se pehle",
        dueDate: sowingDate.add(const Duration(days: 50)),
        type: TaskType.fertilizer,
      ),
      RoadmapTask(
        id: nextId(),
        title: "Kira mar spray check karein",
        subtitle: "Fasal ka muaina karein",
        dueDate: sowingDate.add(const Duration(days: 65)),
        type: TaskType.spray,
      ),
      RoadmapTask(
        id: nextId(),
        title: "Fasal katai (harvest) ka andaza",
        subtitle: "Average paidawar: 25-30 man/acre (mock estimate)",
        dueDate: sowingDate.add(const Duration(days: 120)),
        type: TaskType.harvest,
      ),
    ];
  }

  Future<void> addCrop({
    required String name,
    required DateTime sowingDate,
    required double areaInAcres,
    required String soilType,
  }) async {
    final roadmap = generateRoadmap(sowingDate);

    if (!_firebaseAvailable || _cropsCollection == null) {
      // Demo mode: keep it in memory and refresh the UI immediately.
      final crop = Crop(
        id: 'demo-${_demoIdCounter++}-${sowingDate.millisecondsSinceEpoch}',
        userId: userId,
        name: name,
        sowingDate: sowingDate,
        areaInAcres: areaInAcres,
        soilType: soilType,
        roadmap: roadmap,
      );
      crops = [crop, ...crops]..sort((a, b) => b.sowingDate.compareTo(a.sowingDate));
      notifyListeners();
      return;
    }

    final crop = Crop(
      id: '', // Firestore assigns this on add()
      userId: userId,
      name: name,
      sowingDate: sowingDate,
      areaInAcres: areaInAcres,
      soilType: soilType,
      roadmap: roadmap,
    );
    await _cropsCollection!.add(crop.toMap());
    // No manual notifyListeners() needed here — the snapshots() listener
    // above will pick up this write in real time and refresh `crops` itself.
  }

  Future<void> toggleTask(String cropId, String taskId) async {
    final crop = crops.firstWhere((c) => c.id == cropId);
    final updatedRoadmap = crop.roadmap.map((t) {
      if (t.id == taskId) t.isDone = !t.isDone;
      return t.toMap();
    }).toList();

    if (!_firebaseAvailable || _cropsCollection == null) {
      // Demo mode: mutate the in-memory copy and refresh the UI.
      crops = crops.map((c) {
        if (c.id != cropId) return c;
        return Crop(
          id: c.id,
          userId: c.userId,
          name: c.name,
          sowingDate: c.sowingDate,
          areaInAcres: c.areaInAcres,
          soilType: c.soilType,
          roadmap: updatedRoadmap.map((m) => RoadmapTask.fromMap(m)).toList(),
        );
      }).toList();
      notifyListeners();
      return;
    }

    await _cropsCollection!.doc(cropId).update({'roadmap': updatedRoadmap});
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
