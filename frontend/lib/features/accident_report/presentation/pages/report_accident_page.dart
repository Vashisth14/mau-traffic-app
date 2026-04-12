import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ReportAccidentPage extends StatefulWidget {
  const ReportAccidentPage({super.key});

  @override
  State<ReportAccidentPage> createState() => _ReportAccidentPageState();
}

class _ReportAccidentPageState extends State<ReportAccidentPage> {
  final _formKey = GlobalKey<FormState>();

  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _roadController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  String _selectedSeverity = 'Moderate';
  String _selectedVehicleType = 'Car';
  bool _useCurrentLocation = false;
  bool _injuryReported = false;
  bool _roadBlocked = false;

  File? _selectedImageFile;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    _roadController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (picked == null) return;

      setState(() {
        _selectedImageFile = File(picked.path);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> _showImageSourcePicker() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_rounded),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_rounded),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              if (_selectedImageFile != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded),
                  title: const Text('Remove image'),
                  onTap: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedImageFile = null;
                    });
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final dio = Dio();

      final formData = FormData.fromMap({
        'location': _locationController.text.trim(),
        'road': _roadController.text.trim(),
        'description': _descriptionController.text.trim(),
        'severity': _selectedSeverity,
        'vehicleType': _selectedVehicleType,
        'injuryReported': _injuryReported.toString(),
        'roadBlocked': _roadBlocked.toString(),
        'useCurrentLocation': _useCurrentLocation.toString(),
        if (_selectedImageFile != null)
          'image': await MultipartFile.fromFile(
            _selectedImageFile!.path,
            filename: _selectedImageFile!.path.split('/').last,
          ),
      });

      final response = await dio.post(
        'http://10.0.2.2:5000/api/accidents',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Report submitted successfully'),
          ),
        );

        _formKey.currentState?.reset();
        _descriptionController.clear();
        _locationController.clear();
        _roadController.clear();

        setState(() {
          _selectedSeverity = 'Moderate';
          _selectedVehicleType = 'Car';
          _useCurrentLocation = false;
          _injuryReported = false;
          _roadBlocked = false;
          _selectedImageFile = null;
        });
      }
    } on DioException catch (e) {
      if (!mounted) return;

      final serverMessage =
          e.response?.data?['message']?.toString() ??
          e.response?.data.toString() ??
          e.message ??
          'Unknown error';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $serverMessage')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: $e')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _descriptionController.clear();
    _locationController.clear();
    _roadController.clear();

    setState(() {
      _selectedSeverity = 'Moderate';
      _selectedVehicleType = 'Car';
      _useCurrentLocation = false;
      _injuryReported = false;
      _roadBlocked = false;
      _selectedImageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF7F9FC),
              Color(0xFFEAF4FF),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded),
                            ),
                            const Expanded(
                              child: Text(
                                'Report Accident',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF003C8F),
                                Color(0xFF0A84C6),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.flag_circle_rounded, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Mauritius Incident Reporting',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Report road incidents quickly and help improve traffic awareness across Mauritian roads.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.35,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Provide the location, vehicle details and a short description so the report can be processed accurately.',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13.5,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const _SectionTitle(
                        title: 'Incident Details',
                        icon: Icons.warning_amber_rounded,
                      ),
                      const SizedBox(height: 12),
                      _StyledTextField(
                        controller: _locationController,
                        label: 'Location',
                        hint: 'e.g. Terre Rouge, Port Louis, Rose Hill, Bambous',
                        prefixIcon: Icons.location_on_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the accident location';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      _StyledTextField(
                        controller: _roadController,
                        label: 'Road / Area',
                        hint: 'e.g. M1 Motorway, Royal Road, Ring Road',
                        prefixIcon: Icons.alt_route_rounded,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter the road or area';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedSeverity,
                        decoration: _inputDecoration(
                          label: 'Severity Level',
                          icon: Icons.report_problem_rounded,
                        ),
                        borderRadius: BorderRadius.circular(16),
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
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedVehicleType,
                        decoration: _inputDecoration(
                          label: 'Vehicle Type',
                          icon: Icons.directions_car_rounded,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        items: const [
                          DropdownMenuItem(value: 'Car', child: Text('Car')),
                          DropdownMenuItem(value: 'Van', child: Text('Van')),
                          DropdownMenuItem(value: 'Bus', child: Text('Bus')),
                          DropdownMenuItem(value: 'Motorcycle', child: Text('Motorcycle')),
                          DropdownMenuItem(value: 'Truck', child: Text('Truck')),
                          DropdownMenuItem(
                            value: 'Multiple Vehicles',
                            child: Text('Multiple Vehicles'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedVehicleType = value);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle(
                        title: 'Description',
                        icon: Icons.description_rounded,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                        decoration: _inputDecoration(
                          label: 'Describe the incident',
                          icon: Icons.edit_note_rounded,
                          hint:
                              'Example: Collision between two vans near Terre Rouge. Traffic is slow and one lane is partially blocked.',
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a short incident description';
                          }
                          if (value.trim().length < 10) {
                            return 'Description is too short';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle(
                        title: 'Additional Information',
                        icon: Icons.info_outline_rounded,
                      ),
                      const SizedBox(height: 12),
                      _SwitchCard(
                        title: 'Use current GPS location',
                        subtitle: 'Automatically attach the current location of the incident.',
                        icon: Icons.my_location_rounded,
                        value: _useCurrentLocation,
                        onChanged: (value) {
                          setState(() => _useCurrentLocation = value);
                        },
                      ),
                      _SwitchCard(
                        title: 'Injury reported',
                        subtitle: 'Enable this if there may be injured road users.',
                        icon: Icons.health_and_safety_rounded,
                        value: _injuryReported,
                        onChanged: (value) {
                          setState(() => _injuryReported = value);
                        },
                      ),
                      _SwitchCard(
                        title: 'Road partially or fully blocked',
                        subtitle: 'Enable this if traffic flow is affected at the location.',
                        icon: Icons.aod_rounded,
                        value: _roadBlocked,
                        onChanged: (value) {
                          setState(() => _roadBlocked = value);
                        },
                      ),
                      const SizedBox(height: 20),
                      const _SectionTitle(
                        title: 'Photo Evidence',
                        icon: Icons.camera_alt_rounded,
                      ),
                      const SizedBox(height: 12),
                      _ImageUploadCard(
                        imageFile: _selectedImageFile,
                        onTap: _showImageSourcePicker,
                      ),
                      const SizedBox(height: 26),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _submitReport,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(_isSubmitting ? 'Submitting...' : 'Submit Report'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isSubmitting ? null : _clearForm,
                        icon: const Icon(Icons.restart_alt_rounded),
                        label: const Text('Clear Form'),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF0057B8).withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF0057B8)),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData prefixIcon;
  final String? Function(String?)? validator;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(prefixIcon),
      ),
      validator: validator,
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: SwitchListTile(
          value: value,
          onChanged: onChanged,
          secondary: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0A84C6).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0A84C6)),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(height: 1.4),
          ),
        ),
      ),
    );
  }
}

class _ImageUploadCard extends StatelessWidget {
  final File? imageFile;
  final VoidCallback onTap;

  const _ImageUploadCard({
    required this.imageFile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasImage = imageFile != null;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 3,
      shadowColor: Colors.black12,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              if (hasImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.file(
                    imageFile!,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 14),
              ] else ...[
                Container(
                  height: 68,
                  width: 68,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD62828).withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add_a_photo_rounded,
                    size: 34,
                    color: Color(0xFFD62828),
                  ),
                ),
                const SizedBox(height: 14),
              ],
              Text(
                hasImage ? 'Image attached successfully' : 'Attach accident photo',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                hasImage
                    ? 'Tap to change or remove the selected image.'
                    : 'Add an image of the road incident to improve verification and analysis.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}