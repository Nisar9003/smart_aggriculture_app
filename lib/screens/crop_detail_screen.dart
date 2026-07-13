import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/crop_repository.dart';
import '../services/weather_repository.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/task_tile.dart';
import 'pest_advisory_screen.dart';

class CropDetailScreen extends StatelessWidget {
  final String cropId;
  final CropRepository cropRepo;
  const CropDetailScreen({super.key, required this.cropId, required this.cropRepo});

  String? _rainWarningFor(RoadmapTask task) {
    if (task.type != TaskType.water) return null;
    final dateStr = DateFormat('yyyy-MM-dd').format(task.dueDate);
    final forecast = WeatherRepository.instance.forecast;
    final match = forecast.where((f) => f['date'] == dateStr).toList();
    if (match.isEmpty) return null;
    final rain = match.first['rain'] as int? ?? 0;
    if (rain >= 50) {
      return "⚠ Barish ka chance hai ($rain%) — is din pani na lagayen";
    }
    return null;
  }

  Future<void> _confirmAndDelete(BuildContext context, String cropName, DateTime sowingDate) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Fasal Delete Karein?"),
            content: Text(
              "\"$cropName\" (${DateFormat('dd MMM yyyy').format(sowingDate)}) delete kar dein? "
              "Iska poora roadmap aur progress bhi mit jayega — ye wapis nahi aa sakega.",
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text("Delete", style: TextStyle(color: AppColors.danger)),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      await cropRepo.deleteCrop(cropId);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cropRepo,
      builder: (context, _) {
        final crop = cropRepo.crops.firstWhere((c) => c.id == cropId);
        return Scaffold(
          appBar: AppBar(
            title: Text(crop.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: "Fasal Delete Karein",
                onPressed: () => _confirmAndDelete(context, crop.name, crop.sowingDate),
              ),
            ],
          ),
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
                      if (crop.soilPh != null) ...[
                        const SizedBox(height: 10),
                        _infoChip(Icons.science, "pH Level", crop.soilPh!.toStringAsFixed(1)),
                      ],
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
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => PestAdvisoryScreen(cropName: crop.name)),
                ),
                icon: const Icon(Icons.bug_report, color: AppColors.secondary),
                label: const Text("Bimari / Kira? Spray Advice Dekhein"),
              ),
              const SizedBox(height: 20),
              Text("Smart Roadmap", style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              const Text(
                "Neeche checklist par tap karein jab wo kaam mukammal ho jaye. "
                "Agle 5 din ke pani ke kaam mausam se bhi match kiye jate hain.",
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 8),
              ...crop.roadmap.map(
                (task) => TaskTile(
                  task: task,
                  onToggle: () => cropRepo.toggleTask(crop.id, task.id),
                  rainWarning: _rainWarningFor(task),
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