import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../data/repositories/profile_repository.dart';

class DriverProfileScreen extends ConsumerStatefulWidget {
  const DriverProfileScreen({super.key});

  @override
  ConsumerState<DriverProfileScreen> createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends ConsumerState<DriverProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  List<Map<String, dynamic>> _documents = [];
  Map<String, dynamic>? _assignedVehicle;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    if (profile == null) return;
    
    final docs = await ref.read(profileRepositoryProvider).getDocuments(profile.id);
    final vehicle = await ref.read(profileRepositoryProvider).getAssignedVehicle(profile.id);
    if (mounted) {
      setState(() {
        _documents = docs;
        _assignedVehicle = vehicle;
      });
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxWidth: 800, // Limit width to save storage
      maxHeight: 800,
    );
    if (image == null) return;

    final file = File(image.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > 2 * 1024 * 1024) { // 2 MB limit
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.errorImageTooLarge ?? 'Image is too large. Please select an image under 2MB.')),
        );
      }
      return;
    }

    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    if (profile == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(profileRepositoryProvider).uploadAvatar(profile.id, file);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update picture: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadDocument(String docType) async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 70,
      maxWidth: 1200, // Limit width
      maxHeight: 1200,
    );
    if (image == null) return;

    final file = File(image.path);
    final sizeInBytes = await file.length();
    if (sizeInBytes > 2 * 1024 * 1024) { // 2 MB limit
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n?.errorImageTooLarge ?? 'Document is too large. Please select an image under 2MB.')),
        );
      }
      return;
    }

    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    if (profile == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(profileRepositoryProvider).uploadDocument(profile.id, docType, file);
      await _loadProfileData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Document uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload document: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  void _showEditPhoneDialog() {
    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    if (profile == null) return;
    
    final phoneController = TextEditingController(text: profile.phoneNumber);
    
    showDialog(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context);
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1320),
          title: Text(l10n?.editPhone ?? 'Edit Phone Number', style: const TextStyle(color: Colors.white)),
          content: TextField(
            controller: phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter new phone number',
              hintStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n?.cancel ?? 'Cancel', style: const TextStyle(color: Colors.white54)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                setState(() => _isLoading = true);
                try {
                  await ref.read(profileRepositoryProvider).updatePhoneNumber(profile.id, phoneController.text.trim());
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Phone number updated successfully!')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update phone number: $e')),
                    );
                  }
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              child: Text(l10n?.save ?? 'Save', style: const TextStyle(color: Colors.cyanAccent)),
            ),
          ],
        );
      }
    );
  }

  Future<void> _previewImage(String urlOrPath, {bool isSigned = false, String? bucket}) async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (!isSigned)
                InteractiveViewer(child: Image.network(urlOrPath))
              else
                FutureBuilder<String>(
                  future: ref.read(profileRepositoryProvider).getSignedUrl(bucket!, urlOrPath),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(color: Colors.cyanAccent);
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Text('Failed to load image', style: TextStyle(color: Colors.white));
                    }
                    return InteractiveViewer(child: Image.network(snapshot.data!));
                  },
                ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAvatarOptions() {
    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();
    if (profile == null) return;
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1320),
          title: const Text('Profile Picture', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (profile.avatarUrl != null)
                ListTile(
                  leading: const Icon(Icons.preview, color: Colors.cyanAccent),
                  title: const Text('View Photo', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _previewImage(profile.avatarUrl!);
                  },
                ),
              ListTile(
                leading: const Icon(Icons.upload, color: Colors.cyanAccent),
                title: const Text('Upload New Photo', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _pickAndUploadAvatar();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  void _showUploadDocDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1320),
          title: const Text('Select Document Type', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('NID Card', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _uploadDocument('nid');
                },
              ),
              ListTile(
                title: const Text('Driving License', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _uploadDocument('driving_license');
                },
              ),
              ListTile(
                title: const Text('Other', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Navigator.pop(context);
                  await Future.delayed(const Duration(milliseconds: 300));
                  _uploadDocument('other');
                },
              ),
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authService = ref.read(authServiceProvider);
    final profile = authService.getLocalProfile();

    if (profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF070D14),
        body: Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF070D14),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/driver_bg.jpg'),
                fit: BoxFit.cover,
                opacity: 0.25,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ).copyWith(bottom: 100),
                child: Column(
                  children: [
                    // App Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        24.widthBox, // Spacer
                        (l10n?.profileTitle ?? "MY PROFILE").text.white
                            .letterSpacing(1)
                            .bold
                            .xl
                            .make(),

                        // Language Toggle
                        Container(
                          height: 36,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.cyanAccent.withValues(alpha: 0.3),
                            ),
                            color: Colors.cyanAccent.withValues(alpha: 0.1),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              final current = ref.read(localeProvider);
                              ref.read(localeProvider.notifier).state = Locale(
                                current.languageCode == 'en' ? 'bn' : 'en',
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.language,
                                    size: 16,
                                    color: Colors.cyanAccent,
                                  ),
                                  4.widthBox,
                                  (ref.watch(localeProvider).languageCode == 'en'
                                          ? 'বাং'
                                          : 'EN')
                                      .text
                                      .color(Colors.cyanAccent)
                                      .bold
                                      .make(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    40.heightBox,

                    // Avatar Profile Picture
                    Center(
                      child: GestureDetector(
                        onTap: _showAvatarOptions,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blueAccent],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.cyanAccent.withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: const Color(0xFF0B1320),
                            backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
                            child: profile.avatarUrl == null 
                                ? const Icon(Icons.person, size: 50, color: Colors.cyanAccent)
                                : null,
                          ),
                        ),
                      ),
                    ).animate().scale(delay: 100.ms, duration: 400.ms),
                    16.heightBox,
                    (profile.fullName).text.white.bold.xl3.make(),
                    4.heightBox,
                    "ID: ${profile.employeeId}".text
                        .color(Colors.cyanAccent)
                        .letterSpacing(1)
                        .make(),
                    30.heightBox,

                    // Personal Details Card (Glassmorphism)
                    _buildGlassCard(
                      title: l10n?.personalDetails ?? "PERSONAL DETAILS",
                      icon: Icons.badge_outlined,
                      children: [
                        _buildInfoRow(
                          Icons.phone,
                          l10n?.phoneNumber ?? "Phone Number",
                          profile.phoneNumber,
                          onEdit: _showEditPhoneDialog,
                        ),
                        const Divider(color: Colors.white10, height: 24),
                        _buildInfoRow(
                          Icons.card_membership,
                          l10n?.licenseNo ?? "License No",
                          profile.drivingLicenseNo ?? 'Not Set',
                        ),
                      ],
                    ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),

                    20.heightBox,
                    
                    // Documents Card
                    _buildGlassCard(
                      title: l10n?.myDocuments ?? "MY DOCUMENTS",
                      icon: Icons.folder_special_outlined,
                      action: IconButton(
                        icon: const Icon(Icons.add_circle, color: Colors.cyanAccent),
                        onPressed: _showUploadDocDialog,
                      ),
                      children: [
                        if (_documents.isEmpty)
                          "No documents uploaded".text.color(Colors.white54).make()
                        else
                          ..._documents.map((doc) {
                            Color statusColor = Colors.orangeAccent;
                            String statusText = l10n?.statusPending ?? 'Pending';
                            if (doc['status'] == 'verified') {
                              statusColor = Colors.greenAccent;
                              statusText = l10n?.statusVerified ?? 'Verified';
                            } else if (doc['status'] == 'rejected') {
                              statusColor = Colors.redAccent;
                              statusText = l10n?.statusRejected ?? 'Rejected';
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: InkWell(
                                onTap: () => _previewImage(doc['file_url'], isSigned: true, bucket: 'driver_documents'),
                                child: Row(
                                  children: [
                                    const Icon(Icons.description, color: Colors.white70, size: 24),
                                    12.widthBox,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          (doc['doc_type'] == 'nid' ? 'NID Card' : doc['doc_type'] == 'driving_license' ? 'Driving License' : 'Other Document').text.white.make(),
                                          4.heightBox,
                                          statusText.text.color(statusColor).size(12).make(),
                                        ],
                                      ),
                                    ),
                                    const Icon(Icons.visibility, color: Colors.white30, size: 20),
                                  ],
                                ),
                              ),
                            );
                          }),
                      ],
                    ).animate().fade(delay: 250.ms).slideY(begin: 0.1, end: 0),
                    
                    20.heightBox,

                    // Assigned Vehicle Card
                    _buildGlassCard(
                      title: l10n?.assignedVehicle ?? "ASSIGNED VEHICLE",
                      icon: Icons.directions_car_outlined,
                      children: _assignedVehicle == null
                          ? ["No vehicle assigned yet.".text.color(Colors.white54).make()]
                          : [
                              _buildInfoRow(
                                Icons.local_taxi,
                                l10n?.vehicleModel ?? "Vehicle Model",
                                _assignedVehicle!['model'] ?? 'Unknown',
                              ),
                              const Divider(color: Colors.white10, height: 24),
                              _buildInfoRow(
                                Icons.pin,
                                l10n?.plateNumber ?? "Plate Number",
                                _assignedVehicle!['plate_number'] ?? 'Unknown',
                              ),
                              const Divider(color: Colors.white10, height: 24),
                              _buildInfoRow(
                                Icons.local_gas_station,
                                l10n?.fuelType ?? "Fuel Type",
                                _assignedVehicle!['fuel_type'] ?? 'Unknown',
                              ),
                            ],
                    ).animate().fade(delay: 300.ms).slideY(begin: 0.1, end: 0),

                    40.heightBox,

                    // Logout Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Implement actual logout logic
                          context.go('/login');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                          foregroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: const BorderSide(
                              color: Colors.redAccent,
                              width: 1.5,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.logout),
                            8.widthBox,
                            (l10n?.logout ?? "LOGOUT").text.bold
                                .letterSpacing(1)
                                .make(),
                          ],
                        ),
                      ),
                    ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),

                    20.heightBox,
                  ],
                ),
              ),
            ),
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
    Widget? action,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.cyanAccent, size: 20),
                  8.widthBox,
                  Expanded(
                    child: title.text
                        .color(Colors.cyanAccent)
                        .bold
                        .letterSpacing(1)
                        .make(),
                  ),
                  if (action != null) action,
                ],
              ),
              if (action == null) 16.heightBox,
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {VoidCallback? onEdit}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        16.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label.text.color(Colors.white54).size(12).make(),
              2.heightBox,
              value.text.white.bold.make(),
            ],
          ),
        ),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.cyanAccent, size: 20),
            onPressed: onEdit,
          ),
      ],
    );
  }
}
