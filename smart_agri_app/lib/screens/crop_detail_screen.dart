import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/crop_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/task_tile.dart';

class CropDetailScreen extends StatelessWidget {
  final String cropId;
  final CropRepository cropRepo;
  const CropDetailScreen({super.key, required this.cropId, required this.cropRepo});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cropRepo,
      builder: (context, _) {
        final crop = cropRepo.crops.firstWhere((c) => c.id == cropId);
        return Scaffold(
          appBar: AppBar(title: Text(crop.name)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoChip(Icons.event, "Kasht", DateFormat('dd MMM yyyy').format(crop.sowingDate)),
                          _infoChip(Icons.crop_square, "Rakba", "${crop.areaInAcres} acre"),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _infoChip(Icons.terrain, "Zameen", crop.soilType),
                      const SizedBox(height: 16),
                      Text("Progress: ${(crop.progress * 100).toStringAsFixed(0)}%",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: crop.progress,
                          minHeight: 10,
                          backgroundColor: const Color(0xFFE3E9E2),
                          valueColor: const AlwaysStoppedAnimation(AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text("Smart Roadmap", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              const Text(
                "Neeche checklist par tap karein jab wo kaam mukammal ho jaye.",
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              ...crop.roadmap.map(
                (task) => TaskTile(
                  task: task,
                  onToggle: () => cropRepo.toggleTask(crop.id, task.id),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoChip(IconData icon, String label, String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 4),
        Text("$label: ", style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
