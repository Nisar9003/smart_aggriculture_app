import 'package:flutter/material.dart';
import '../services/weather_repository.dart';
import '../theme/app_theme.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _repo = WeatherRepository.instance;

  @override
  void initState() {
    super.initState();
    _repo.loadIfNeeded();
  }

  IconData _iconFor(String condition) {
    if (condition.contains("Barish") || condition.contains("Rain")) return Icons.beach_access;
    if (condition.contains("Baadal") || condition.contains("Cloud")) return Icons.cloud;
    if (condition.contains("Dhund") || condition.contains("Fog")) return Icons.foggy;
    if (condition.contains("Toofan")) return Icons.thunderstorm;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _repo,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Mausam (Weather)"),
            actions: [
              IconButton(
                onPressed: _repo.isLoading ? null : _repo.refresh,
                icon: const Icon(Icons.refresh),
                tooltip: "Refresh",
              ),
            ],
          ),
          body: _repo.isLoading && _repo.current == null
              ? const Center(child: CircularProgressIndicator())
              : (_repo.error != null && _repo.current == null)
                  ? _buildError()
                  : RefreshIndicator(
                      onRefresh: _repo.refresh,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_repo.cityName != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8, left: 4),
                              child: Row(
                                children: [
                                  const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                                  const SizedBox(width: 4),
                                  Text(_repo.cityName!, style: const TextStyle(color: AppColors.textMuted)),
                                  if (_repo.usedFallbackLocation) ...[
                                    const SizedBox(width: 6),
                                    const Text("(default location)", style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                  ],
                                ],
                              ),
                            ),
                          WeatherCard(weather: _repo.current!),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.only(left: 4),
                            child: Text(
                              "Live data — OpenWeatherMap API (Phase 4)",
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Text("Agle Din", style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          if (_repo.forecast.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(child: Text("Forecast abhi available nahi.")),
                            )
                          else
                            ..._repo.forecast.map(
                              (d) => Card(
                                child: ListTile(
                                  leading: Icon(_iconFor(d['condition']), color: AppColors.primary),
                                  title: Text(d['day']),
                                  subtitle: Text("${d['condition']} • ${d['rain']}% barish ka chance"),
                                  trailing: Text("${d['high']}° / ${d['low']}°"),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
        );
      },
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 12),
            Text(_repo.error ?? "Mausam load nahi ho saka.", textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _repo.refresh, child: const Text("Dobara Koshish Karein")),
          ],
        ),
      ),
    );
  }
}