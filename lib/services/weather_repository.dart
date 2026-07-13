import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

import 'location_service.dart';
import 'weather_service.dart';

class WeatherRepository extends ChangeNotifier {
  WeatherRepository({WeatherService? weatherService, LocationService? locationService})
      : _weatherService = weatherService ?? WeatherService(),
        _locationService = locationService ?? LocationService();

  static final WeatherRepository instance = WeatherRepository();

  final WeatherService _weatherService;
  final LocationService _locationService;
  bool _disposed = false;

  bool isLoading = false;
  Map<String, dynamic>? current;
  List<Map<String, dynamic>> forecast = [];
  String? error;
  String? cityName;
  bool usedFallbackLocation = false;

  Future<void> loadIfNeeded() async {
    if (current != null && error == null) {
      return;
    }
    await refresh();
  }

  Future<void> refresh() async {
    isLoading = true;
    error = null;
    _notifySafely();

    try {
      final location = await _resolveLocation();
      final currentWeather = await _weatherService.fetchCurrentWeather(location.lat, location.lon);
      final forecastData = await _weatherService.fetchForecast(location.lat, location.lon);

      current = currentWeather;
      forecast = forecastData;
      cityName = currentWeather['cityName'] as String?;
      usedFallbackLocation = location.usedFallback;
      error = null;
    } catch (e) {
      current = null;
      forecast = [];
      cityName = null;
      usedFallbackLocation = true;
      error = e.toString();
    } finally {
      isLoading = false;
      _notifySafely();
    }
  }

  Future<_LocationResult> _resolveLocation() async {
    try {
      final position = await _locationService.getCurrentLocation();
      return _LocationResult(position.latitude, position.longitude, false);
    } catch (e) {
      debugPrint('Location unavailable, using fallback weather location: $e');
      return const _LocationResult(31.5204, 74.3587, true);
    }
  }

  void _notifySafely() {
    if (_disposed) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

class _LocationResult {
  const _LocationResult(this.lat, this.lon, this.usedFallback);

  final double lat;
  final double lon;
  final bool usedFallback;
}
