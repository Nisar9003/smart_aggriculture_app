import 'package:flutter/foundation.dart';

/// Remaining mock data that hasn't moved to a real backend yet.
/// Weather now comes from WeatherRepository (Phase 4, OpenWeatherMap).
/// Soil/location data is still mock here until Phase 5 (SoilGrids API).
class AppData extends ChangeNotifier {
  static final AppData instance = AppData._internal();
  AppData._internal();

  String farmerVillage = "Chak No. 45, Faisalabad";
}