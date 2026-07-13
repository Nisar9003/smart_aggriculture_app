import 'task_model.dart';

/// Represents one crop a farmer has registered on a specific field.
/// Maps directly to a Firestore document in the `crops` collection.
class Crop {
  final String id; // Firestore document id
  final String userId;
  final String name; // e.g. Wheat / Gandum
  final DateTime sowingDate;
  final double areaInAcres;
  final String soilType;
  final double? soilPh; // Phase 5/6: used to tailor the roadmap
  final List<RoadmapTask> roadmap;

  Crop({
    required this.id,
    required this.userId,
    required this.name,
    required this.sowingDate,
    required this.areaInAcres,
    required this.soilType,
    this.soilPh,
    required this.roadmap,
  });

  double get progress {
    if (roadmap.isEmpty) return 0;
    final done = roadmap.where((t) => t.isDone).length;
    return done / roadmap.length;
  }

  RoadmapTask? get nextTask {
    final upcoming = roadmap.where((t) => !t.isDone).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'sowingDate': sowingDate.millisecondsSinceEpoch,
      'areaInAcres': areaInAcres,
      'soilType': soilType,
      'soilPh': soilPh,
      'roadmap': roadmap.map((t) => t.toMap()).toList(),
    };
  }

  factory Crop.fromMap(String id, Map<String, dynamic> map) {
    return Crop(
      id: id,
      userId: map['userId'] as String,
      name: map['name'] as String,
      sowingDate: DateTime.fromMillisecondsSinceEpoch(map['sowingDate'] as int),
      areaInAcres: (map['areaInAcres'] as num).toDouble(),
      soilType: map['soilType'] as String,
      soilPh: (map['soilPh'] as num?)?.toDouble(),
      roadmap: (map['roadmap'] as List<dynamic>? ?? [])
          .map((t) => RoadmapTask.fromMap(Map<String, dynamic>.from(t as Map)))
          .toList(),
    );
  }
}