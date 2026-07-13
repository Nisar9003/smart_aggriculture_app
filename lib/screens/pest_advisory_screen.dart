import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/pest_advisory_data.dart';
import '../services/web_search_service.dart';
import '../theme/app_theme.dart';

class PestAdvisoryScreen extends StatefulWidget {
  final String cropName;
  const PestAdvisoryScreen({super.key, required this.cropName});

  @override
  State<PestAdvisoryScreen> createState() => _PestAdvisoryScreenState();
}

class _PestAdvisoryScreenState extends State<PestAdvisoryScreen> {
  final _searchController = TextEditingController();
  final _webSearchService = WebSearchService();

  Uint8List? _photoBytes;
  bool _pickingPhoto = false;
  bool _webSearching = false;
  Map<String, String>? _webResult;
  String? _webError;

  List<PestInfo> get _filtered {
    final all = pestIssuesFor(widget.cropName);
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return all;
    return all
        .where((p) =>
            p.name.toLowerCase().contains(query) || p.symptoms.toLowerCase().contains(query))
        .toList();
  }

  Future<void> _pickPhoto() async {
    setState(() => _pickingPhoto = true);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
      if (file != null) {
        final bytes = await file.readAsBytes();
        setState(() => _photoBytes = bytes);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tasveer nahi li ja saki: $e")),
      );
    } finally {
      if (mounted) setState(() => _pickingPhoto = false);
    }
  }

  Future<void> _searchWeb() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    setState(() {
      _webSearching = true;
      _webError = null;
      _webResult = null;
    });
    try {
      final result = await _webSearchService.fetchSummary("$query ${widget.cropName} crop disease pest");
      setState(() {
        _webResult = result;
        _webSearching = false;
        if (result == null) _webError = "Web par bhi kuch nahi mila. Symptom ka naam badal kar try karein.";
      });
    } catch (e) {
      setState(() {
        _webSearching = false;
        _webError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  void _showDetail(PestInfo issue) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(issue.name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _detailRow(Icons.visibility, "Alamaat", issue.symptoms),
            const SizedBox(height: 10),
            _detailRow(Icons.science, "Spray/Pesticide", issue.pesticide),
            const SizedBox(height: 10),
            _detailRow(Icons.info_outline, "Tareeqa", issue.dosageNote),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                "⚠ Hamesha packet par diye gaye label/instructions follow karein, "
                "sahi safety kit (mask, gloves) pehnein, aur agar confirm na ho to "
                "apne nazdeeki Agriculture Extension office se rabta karein.",
                style: TextStyle(fontSize: 12, color: AppColors.textDark),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Theek Hai"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(color: AppColors.textDark, fontSize: 14),
              children: [
                TextSpan(text: "$label: ", style: const TextStyle(fontWeight: FontWeight.w700)),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Bimari / Kira Advisory")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Fasal: ${widget.cropName}", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            "${pestIssuesFor(widget.cropName).length} common masail is fasal ke liye list mein hain. "
            "Neeche select karein ya symptom type kar ke search karein.",
            style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
          const SizedBox(height: 16),

          Text("Tasveer Attach Karein (optional)", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text(
            "Note: Ye tasveer sirf aapke record ke liye hai — abhi automatic "
            "tasveer se bimari pehchan available nahi.",
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 8),
          if (_photoBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_photoBytes!, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _pickingPhoto ? null : _pickPhoto,
            icon: const Icon(Icons.camera_alt_outlined),
            label: Text(_photoBytes == null ? "Tasveer Chunein" : "Tasveer Badlein"),
          ),

          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {
              _webResult = null;
              _webError = null;
            }),
            decoration: const InputDecoration(
              hintText: "Symptom likhein, jese: peela, chhed, makhi...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: 16),

          if (_filtered.isEmpty) ...[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(child: Text("Hamari list mein ye masla nahi mila.")),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _webSearching ? null : _searchWeb,
                icon: _webSearching
                    ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.travel_explore),
                label: Text(_webSearching ? "Search ho raha hai..." : "Web se Search Karein"),
              ),
            ),
            if (_webError != null) ...[
              const SizedBox(height: 10),
              Text(_webError!, style: const TextStyle(color: AppColors.danger, fontSize: 13)),
            ],
            if (_webResult != null) ...[
              const SizedBox(height: 12),
              Card(
                color: AppColors.background,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.travel_explore, size: 18, color: AppColors.primary),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(_webResult!['title']!,
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(_webResult!['extract']!, style: const TextStyle(fontSize: 13)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.danger.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "⚠ Ye general/live web info hai — humari curated list jaisi "
                          "verified pesticide dosage nahi. Spray se pehle apne nazdeeki "
                          "Agriculture Extension office se confirm karein.",
                          style: TextStyle(fontSize: 11, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ] else
            ..._filtered.map(
              (issue) => Card(
                child: ListTile(
                  leading: const Icon(Icons.bug_report, color: AppColors.secondary),
                  title: Text(issue.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(issue.symptoms, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showDetail(issue),
                ),
              ),
            ),
        ],
      ),
    );
  }
}