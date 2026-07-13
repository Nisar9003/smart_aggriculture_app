import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../theme/app_theme.dart';
import '../widgets/weather_card.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  IconData _iconFor(String condition) {
    if (condition.contains("Rain")) return Icons.beach_access;
    if (condition.contains("Cloud")) return Icons.cloud;
    return Icons.wb_sunny;
  }

  @override
  Widget build(BuildContext context) {
    final data = AppData.instance;
    return Scaffold(
      appBar: AppBar(title: const Text("Mausam (Weather)")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          WeatherCard(weather: data.currentWeather),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Text(
              "Data source (Phase 4): OpenWeatherMap API — abhi mock hai.",
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 20),
          Text("Agle 5 Din", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...data.forecast.map(
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
    );
  }
}
