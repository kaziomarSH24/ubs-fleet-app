import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDriverDetailScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic> driver;

  const AdminDriverDetailScreen({super.key, required this.driver});

  @override
  ConsumerState<AdminDriverDetailScreen> createState() => _AdminDriverDetailScreenState();
}

class _AdminDriverDetailScreenState extends ConsumerState<AdminDriverDetailScreen> {
  bool _isUploading = false;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _isActive = widget.driver['is_active'] == true;
  }

  Future<void> _toggleStatus(bool value) async {
    try {
      await ref.read(adminRepositoryProvider).toggleDriverStatus(widget.driver['id'], value);
      setState(() => _isActive = value);
      ref.invalidate(driversProvider);
      if (mounted) AppSnackbar.showSuccess(context, 'Driver status updated');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to update status');
    }
  }

  Future<void> _uploadDocument() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
    );
    if (result == null || result.files.single.path == null) return;
    final file = File(result.files.single.path!);
    final fileName = result.files.single.name;

    // Show dialog to enter document type
    String docType = '';
    DateTime? expiryDate;
    
    if (!mounted) return;
    
    final success = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF171A24),
              title: const Text('Document Details', style: TextStyle(color: Colors.white)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Document Type (e.g. Driving License)',
                      labelStyle: TextStyle(color: Colors.white54),
                    ),
                    onChanged: (v) => docType = v,
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Expiry Date', style: TextStyle(color: Colors.white)),
                    subtitle: Text(
                      expiryDate != null ? DateFormat('MMM dd, yyyy').format(expiryDate!) : 'Not Set (Optional)',
                      style: const TextStyle(color: Colors.white54),
                    ),
                    trailing: const Icon(LucideIcons.calendar, color: Colors.cyanAccent),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 365)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (date != null) {
                        setDialogState(() => expiryDate = date);
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (docType.isEmpty) {
                      AppSnackbar.showError(context, 'Document type is required');
                      return;
                    }
                    Navigator.pop(context, true);
                  },
                  child: const Text('Upload'),
                ),
              ],
            );
          }
        );
      }
    );

    if (success != true) return;

    setState(() => _isUploading = true);
    try {
      await ref.read(adminRepositoryProvider).uploadDriverDocument(
        driverId: widget.driver['id'],
        docType: docType,
        file: file,
        fileName: fileName,
        expiryDate: expiryDate,
      );
      ref.invalidate(driverDocumentsProvider(widget.driver['id']));
      if (mounted) AppSnackbar.showSuccess(context, 'Document uploaded successfully');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to upload document');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _updateDocStatus(String docId, String status) async {
    try {
      await ref.read(adminRepositoryProvider).updateDriverDocumentStatus(docId, status);
      ref.invalidate(driverDocumentsProvider(widget.driver['id']));
      if (mounted) AppSnackbar.showSuccess(context, 'Document $status');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to update document status: $e');
    }
  }

  Future<void> _deleteDocument(String docId) async {
    try {
      await ref.read(adminRepositoryProvider).deleteDriverDocument(docId);
      ref.invalidate(driverDocumentsProvider(widget.driver['id']));
      if (mounted) AppSnackbar.showSuccess(context, 'Document deleted');
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Failed to delete document');
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsAsync = ref.watch(driverDocumentsProvider(widget.driver['id']));
    final clientName = widget.driver['clients'] != null ? widget.driver['clients']['name'] : 'No Company Assigned';

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Driver Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    child: const Icon(LucideIcons.user, size: 50, color: Colors.white54),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.driver['full_name'] ?? 'Unknown',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${widget.driver['employee_id']}',
                    style: const TextStyle(color: Colors.cyanAccent, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      clientName,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Status Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isActive ? 'Status: Active' : 'Status: Inactive',
                        style: TextStyle(
                          color: _isActive ? Colors.cyanAccent : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Switch(
                        value: _isActive,
                        activeColor: Colors.cyanAccent,
                        onChanged: _toggleStatus,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Documents Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Documents',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                _isUploading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : IconButton(
                      icon: const Icon(LucideIcons.upload, color: Colors.cyanAccent),
                      onPressed: _uploadDocument,
                    ),
              ],
            ),
            const SizedBox(height: 16),
            
            docsAsync.when(
              data: (docs) {
                if (docs.isEmpty) {
                  return const Text('No documents uploaded yet.', style: TextStyle(color: Colors.white54));
                }
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final doc = docs[index];
                    final expiry = doc['expiry_date'] != null 
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(doc['expiry_date']))
                        : 'No Expiry';
                    
                    Color statusColor = Colors.orangeAccent;
                    if (doc['status'] == 'approved') statusColor = Colors.greenAccent;
                    if (doc['status'] == 'rejected') statusColor = Colors.redAccent;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(LucideIcons.fileText, color: Colors.cyanAccent),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(doc['doc_type'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                    Text('Exp: $expiry', style: const TextStyle(color: Colors.white54, fontSize: 12)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  doc['status'].toString().toUpperCase(),
                                  style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () async {
                                  String urlStr = doc['file_url']?.toString() ?? '';
                                  if (urlStr.isEmpty) {
                                    if (mounted) AppSnackbar.showError(context, 'Document link is empty');
                                    return;
                                  }

                                  try {
                                    if (!urlStr.startsWith('http')) {
                                      // Generate a signed URL for private bucket (valid for 60 seconds)
                                      urlStr = await Supabase.instance.client.storage.from('driver_documents').createSignedUrl(urlStr, 60);
                                    }
                                    final url = Uri.parse(urlStr);
                                    await launchUrl(url);
                                  } catch (e) {
                                    if (mounted) AppSnackbar.showError(context, 'Could not open document: $e');
                                  }
                                },
                                icon: const Icon(LucideIcons.eye, size: 16, color: Colors.white),
                                label: const Text('View', style: TextStyle(color: Colors.white)),
                              ),
                              if (doc['status'] != 'approved')
                                TextButton.icon(
                                  onPressed: () => _updateDocStatus(doc['id'], 'approved'),
                                  icon: const Icon(LucideIcons.check, size: 16, color: Colors.greenAccent),
                                  label: const Text('Approve', style: TextStyle(color: Colors.greenAccent)),
                                ),
                              if (doc['status'] != 'rejected')
                                TextButton.icon(
                                  onPressed: () => _updateDocStatus(doc['id'], 'rejected'),
                                  icon: const Icon(LucideIcons.x, size: 16, color: Colors.redAccent),
                                  label: const Text('Reject', style: TextStyle(color: Colors.redAccent)),
                                ),
                              TextButton.icon(
                                onPressed: () => _deleteDocument(doc['id']),
                                icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.redAccent),
                                label: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 1500.ms, color: Colors.white24)
                  .fade(duration: 500.ms);
                },
              ),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.red))),
            ),
          ],
        ),
      ),
    );
  }
}
