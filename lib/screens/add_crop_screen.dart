import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../services/crop_repository.dart';
import '../services/location_service.dart';
import '../services/soil_service.dart';
import '../theme/app_theme.dart';

const _cropOptions = [
  "Gandum (Wheat)",
  "Chawal (Rice)",
  "Kapas (Cotton)",
  "Ganna (Sugarcane)",
  "Makai (Maize)",
  "Sabziyan (Vegetables)",
];

class AddCropScreen extends StatefulWidget {
  final CropRepository cropRepo;
  const AddCropScreen({super.key, required this.cropRepo});

  @override
  State<AddCropScreen> createState() => _AddCropScreenState();
}

class _AddCropScreenState extends State<AddCropScreen> {
  final _locationService = LocationService();
  final _soilService = SoilService();

  String? _cropName = _cropOptions.first;
  DateTime _sowingDate = DateTime.now();
  final _areaController = TextEditingController(text: "1");

  String? _soilType; // filled after real location + soil fetch
  double? _soilPh;
  bool _fetchingLocation = false;
  String? _locationError;

  bool get _locationFetched => _soilType != null;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _sowingDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) setState(() => _sowingDate = picked);
  }

  Future<void> _fetchLocationAndSoil() async {
    setState(() {
      _fetchingLocation = true;
      _locationError = null;
    });
    try {
      // Phase 5: real GPS location + real SoilGrids (ISRIC) API call.
      final position = await _locationService.getCurrentLocation();
      final soil = await _soilService.fetchSoilData(position.latitude, position.longitude);
      setState(() {
        _soilType = soil['soilType'] as String;
        _soilPh = soil['ph'] as double?;
        _fetchingLocation = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Location li gayi aur zameen ka data hasil kar liya gaya.")),
      );
    } catch (e) {
      setState(() {
        _fetchingLocation = false;
        _locationError = e.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  bool _saving = false;

  Future<void> _save() async {
    final area = double.tryParse(_areaController.text) ?? 1;
    setState(() => _saving = true);
    try {
      await widget.cropRepo.addCrop(
        name: _cropName!,
        sowingDate: _sowingDate,
        areaInAcres: area,
        soilType: _soilType ?? "Namaloom (location select nahi ki)",
        soilPh: _soilPh, 
      );
      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      setState(() => _saving = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Save nahi ho saka: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nai Fasal Add Karein")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Fasal ka naam", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _cropName,
            items: _cropOptions.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _cropName = v),
          ),
          const SizedBox(height: 20),
          Text("Kasht ki Tareekh (Sowing Date)", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          const Text("\"Is date ko maine kasht ki hai\"", style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(prefixIcon: Icon(Icons.calendar_today)),
              child: Text(DateFormat('dd MMMM yyyy').format(_sowingDate)),
            ),
          ),
          const SizedBox(height: 20),
          Text("Rakba (Area in Acres)", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
            controller: _areaController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(suffixText: "acre", prefixIcon: Icon(Icons.crop_square)),
          ),
          const SizedBox(height: 20),
          Text("Zameen ki Location", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: _fetchingLocation ? null : _fetchLocationAndSoil,
            icon: _fetchingLocation
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(_locationFetched ? Icons.check_circle : Icons.my_location),
            label: Text(
              _fetchingLocation
                  ? "Location li ja rahi hai..."
                  : _locationFetched
                      ? "Location li gayi ✓"
                      : "Current Location Use Karein",
            ),
          ),
          if (_locationError != null) ...[
            const SizedBox(height: 8),
            Text(_locationError!, style: const TextStyle(color: AppColors.danger, fontSize: 12)),
          ],
          if (_locationFetched) ...[
            const SizedBox(height: 8),
            Text("Soil: $_soilType", style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            if (_soilPh != null)
              Text("pH level: ${_soilPh!.toStringAsFixed(1)}", style: const TextStyle(color: AppColors.textMuted, fontSize: 13)),
            const Text(
              "Data source: SoilGrids (ISRIC) — Phase 5",
              style: TextStyle(color: AppColors.textMuted, fontSize: 11),
            ),
          ],
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (_cropName == null || _saving) ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text("Fasal Save Karein aur Roadmap Banayein"),
            ),
          ),
        ],
      ),
    );
  }
}