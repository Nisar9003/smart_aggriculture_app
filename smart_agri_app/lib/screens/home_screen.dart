import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../services/crop_repository.dart';
import '../widgets/weather_card.dart';
import '../widgets/crop_card.dart';
import 'weather_screen.dart';
import 'crop_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final CropRepository cropRepo;
  const HomeScreen({super.key, required this.cropRepo});

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;

    return AnimatedBuilder(
      animation: cropRepo,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: Text("As-Salam-o-Alaikum")),
          body: cropRepo.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                  children: [
                    WeatherCard(
                      weather: data.currentWeather,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const WeatherScreen()),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text("Meri Fasalein (My Crops)", style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (cropRepo.crops.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: Text("Abhi tak koi fasal add nahi ki. Neeche button se add karein.")),
                      )
                    else
                      ...cropRepo.crops.map(
                        (crop) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: CropCard(
                            crop: crop,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => CropDetailScreen(cropId: crop.id, cropRepo: cropRepo),
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
}
