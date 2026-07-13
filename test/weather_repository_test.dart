import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smart_agri_app/services/location_service.dart';
import 'package:smart_agri_app/services/weather_repository.dart';
import 'package:smart_agri_app/services/weather_service.dart';

class FakeWeatherService extends WeatherService {
  @override
  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon) async {
    return {
      'tempC': 31,
      'condition': 'Sunny',
      'humidity': 55,
      'windKph': 12,
      'rainChance': 10,
      'cityName': 'Faisalabad',
    };
  }

  @override
  Future<List<Map<String, dynamic>>> fetchForecast(double lat, double lon) async {
    return [
      {'day': 'Kal', 'high': 34, 'low': 28, 'rain': 15, 'condition': 'Sunny'},
    ];
  }
}

class FakeLocationService extends LocationService {
  @override
  Future<Position> getCurrentLocation() async {
    return Position(
      longitude: 74.3587,
      latitude: 31.5204,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}

class _InitStateLoader extends StatefulWidget {
  const _InitStateLoader({required this.repository});

  final WeatherRepository repository;

  @override
  State<_InitStateLoader> createState() => _InitStateLoaderState();
}

class _InitStateLoaderState extends State<_InitStateLoader> {
  @override
  void initState() {
    super.initState();
    widget.repository.loadIfNeeded();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

void main() {
  testWidgets('loading weather in initState does not throw during build', (tester) async {
    final repository = WeatherRepository(
      weatherService: FakeWeatherService(),
      locationService: FakeLocationService(),
    );

    await tester.pumpWidget(MaterialApp(home: _InitStateLoader(repository: repository)));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(repository.current, isNotNull);
    expect(repository.isLoading, isFalse);
  });
}
