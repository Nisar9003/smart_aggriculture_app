import 'dart:convert';
import 'package:http/http.dart' as http;

/// Talks to SoilGrids (ISRIC) — a free, no-API-key soil database.
/// Matches the "Soil Data" external API box in the proposal's
/// architecture diagram. Given a GPS point, returns an approximate
/// soil type + pH for the top layer (0-5cm).
class SoilService {
  static const _baseUrl = 'https://rest.isric.org/soilgrids/v2.0/properties/query';

  Future<Map<String, dynamic>> fetchSoilData(double lat, double lon) async {
    final url = Uri.parse(
      '$_baseUrl?lon=$lon&lat=$lat&property=phh2o&property=sand&property=clay&property=silt&depth=0-5cm&value=mean',
    );
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Zameen ka data nahi mil saka (error ${res.statusCode}).');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final layers = data['properties']['layers'] as List;

    double? _valueFor(String name) {
      final layer = layers.firstWhere(
        (l) => l['name'] == name,
        orElse: () => null,
      );
      if (layer == null) return null;
      final depths = layer['depths'] as List;
      if (depths.isEmpty) return null;
      final mean = depths.first['values']['mean'];
      if (mean == null) return null;
      return (mean as num).toDouble();
    }

    final sandRaw = _valueFor('sand');
    final clayRaw = _valueFor('clay');
    final siltRaw = _valueFor('silt');
    final phRaw = _valueFor('phh2o');

    if (sandRaw == null || clayRaw == null || siltRaw == null) {
      throw Exception('Is location ke liye soil data available nahi hai.');
    }

    // SoilGrids returns these scaled by 10 (g/kg, i.e. per-mille) — divide
    // by 10 to get an approximate percentage.
    final sand = sandRaw / 10;
    final clay = clayRaw / 10;
    final silt = siltRaw / 10;
    final ph = phRaw != null ? phRaw / 10 : null;

    return {
      'soilType': _classify(sand, clay, silt),
      'sandPercent': sand.round(),
      'clayPercent': clay.round(),
      'siltPercent': silt.round(),
      'ph': ph,
    };
  }

  String _classify(double sand, double clay, double silt) {
    // Simplified texture classification (not the full USDA triangle,
    // but close enough to give a farmer a useful category).
    if (clay >= 40) return 'Chikni Mitti (Clay Soil)';
    if (sand >= 70) return 'Retli Mitti (Sandy Soil)';
    if (silt >= 80) return 'Silty Soil';
    if (clay >= 27 && sand <= 45) return 'Clay Loam';
    if (sand >= 45 && clay < 27) return 'Sandy Loam';
    return 'Domat Mitti (Loamy Soil)';
  }
}