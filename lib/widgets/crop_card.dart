import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../theme/app_theme.dart';

class CropCard extends StatelessWidget {
  final Crop crop;
  final VoidCallback onTap;

  const CropCard({super.key, required this.crop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final next = crop.nextTask;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.grass, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(crop.name, style: Theme.of(context).textTheme.titleMedium),
                        Text(
                          "Kasht: ${DateFormat('dd MMM yyyy').format(crop.sowingDate)} • ${crop.areaInAcres} acre",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: AppColors.textMuted),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: crop.progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFE3E9E2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.success),
                ),
              ),
              const SizedBox(height: 8),
              if (next != null)
                Text(
                  "Agla kaam: ${next.title} — ${DateFormat('dd MMM').format(next.dueDate)}",
                  style: const TextStyle(fontSize: 13, color: AppColors.textDark),
                )
              else
                const Text("Tamam roadmap complete ✅", style: TextStyle(fontSize: 13, color: AppColors.success)),
            ],
          ),
        ),
      ),
    );
  }
}
