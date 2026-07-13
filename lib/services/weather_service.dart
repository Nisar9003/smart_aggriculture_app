import 'dart:convert';
import 'package:http/http.dart' as http;

/// Talks to OpenWeatherMap (free tier) — matches the "Weather Data"
/// external API box in the proposal's architecture diagram.
class WeatherService {
  // Phase 4: OpenWeatherMap free-tier API key.
  static const _apiKey = 'YOUR_API_KEY_HERE'; // Replace with your actual API key
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> fetchCurrentWeather(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=en',
    );
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception(_friendlyError(res.statusCode, res.body));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final weather = (data['weather'] as List).first as Map<String, dynamic>;
    final rainMm = (data['rain'] as Map?)?['1h'] as num? ?? 0;

    return {
      'tempC': (data['main']['temp'] as num).round(),
      'condition': _translateCondition(weather['main'] as String, weather['description'] as String),
      'humidity': data['main']['humidity'],
      'windKph': ((data['wind']['speed'] as num) * 3.6).round(),
      'rainChance': rainMm > 0 ? 60 : 10, // current-weather endpoint has no pop; rough estimate
      'cityName': data['name'],
    };
  }

  Future<List<Map<String, dynamic>>> fetchForecast(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=en',
    );
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception(_friendlyError(res.statusCode, res.body));
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final list = data['list'] as List;

    final todayStr = DateTime.now().toIso8601String().split('T')[0];
    final Map<String, Map<String, dynamic>> byDate = {};
    for (final item in list) {
      final map = item as Map<String, dynamic>;
      final dtTxt = map['dt_txt'] as String; // "2026-07-11 12:00:00"
      final date = dtTxt.split(' ')[0];
      if (date == todayStr) continue;
      final hour = dtTxt.split(' ')[1];
      if (!byDate.containsKey(date) || hour.startsWith('12:00')) {
        byDate[date] = map;
      }
    }

    final dates = byDate.keys.toList()..sort();
    const dayLabels = ["Kal", "Parso", "Din 3", "Din 4", "Din 5", "Din 6"];
    final result = <Map<String, dynamic>>[];
    for (var i = 0; i < dates.length && i < 5; i++) {
      final item = byDate[dates[i]]!;
      final weather = (item['weather'] as List).first as Map<String, dynamic>;
      result.add({
        'date': dates[i],
        'day': i < dayLabels.length ? dayLabels[i] : dates[i],
        'high': (item['main']['temp_max'] as num).round(),
        'low': (item['main']['temp_min'] as num).round(),
        'rain': (((item['pop'] as num?) ?? 0) * 100).round(),
        'condition': _translateCondition(weather['main'] as String, weather['description'] as String),
      });
    }
    return result;
  }

  String _translateCondition(String main, String description) {
    switch (main) {
      case 'Clear':
        return 'Dhoop / Sunny';
      case 'Clouds':
        return 'Baadal / Cloudy';
      case 'Rain':
        return 'Barish / Rain';
      case 'Drizzle':
        return 'Halki Barish / Drizzle';
      case 'Thunderstorm':
        return 'Toofan / Thunderstorm';
      case 'Snow':
        return 'Barf / Snow';
      case 'Mist':
      case 'Fog':
      case 'Haze':
        return 'Dhund / Fog';
      default:
        return description;
    }
  }

  String _friendlyError(int statusCode, String body) {
    if (statusCode == 401) {
      return 'API key abhi active nahi hui (nayi keys ko 10 min - 2 ghante lagte hain). Thori dair mein dobara koshish karein.';
    }
    return 'Mausam data nahi mil saka (error $statusCode).';
  }
}