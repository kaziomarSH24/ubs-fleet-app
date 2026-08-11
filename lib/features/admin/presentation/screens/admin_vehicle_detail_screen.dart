import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';

class AdminVehicleDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> vehicle;

  const AdminVehicleDetailScreen({super.key, required this.vehicle});

  @override
  ConsumerState<AdminVehicleDetailScreen> createState() => _AdminVehicleDetailScreenState();
}

class _AdminVehicleDetailScreenState extends ConsumerState<AdminVehicleDetailScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  
  late String _currentStatus;
  late String? _currentDriverId;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.vehicle['status'] as String? ?? 'active';
    _currentDriverId = widget.vehicle['current_driver_id'] as String?;
  }

  Future<void> _updateStatus(String newStatus) async {
    try {
      await ref.read(adminRepositoryProvider).updateVehicleStatus(widget.vehicle['id'], newStatus);
      setState(() => _currentStatus = newStatus);
      ref.invalidate(vehiclesProvider);
      if (mounted) AppSnackbar.showSuccess(context, 'Vehicle status updated');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to update status: $e');
    }
  }

  Future<void> _assignDriver(String? driverId) async {
    try {
      await ref.read(adminRepositoryProvider).assignDriverToVehicle(widget.vehicle['id'], driverId);
      setState(() => _currentDriverId = driverId);
      ref.invalidate(vehiclesProvider);
      if (mounted) AppSnackbar.showSuccess(context, 'Driver assigned successfully');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to assign driver: $e');
    }
  }

  Future<void> _uploadDocument(String docType) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    DateTime? expiryDate;
    
    // Pick Expiry Date
    if (mounted) {
      expiryDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now().add(const Duration(days: 365)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 3650)),
      );
    }

    if (expiryDate == null) return; // cancelled

    setState(() => _isUploading = true);
    try {
      await ref.read(adminRepositoryProvider).uploadVehicleDocument(
        vehicleId: widget.vehicle['id'],
        docType: docType,
        file: File(image.path),
        fileName: image.name,
        expiryDate: expiryDate,
      );
      
      ref.invalidate(vehicleDocumentsProvider(widget.vehicle['id']));
      
      if (mounted) AppSnackbar.showSuccess(context, 'Document uploaded successfully');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to upload document: $e');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(vehicleDocumentsProvider(widget.vehicle['id']));
    final driversAsync = ref.watch(driversProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: Text(widget.vehicle['plate_number'] ?? 'Vehicle Details', style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFF0F172A), Color(0xFF020617)],
                ),
              ),
            ),
          ),
          
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoCard(),
                const SizedBox(height: 24),
                
                // Status Control
                const Text('Vehicle Status', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'active', label: Text('Active'), icon: Icon(LucideIcons.checkCircle2)),
                    ButtonSegment(value: 'workshop', label: Text('Workshop'), icon: Icon(LucideIcons.wrench)),
                  ],
                  selected: {_currentStatus},
                  onSelectionChanged: (set) => _updateStatus(set.first),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return _currentStatus == 'active' ? Colors.cyan.withValues(alpha: 0.3) : Colors.red.withValues(alpha: 0.3);
                      }
                      return Colors.transparent;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      return states.contains(WidgetState.selected) ? Colors.white : Colors.white54;
                    }),
                  ),
                ),
                
                const SizedBox(height: 24),
                // Driver Assignment
                const Text('Assign Driver', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: driversAsync.when(
                    data: (drivers) {
                      return DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          value: _currentDriverId,
                          isExpanded: true,
                          dropdownColor: const Color(0xFF171A24),
                          style: const TextStyle(color: Colors.white),
                          hint: const Text('Select a driver', style: TextStyle(color: Colors.white54)),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('No Driver / Unassign')),
                            ...drivers.map((d) => DropdownMenuItem(
                              value: d['id'] as String,
                              child: Text(d['full_name'] as String),
                            ))
                          ],
                          onChanged: _assignDriver,
                        ),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (e, _) => Text('Error: $e', style: const TextStyle(color: Colors.red)),
                  ),
                ),

                const SizedBox(height: 32),
                
                // Documents Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Documents', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    if (_isUploading) 
                      const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.cyanAccent))
                    else
                      PopupMenuButton<String>(
                        icon: const Icon(LucideIcons.plusCircle, color: Colors.cyanAccent),
                        color: const Color(0xFF171A24),
                        onSelected: _uploadDocument,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: 'fitness', child: Text('Fitness Certificate', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'tax_token', child: Text('Tax Token', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'insurance', child: Text('Insurance', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'route_permit', child: Text('Route Permit', style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: 'other', child: Text('Other', style: TextStyle(color: Colors.white))),
                        ],
                      )
                  ],
                ),
                const SizedBox(height: 16),
                
                docsAsync.when(
                  data: (docs) {
                    if (docs.isEmpty) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No documents uploaded yet.', style: TextStyle(color: Colors.white54)),
                      ));
                    }
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final doc = docs[index];
                        final expiry = doc['expiry_date'] != null ? DateTime.parse(doc['expiry_date']) : null;
                        final isExpired = expiry != null && expiry.isBefore(DateTime.now());
                        
                        return Card(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: Icon(LucideIcons.fileText, color: isExpired ? Colors.redAccent : Colors.cyanAccent),
                            title: Text(doc['doc_type'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              expiry != null ? 'Expires: ${DateFormat.yMMMd().format(expiry)}' : 'No expiry',
                              style: TextStyle(color: isExpired ? Colors.redAccent : Colors.white70),
                            ),
                            trailing: const Icon(LucideIcons.chevronRight, color: Colors.white30),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
                  error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.vehicle['model'] ?? 'N/A', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.hash, color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Text(widget.vehicle['plate_number'] ?? 'N/A', style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(LucideIcons.fuel, color: Colors.white54, size: 16),
              const SizedBox(width: 8),
              Text(widget.vehicle['fuel_type'] ?? 'N/A', style: const TextStyle(color: Colors.white70, fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }
}
