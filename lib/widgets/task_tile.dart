import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';

IconData _iconFor(TaskType type) {
  switch (type) {
    case TaskType.water:
      return Icons.water_drop;
    case TaskType.fertilizer:
      return Icons.eco;
    case TaskType.spray:
      return Icons.bug_report;
    case TaskType.harvest:
      return Icons.agriculture;
    case TaskType.other:
      return Icons.task_alt;
  }
}

class TaskTile extends StatelessWidget {
  final RoadmapTask task;
  final VoidCallback onToggle;
  /// Phase 6: live rain-based warning (e.g. "Barish ka chance hai — pani
  /// na lagayen"), computed by the caller from the 5-day forecast. Only
  /// ever set for near-term water tasks — null otherwise.
  final String? rainWarning;

  const TaskTile({super.key, required this.task, required this.onToggle, this.rainWarning});

  @override
  Widget build(BuildContext context) {
    final overdue = !task.isDone && task.dueDate.isBefore(DateTime.now());
    return Card(
      child: ListTile(
        onTap: onToggle,
        leading: CircleAvatar(
          backgroundColor: task.isDone ? AppColors.success.withOpacity(0.15) : AppColors.secondary.withOpacity(0.15),
          child: Icon(
            task.isDone ? Icons.check : _iconFor(task.type),
            color: task.isDone ? AppColors.success : AppColors.secondary,
          ),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${task.subtitle ?? ''}\nTareekh: ${DateFormat('dd MMM yyyy').format(task.dueDate)}"
              "${overdue ? '  •  Miyad guzar gayi' : ''}",
              style: TextStyle(color: overdue ? AppColors.danger : AppColors.textMuted),
            ),
            if (rainWarning != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  rainWarning!,
                  style: const TextStyle(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
          ],
        ),
        isThreeLine: true,
        trailing: Checkbox(value: task.isDone, onChanged: (_) => onToggle()),
      ),
    );
  }
}