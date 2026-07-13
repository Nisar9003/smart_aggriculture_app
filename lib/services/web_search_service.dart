import 'dart:convert';
import 'package:http/http.dart' as http;

/// Free, no-API-key fallback for when a farmer's typed symptom/disease
/// isn't in our local list (pest_advisory_data.dart). Uses Wikipedia's
/// public search API to pull a real-time summary.
///
/// Honesty note: this gives GENERAL background info, not a verified
/// pesticide dosage recommendation the way our curated local list does.
/// The UI must make that distinction clear to the farmer.
class WebSearchService {
  static const _baseUrl = 'https://en.wikipedia.org/w/api.php';

  Future<Map<String, String>?> fetchSummary(String query) async {
    final url = Uri.parse(_baseUrl).replace(queryParameters: {
      'action': 'query',
      'generator': 'search',
      'gsrsearch': query,
      'gsrlimit': '1',
      'prop': 'extracts',
      'exintro': 'true',
      'explaintext': 'true',
      'format': 'json',
      'origin': '*',
    });

    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception('Web search nahi ho saka (error ${res.statusCode}).');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final pages = data['query']?['pages'] as Map<String, dynamic>?;
    if (pages == null || pages.isEmpty) return null;

    final page = pages.values.first as Map<String, dynamic>;
    final title = page['title'] as String? ?? query;
    final extract = (page['extract'] as String? ?? '').trim();
    if (extract.isEmpty) return null;

    return {
      'title': title,
      'extract': extract,
    };
  }
}