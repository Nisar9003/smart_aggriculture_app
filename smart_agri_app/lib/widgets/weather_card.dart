import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weather;
  final VoidCallback? onTap;

  const WeatherCard({super.key, required this.weather, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Aaj ka Mausam", style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(
                    "${weather['tempC']}°C",
                    style: const TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w700),
                  ),
                  Text(weather['condition'], style: const TextStyle(color: Colors.white, fontSize: 15)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _pill(Icons.water_drop, "${weather['humidity']}%"),
                const SizedBox(height: 8),
                _pill(Icons.air, "${weather['windKph']} km/h"),
                const SizedBox(height: 8),
                _pill(Icons.umbrella, "${weather['rainChance']}% barish"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    );
  }
}
