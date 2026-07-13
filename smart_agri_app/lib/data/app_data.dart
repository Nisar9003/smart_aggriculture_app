import 'package:flutter/foundation.dart';

/// Remaining mock data that hasn't moved to a real backend yet.
/// Crops now live in Firestore (see services/crop_repository.dart).
/// Weather is still mock here until Phase 4 (OpenWeatherMap integration).
class AppData extends ChangeNotifier {
  static final AppData instance = AppData._internal();
  AppData._internal();

  String farmerVillage = "Chak No. 45, Faisalabad";

  final Map<String, dynamic> currentWeather = {
    "tempC": 32,
    "condition": "Dhoop / Sunny",
    "humidity": 41,
    "windKph": 14,
    "rainChance": 10,
  };

  final List<Map<String, dynamic>> forecast = [
    {"day": "Kal", "high": 33, "low": 24, "rain": 10, "condition": "Sunny"},
    {"day": "Parso", "high": 31, "low": 23, "rain": 40, "condition": "Cloudy"},
    {"day": "Din 3", "high": 29, "low": 22, "rain": 70, "condition": "Rain"},
    {"day": "Din 4", "high": 30, "low": 22, "rain": 20, "condition": "Cloudy"},
    {"day": "Din 5", "high": 34, "low": 25, "rain": 5, "condition": "Sunny"},
  ];
}
