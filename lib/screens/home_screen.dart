import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/crop_repository.dart';
import '../services/weather_repository.dart';
import '../widgets/weather_card.dart';
import '../widgets/crop_card.dart';
import '../theme/app_theme.dart';
import 'weather_screen.dart';
import 'crop_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final CropRepository cropRepo;
  const HomeScreen({super.key, required this.cropRepo});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _weatherRepo = WeatherRepository.instance;

  @override
  void initState() {
    super.initState();
    _weatherRepo.loadIfNeeded();
  }

  Future<bool> _confirmDelete(BuildContext context, String cropName, DateTime sowingDate) async {
    return await showDialog<bool>(
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.cropRepo, _weatherRepo]),
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text("As-Salam-o-Alaikum")),
          body: widget.cropRepo.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  children: [
                    _buildWeatherSection(context),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Meri Fasalein (My Crops)", style: Theme.of(context).textTheme.titleMedium),
                        if (widget.cropRepo.crops.isNotEmpty)
                          const Text("← Delete karne ke liye swipe karein", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (widget.cropRepo.crops.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: Text("Abhi tak koi fasal add nahi ki. Neeche button se add karein.")),
                      )
                    else
                      ...widget.cropRepo.crops.map(
                        (crop) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Dismissible(
                            key: ValueKey(crop.id),
                            direction: DismissDirection.endToStart,
                            confirmDismiss: (_) => _confirmDelete(context, crop.name, crop.sowingDate),
                            onDismissed: (_) => widget.cropRepo.deleteCrop(crop.id),
                            background: Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.centerRight,
                              decoration: BoxDecoration(color: AppColors.danger, borderRadius: BorderRadius.circular(16)),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: CropCard(
                              crop: crop,
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CropDetailScreen(cropId: crop.id, cropRepo: widget.cropRepo),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildWeatherSection(BuildContext context) {
    if (_weatherRepo.isLoading && _weatherRepo.current == null) {
      return const SizedBox(
        height: 130,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_weatherRepo.error != null && _weatherRepo.current == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Mausam load nahi ho saka.", style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(_weatherRepo.error!, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _weatherRepo.refresh, child: const Text("Dobara Koshish Karein")),
            ],
          ),
        ),
      );
    }
    return WeatherCard(
      weather: _weatherRepo.current!,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const WeatherScreen()),
      ),
    );
  }
}