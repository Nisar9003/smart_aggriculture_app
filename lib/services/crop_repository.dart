import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../firebase_options.dart';
import '../models/crop_model.dart';
import '../models/task_model.dart';

class _ScheduleItem {
  final int dayOffset;
  final String title;
  final String subtitle;
  final TaskType type;
  const _ScheduleItem(this.dayOffset, this.title, this.subtitle, this.type);
}

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

  List<_ScheduleItem> _scheduleFor(String cropName) {
    final name = cropName.toLowerCase();

    if (name.contains('gandum') || name.contains('wheat')) {
      return const [
        _ScheduleItem(15, "Pehla pani lagayen", "Bounai ke 15 din baad", TaskType.water),
        _ScheduleItem(25, "DAP Khaad dein", "Andazan 1 bag per acre", TaskType.fertilizer),
        _ScheduleItem(35, "Dusra pani lagayen", "Ugne ke stage par", TaskType.water),
        _ScheduleItem(50, "Urea Khaad dein", "Phool ana shuru hone se pehle", TaskType.fertilizer),
        _ScheduleItem(65, "Teesra pani lagayen", "", TaskType.water),
        _ScheduleItem(85, "Chautha pani lagayen", "", TaskType.water),
        _ScheduleItem(100, "Kira mar spray check karein", "Fasal ka muaina karein", TaskType.spray),
        _ScheduleItem(140, "Fasal katai ka andaza", "Average paidawar: 25-30 man/acre (estimate)", TaskType.harvest),
      ];
    }
    if (name.contains('chawal') || name.contains('rice')) {
      return const [
        _ScheduleItem(5, "Pehla pani lagayen", "Chawal ko mustaqil nami chahiye", TaskType.water),
        _ScheduleItem(15, "DAP Khaad dein", "Andazan 1 bag per acre", TaskType.fertilizer),
        _ScheduleItem(25, "Pani ka level check karein", "", TaskType.water),
        _ScheduleItem(40, "Urea Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(55, "Pani ka level check karein", "", TaskType.water),
        _ScheduleItem(75, "Kira mar spray check karein", "", TaskType.spray),
        _ScheduleItem(120, "Fasal katai ka andaza", "Average paidawar: 30-35 man/acre (estimate)", TaskType.harvest),
      ];
    }
    if (name.contains('kapas') || name.contains('cotton')) {
      return const [
        _ScheduleItem(20, "Pehla pani lagayen", "", TaskType.water),
        _ScheduleItem(30, "DAP Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(45, "Dusra pani lagayen", "", TaskType.water),
        _ScheduleItem(60, "Urea Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(70, "Teesra pani lagayen", "", TaskType.water),
        _ScheduleItem(90, "Kira mar spray check karein", "Sundhi/Bollworm ka khayal rakhein", TaskType.spray),
        _ScheduleItem(100, "Chautha pani lagayen", "", TaskType.water),
        _ScheduleItem(180, "Fasal chunai ka andaza", "Average paidawar: 20-25 man/acre (estimate)", TaskType.harvest),
      ];
    }
    if (name.contains('ganna') || name.contains('sugarcane')) {
      return const [
        _ScheduleItem(15, "Pehla pani lagayen", "", TaskType.water),
        _ScheduleItem(30, "DAP Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(45, "Dusra pani lagayen", "", TaskType.water),
        _ScheduleItem(75, "Urea Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(90, "Teesra pani lagayen", "", TaskType.water),
        _ScheduleItem(150, "Chautha pani lagayen", "", TaskType.water),
        _ScheduleItem(220, "Panchwa pani lagayen", "", TaskType.water),
        _ScheduleItem(330, "Fasal katai ka andaza", "Average paidawar: 600-700 man/acre (estimate)", TaskType.harvest),
      ];
    }
    if (name.contains('makai') || name.contains('maize')) {
      return const [
        _ScheduleItem(10, "Pehla pani lagayen", "", TaskType.water),
        _ScheduleItem(20, "DAP Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(30, "Dusra pani lagayen", "", TaskType.water),
        _ScheduleItem(45, "Urea Khaad dein", "", TaskType.fertilizer),
        _ScheduleItem(55, "Teesra pani lagayen", "", TaskType.water),
        _ScheduleItem(70, "Kira mar spray check karein", "", TaskType.spray),
        _ScheduleItem(105, "Fasal katai ka andaza", "Average paidawar: 35-40 man/acre (estimate)", TaskType.harvest),
      ];
    }
    return const [
      _ScheduleItem(7, "Pehla pani lagayen", "", TaskType.water),
      _ScheduleItem(14, "Khaad dein", "", TaskType.fertilizer),
      _ScheduleItem(21, "Dusra pani lagayen", "", TaskType.water),
      _ScheduleItem(35, "Kira mar spray check karein", "", TaskType.spray),
      _ScheduleItem(45, "Teesra pani lagayen", "", TaskType.water),
      _ScheduleItem(65, "Fasal tudai ka andaza", "Average paidawar: fasal ke hisab se", TaskType.harvest),
    ];
  }

  List<RoadmapTask> generateRoadmap(
    String cropName,
    DateTime sowingDate, {
    String? soilType,
    double? soilPh,
  }) {
    int idCounter = 0;
    String nextId() => "t${sowingDate.millisecondsSinceEpoch}_${idCounter++}";

    double soilFactor = 1.0;
    if (soilType != null) {
      if (soilType.contains('Retli') || soilType.contains('Sandy')) {
        soilFactor = 0.8;
      } else if (soilType.contains('Chikni') || soilType.contains('Clay')) {
        soilFactor = 1.2;
      }
    }

    int adjustedOffset(int days, TaskType type) {
      if (type != TaskType.water) return days;
      return (days * soilFactor).round();
    }

    final schedule = _scheduleFor(cropName);
    final tasks = <RoadmapTask>[];
    for (final item in schedule) {
      final days = adjustedOffset(item.dayOffset, item.type);
      tasks.add(RoadmapTask(
        id: nextId(),
        title: item.title,
        subtitle: item.subtitle.isEmpty ? null : item.subtitle,
        dueDate: sowingDate.add(Duration(days: days)),
        type: item.type,
      ));
    }

    if (soilPh != null) {
      if (soilPh < 6.0) {
        tasks.add(RoadmapTask(
          id: nextId(),
          title: "Chuna (Lime) dalein",
          subtitle: "Mitti tezabi hai (pH ${soilPh.toStringAsFixed(1)}) — zarkhezi behtar karne ke liye",
          dueDate: sowingDate.add(const Duration(days: 5)),
          type: TaskType.other,
        ));
      } else if (soilPh > 7.8) {
        tasks.add(RoadmapTask(
          id: nextId(),
          title: "Gypsum dalein",
          subtitle: "Mitti alkaline hai (pH ${soilPh.toStringAsFixed(1)}) — zarkhezi behtar karne ke liye",
          dueDate: sowingDate.add(const Duration(days: 5)),
          type: TaskType.other,
        ));
      }
    }

    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return tasks;
  }

  Future<void> addCrop({
    required String name,
    required DateTime sowingDate,
    required double areaInAcres,
    required String soilType,
    double? soilPh,
  }) async {
    final roadmap = generateRoadmap(name, sowingDate, soilType: soilType, soilPh: soilPh);

    if (!_firebaseAvailable || _cropsCollection == null) {
      final crop = Crop(
        id: 'demo-${_demoIdCounter++}-${sowingDate.millisecondsSinceEpoch}',
        userId: userId,
        name: name,
        sowingDate: sowingDate,
        areaInAcres: areaInAcres,
        soilType: soilType,
        soilPh: soilPh,
        roadmap: roadmap,
      );
      crops = [crop, ...crops]..sort((a, b) => b.sowingDate.compareTo(a.sowingDate));
      notifyListeners();
      return;
    }

    final crop = Crop(
      id: '',
      userId: userId,
      name: name,
      sowingDate: sowingDate,
      areaInAcres: areaInAcres,
      soilType: soilType,
      soilPh: soilPh,
      roadmap: roadmap,
    );
    await _cropsCollection!.add(crop.toMap());
  }

  Future<void> deleteCrop(String cropId) async {
    if (!_firebaseAvailable || _cropsCollection == null) {
      crops = crops.where((c) => c.id != cropId).toList();
      notifyListeners();
      return;
    }
    await _cropsCollection!.doc(cropId).delete();
  }

  Future<void> toggleTask(String cropId, String taskId) async {
    final crop = crops.firstWhere((c) => c.id == cropId);
    final updatedRoadmap = crop.roadmap.map((t) {
      if (t.id == taskId) t.isDone = !t.isDone;
      return t.toMap();
    }).toList();

    if (!_firebaseAvailable || _cropsCollection == null) {
      crops = crops.map((c) {
        if (c.id != cropId) return c;
        return Crop(
          id: c.id,
          userId: c.userId,
          name: c.name,
          sowingDate: c.sowingDate,
          areaInAcres: c.areaInAcres,
          soilType: c.soilType,
          soilPh: c.soilPh,
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