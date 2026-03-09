import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';

class ReportAccidentPage extends StatefulWidget {
  const ReportAccidentPage({super.key});

  @override
  State<ReportAccidentPage> createState() => _ReportAccidentPageState();
}

class _ReportAccidentPageState extends State<ReportAccidentPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _selectedSeverity = 'Minor';
  String? _attachedImagePath;
  bool _usingCurrentLocation = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Accident report submitted (mock). Backend later.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.reportAccidentTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Accident details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Describe what happened',
                  alignLabelWithHint: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a short description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedSeverity,
                decoration: const InputDecoration(labelText: 'Severity'),
                items: const [
                  DropdownMenuItem(value: 'Minor', child: Text('Minor')),
                  DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
                  DropdownMenuItem(value: 'Severe', child: Text('Severe')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _selectedSeverity = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Use current GPS location'),
                value: _usingCurrentLocation,
                onChanged: (value) {
                  setState(() => _usingCurrentLocation = value);
                  // Later: use geolocator to get location
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo_camera),
                    label: const Text('Attach photo'),
                    onPressed: () {
                      // Later: use image_picker
                      setState(() {
                        _attachedImagePath = 'mock/path.jpg';
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  if (_attachedImagePath != null) ...[
                    const Icon(Icons.check_circle, size: 20),
                    const SizedBox(width: 4),
                    const Text('Image attached'),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Submit Report'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}