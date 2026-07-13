enum TaskType { water, fertilizer, spray, harvest, other }

/// A single roadmap item, e.g. "Pehla pani lagayen" on a given date.
/// Phase 1: generated from static mock rules.
/// Phase 6 (per proposal): a real rule-based/AI engine will generate these.
/// Phase 2: now serializable so it can live inside a Firestore document.
class RoadmapTask {
  final String id;
  final String title;
  final String? subtitle;
  final DateTime dueDate;
  final TaskType type;
  bool isDone;

  RoadmapTask({
    required this.id,
    required this.title,
    this.subtitle,
    required this.dueDate,
    required this.type,
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'dueDate': dueDate.millisecondsSinceEpoch,
      'type': type.name,
      'isDone': isDone,
    };
  }

  factory RoadmapTask.fromMap(Map<String, dynamic> map) {
    return RoadmapTask(
      id: map['id'] as String,
      title: map['title'] as String,
      subtitle: map['subtitle'] as String?,
      dueDate: DateTime.fromMillisecondsSinceEpoch(map['dueDate'] as int),
      type: TaskType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => TaskType.other,
      ),
      isDone: map['isDone'] as bool? ?? false,
    );
  }
}
