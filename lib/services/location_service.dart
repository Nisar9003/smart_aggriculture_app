import 'package:geolocator/geolocator.dart';

/// Wraps device/browser GPS access. Used by Weather (Phase 4) now, and
/// will be reused by the Soil Data module (Phase 5) later — same
/// location, two different APIs consuming it.
class LocationService {
  Future<Position> getCurrentLocation() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services band hain. Device/browser settings mein location on karein.');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission allow nahi ki gayi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission hamesha ke liye band hai. Settings se allow karein.');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
    );
  }
}