import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../driver/presentation/screens/driver_logs_screen.dart';
import '../../../driver/data/repositories/driver_repository.dart';
import '../../data/repositories/billing_repository.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:ui';

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

    return AppAuroraBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Driver Profile', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            // Profile Header
            Row(
              children: [
                // Glowing Avatar
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color(0xFF171A24),
                    backgroundImage: widget.driver['avatar_url'] != null && widget.driver['avatar_url'].toString().isNotEmpty
                        ? NetworkImage(widget.driver['avatar_url'])
                        : null,
                    child: widget.driver['avatar_url'] == null || widget.driver['avatar_url'].toString().isEmpty
                        ? const Icon(Icons.person, color: Colors.white70, size: 45)
                        : null,
                  ),
                ),
                20.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.driver['full_name'] ?? 'Unknown',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      "Senior Driver".text.color(Colors.white54).make(),
                      8.heightBox,
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const Icon(Icons.star_half, color: Colors.amber, size: 18),
                          8.widthBox,
                          "4.8".text.color(Colors.white70).bold.make(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            24.heightBox,
            
            // Driver Meta Information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Employee ID".text.color(Colors.white54).size(12).make(),
                    Text(
                      '${widget.driver['employee_id']}',
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Text(
                    clientName,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
              ],
            ),
            24.heightBox,

            // Status Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isActive ? 'Status: Active' : 'Status: Inactive',
                  style: TextStyle(
                    color: _isActive ? Colors.cyanAccent : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Switch(
                  value: _isActive,
                  activeColor: Colors.cyanAccent,
                  onChanged: _toggleStatus,
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildMonthlyStatsCard(),
            
            const SizedBox(height: 24),
            _AdminBillingRatesCard(driverId: widget.driver['id']),
            
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(LucideIcons.history, size: 18),
                label: const Text('View Trip History'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent.withValues(alpha: 0.2),
                  foregroundColor: Colors.cyanAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DriverLogsScreen(
                        adminViewDriverId: widget.driver['id'],
                        adminViewDriverName: widget.driver['full_name'],
                      ),
                    ),
                  );
                },
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

  Widget _buildMonthlyStatsCard() {
    int totalKm = 0;
    Duration totalDuration = Duration.zero;
    double totalExpense = 0.0;
    int daysWorked = 0;
    Duration totalOvertime = Duration.zero;
    
    final driverId = widget.driver['id'] as String;
    final now = DateTime.now();
    final totalDaysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    final monthStart = DateTime(now.year, now.month, 1);
    final monthEnd = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    
    // We try to get logs if they exist locally
    final logs = ref.read(driverRepositoryProvider).getLogs(
      driverId,
      start: monthStart,
      end: monthEnd,
    );
    
    final Set<String> workedDays = {};
    final Map<String, List<dynamic>> dailyLogsMap = {};
    
    for (var log in logs) {
      final dateStr = DateFormat('yyyy-MM-dd').format(log.startTime);
      workedDays.add(dateStr);
      dailyLogsMap.putIfAbsent(dateStr, () => []).add(log);
      
      totalKm += (log.totalKm ?? 0);
      
      final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
      for (var exp in expenses) {
        final type = exp.expenseType.toLowerCase();
        if (type == 'toll' || type == 'parking') {
          totalExpense += exp.amount;
        }
      }

      if (log.endTime != null) {
        final diff = log.endTime!.difference(log.startTime);
        totalDuration += diff;
      }
    }
    daysWorked = workedDays.length;
    
    for (var dayLogs in dailyLogsMap.values) {
      dayLogs.sort((a, b) => (a.startTime as DateTime).compareTo(b.startTime as DateTime));
      final dutyStart = dayLogs.first.startTime as DateTime;
      final logsWithEnd = dayLogs.where((l) => l.endTime != null).toList();
      if (logsWithEnd.isNotEmpty) {
        logsWithEnd.sort((a, b) => (a.endTime as DateTime).compareTo(b.endTime as DateTime));
        final dutyEnd = logsWithEnd.last.endTime as DateTime;
        final duration = dutyEnd.difference(dutyStart);
        if (duration.inMinutes > 600) {
          totalOvertime += Duration(minutes: duration.inMinutes - 600);
        }
      }
    }
    
    final formatter = NumberFormat('#,##0');
    final percent = totalDaysInMonth > 0 ? (daysWorked / totalDaysInMonth) : 0.0;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  "MONTHLY SUMMARY".text.color(Colors.white70).bold.letterSpacing(1).make(),
                  DateFormat('MMM yyyy').format(now).text.color(Colors.white54).make(),
                ],
              ),
              24.heightBox,
              Row(
                children: [
                  // Days Worked Box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Days Worked".text.color(Colors.white70).make(),
                              8.heightBox,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  daysWorked.toString().text.white.xl3.bold.make(),
                                  4.widthBox,
                                  "Days".text.white.bold.make(),
                                ],
                              ),
                              "out of $totalDaysInMonth".text.color(Colors.white54).size(12).make(),
                            ],
                          ),
                          CircularPercentIndicator(
                            radius: 24,
                            lineWidth: 5.0,
                            percent: percent.clamp(0.0, 1.0),
                            center: "${(percent * 100).toInt()}%".text.white.size(12).bold.make(),
                            progressColor: Colors.cyanAccent,
                            backgroundColor: Colors.white12,
                            circularStrokeCap: CircularStrokeCap.round,
                          ),
                        ],
                      ),
                    ),
                  ),
                  16.widthBox,
                  // Overtime Box
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.cyan.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.cyan.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Total Overtime".text.color(Colors.cyanAccent).make(),
                          8.heightBox,
                          "${totalOvertime.inHours} hrs".text.white.xl3.bold.make(),
                          "${totalOvertime.inMinutes.remainder(60)} mins".text.color(Colors.cyanAccent.withValues(alpha: 0.7)).size(12).make(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              24.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatItem("Toll/Parking", formatter.format(totalExpense), "Tk"),
                  _buildStatItem("Total Distance", formatter.format(totalKm), "km"),
                  _buildStatItem("Total Hours", "${totalDuration.inHours}", "hrs"),
                ],
              ),
              24.heightBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _showVerifyBillSheet(
                      context, 
                      driverId: widget.driver['id'], 
                      claimedKm: totalKm, 
                      claimedOvertimeMins: totalOvertime.inMinutes,
                      claimedDaysWorked: daysWorked,
                      claimedToll: totalExpense,
                      monthDate: now,
                    );
                  },
                  icon: const Icon(LucideIcons.fileCheck2, size: 18, color: Colors.black87),
                  label: const Text('Verify & Generate Bill', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.text.color(Colors.white70).size(12).make(),
        4.heightBox,
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            value.text.white.xl2.bold.make(),
            4.widthBox,
            unit.text.color(Colors.white54).size(12).make(),
          ],
        ),
      ],
    );
  }

  void _showVerifyBillSheet(
    BuildContext context, {
    required String driverId,
    required int claimedKm,
    required int claimedOvertimeMins,
    required int claimedDaysWorked,
    required double claimedToll,
    required DateTime monthDate,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VerifyBillSheet(
        driverId: driverId,
        monthDate: monthDate,
        claimedKm: claimedKm,
        claimedOvertimeMins: claimedOvertimeMins,
        claimedDaysWorked: claimedDaysWorked,
        claimedToll: claimedToll,
      ),
    );
  }
}

// ------------------------------------------------------------------------
// BILLING RATES WIDGET
// ------------------------------------------------------------------------

class _AdminBillingRatesCard extends ConsumerStatefulWidget {
  final String driverId;
  const _AdminBillingRatesCard({required this.driverId});

  @override
  ConsumerState<_AdminBillingRatesCard> createState() => _AdminBillingRatesCardState();
}

class _AdminBillingRatesCardState extends ConsumerState<_AdminBillingRatesCard> {
  bool _isLoading = true;
  Map<String, dynamic> _rates = {};

  @override
  void initState() {
    super.initState();
    _loadRates();
  }

  Future<void> _loadRates() async {
    try {
      final data = await ref.read(billingRepositoryProvider).getDriverRates(widget.driverId);
      if (mounted) {
        setState(() {
          _rates = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.showError(context, "Rates Error: $e");
      }
    }
  }

  Future<void> _editRate(String key, String title) async {
    final TextEditingController controller = TextEditingController(text: _rates[key]?.toString() ?? "0");
    
    final newVal = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2336),
        title: Text('Edit $title', style: const TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new rate',
            hintStyle: TextStyle(color: Colors.white54),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.cyanAccent)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('Save', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );

    if (newVal != null && newVal.isNotEmpty) {
      final double? parsed = double.tryParse(newVal);
      if (parsed != null) {
        setState(() {
          _rates[key] = parsed;
        });
        try {
          await ref.read(billingRepositoryProvider).updateDriverRates(widget.driverId, {key: parsed});
          if (mounted) AppSnackbar.showSuccess(context, "$title updated");
        } catch (e) {
          if (mounted) AppSnackbar.showError(context, "Failed to update");
        }
      }
    }
  }

  Widget _buildRateRow(String title, String key, String unit) {
    final val = _rates[key] ?? 0.0;
    return InkWell(
      onTap: () => _editRate(key, title),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(color: Colors.white70, fontSize: 14)),
            Row(
              children: [
                Text(
                  '$val $unit',
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Icon(LucideIcons.pencil, size: 14, color: Colors.white30),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.banknote, color: Colors.greenAccent, size: 20),
              const SizedBox(width: 10),
              const Text(
                'BILLING RATES',
                style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildRateRow('CNG Rate', 'cng_rate_per_km', 'Tk/km'),
          _buildRateRow('Octane Rate', 'octane_rate_per_km', 'Tk/km'),
          _buildRateRow('LPG Rate', 'lpg_rate_per_km', 'Tk/km'),
          _buildRateRow('Overtime Rate', 'overtime_rate_per_hour', 'Tk/hr'),
          _buildRateRow('Lunch Rate', 'lunch_rate_per_day', 'Tk/day'),
          _buildRateRow('Night Stay Rate', 'night_stay_rate', 'Tk'),
          _buildRateRow('Starting Fuel', 'starting_fuel_rate', 'Tk'),
          _buildRateRow('Replace Day Rate', 'replace_day_rate', 'Tk/day'),
          _buildRateRow('Absent Day Rate', 'absent_day_rate', 'Tk/day'),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------------------
// VERIFY BILL SHEET
// ------------------------------------------------------------------------

class _VerifyBillSheet extends ConsumerStatefulWidget {
  final String driverId;
  final DateTime monthDate;
  final int claimedKm;
  final int claimedOvertimeMins;
  final int claimedDaysWorked;
  final double claimedToll;

  const _VerifyBillSheet({
    required this.driverId,
    required this.monthDate,
    required this.claimedKm,
    required this.claimedOvertimeMins,
    required this.claimedDaysWorked,
    required this.claimedToll,
  });

  @override
  ConsumerState<_VerifyBillSheet> createState() => _VerifyBillSheetState();
}

class _VerifyBillSheetState extends ConsumerState<_VerifyBillSheet> {
  bool _isLoading = true;
  bool _isSaving = false;
  Map<String, dynamic> _rates = {};
  
  late TextEditingController _cngKmCtrl;
  late TextEditingController _octaneKmCtrl;
  late TextEditingController _lpgKmCtrl;
  late TextEditingController _overtimeHrCtrl;
  late TextEditingController _nightStayCtrl;
  late TextEditingController _lunchDaysCtrl;
  late TextEditingController _tollCtrl;
  late TextEditingController _replaceDaysCtrl;
  late TextEditingController _absentDaysCtrl;

  @override
  void initState() {
    super.initState();
    // Default values
    _cngKmCtrl = TextEditingController(text: widget.claimedKm.toString());
    _octaneKmCtrl = TextEditingController(text: "0");
    _lpgKmCtrl = TextEditingController(text: "0");
    _overtimeHrCtrl = TextEditingController(text: (widget.claimedOvertimeMins / 60.0).toStringAsFixed(1));
    _nightStayCtrl = TextEditingController(text: "0");
    _lunchDaysCtrl = TextEditingController(text: widget.claimedDaysWorked.toString());
    _tollCtrl = TextEditingController(text: widget.claimedToll.toString());
    _replaceDaysCtrl = TextEditingController(text: "0");
    _absentDaysCtrl = TextEditingController(text: "0");
    
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final monthStr = DateFormat('yyyy-MM').format(widget.monthDate);
      final rates = await ref.read(billingRepositoryProvider).getDriverRates(widget.driverId);
      final existingBill = await ref.read(billingRepositoryProvider).getMonthlyBill(widget.driverId, monthStr);
      
      if (mounted) {
        setState(() {
          _rates = rates;
          if (existingBill != null) {
            _cngKmCtrl.text = (existingBill['actual_cng_km'] ?? 0).toString();
            _octaneKmCtrl.text = (existingBill['actual_octane_km'] ?? 0).toString();
            _lpgKmCtrl.text = (existingBill['actual_lpg_km'] ?? 0).toString();
            _overtimeHrCtrl.text = (existingBill['actual_overtime_hours'] ?? 0).toString();
            _nightStayCtrl.text = (existingBill['actual_night_stays'] ?? 0).toString();
            _lunchDaysCtrl.text = (existingBill['actual_working_days'] ?? 0).toString();
            _tollCtrl.text = (existingBill['actual_toll_parking'] ?? 0).toString();
            _replaceDaysCtrl.text = (existingBill['actual_replace_days'] ?? 0).toString();
            _absentDaysCtrl.text = (existingBill['actual_absent_days'] ?? 0).toString();
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.showError(context, "Failed to load billing data");
      }
    }
  }

  double get _totalBill {
    final cngKm = double.tryParse(_cngKmCtrl.text) ?? 0;
    final octaneKm = double.tryParse(_octaneKmCtrl.text) ?? 0;
    final lpgKm = double.tryParse(_lpgKmCtrl.text) ?? 0;
    final otHr = double.tryParse(_overtimeHrCtrl.text) ?? 0;
    final nightStay = int.tryParse(_nightStayCtrl.text) ?? 0;
    final lunchDays = int.tryParse(_lunchDaysCtrl.text) ?? 0;
    final toll = double.tryParse(_tollCtrl.text) ?? 0;
    final replaceDays = int.tryParse(_replaceDaysCtrl.text) ?? 0;
    final absentDays = int.tryParse(_absentDaysCtrl.text) ?? 0;

    final cngTotal = cngKm * (_rates['cng_rate_per_km'] ?? 0);
    final octaneTotal = octaneKm * (_rates['octane_rate_per_km'] ?? 0);
    final lpgTotal = lpgKm * (_rates['lpg_rate_per_km'] ?? 0);
    final otTotal = otHr * (_rates['overtime_rate_per_hour'] ?? 0);
    final nightTotal = nightStay * (_rates['night_stay_rate'] ?? 0);
    final lunchTotal = lunchDays * (_rates['lunch_rate_per_day'] ?? 0);
    final startingFuel = (_rates['starting_fuel_rate'] ?? 0); // Usually added once
    final replaceTotal = replaceDays * (_rates['replace_day_rate'] ?? 0);
    
    // Absent is deducted
    final absentTotal = absentDays * (_rates['absent_day_rate'] ?? 0);

    return cngTotal + octaneTotal + lpgTotal + otTotal + nightTotal + lunchTotal + toll + startingFuel + replaceTotal - absentTotal;
  }

  Future<void> _saveBill() async {
    setState(() => _isSaving = true);
    try {
      final monthStr = DateFormat('yyyy-MM').format(widget.monthDate);
      
      final billData = {
        'driver_id': widget.driverId,
        'month_year': monthStr,
        
        // Claimed
        'claimed_cng_km': widget.claimedKm, // Assuming all claimed were CNG for simplicity unless they split it
        'claimed_overtime_hours': widget.claimedOvertimeMins / 60.0,
        'claimed_working_days': widget.claimedDaysWorked,
        'claimed_toll_parking': widget.claimedToll,
        
        // Actual
        'actual_cng_km': double.tryParse(_cngKmCtrl.text) ?? 0,
        'actual_octane_km': double.tryParse(_octaneKmCtrl.text) ?? 0,
        'actual_lpg_km': double.tryParse(_lpgKmCtrl.text) ?? 0,
        'actual_overtime_hours': double.tryParse(_overtimeHrCtrl.text) ?? 0,
        'actual_night_stays': int.tryParse(_nightStayCtrl.text) ?? 0,
        'actual_working_days': int.tryParse(_lunchDaysCtrl.text) ?? 0,
        'actual_toll_parking': double.tryParse(_tollCtrl.text) ?? 0,
        'actual_replace_days': int.tryParse(_replaceDaysCtrl.text) ?? 0,
        'actual_absent_days': int.tryParse(_absentDaysCtrl.text) ?? 0,
        
        // Rates snapshot
        'cng_rate': _rates['cng_rate_per_km'] ?? 0,
        'octane_rate': _rates['octane_rate_per_km'] ?? 0,
        'lpg_rate': _rates['lpg_rate_per_km'] ?? 0,
        'overtime_rate': _rates['overtime_rate_per_hour'] ?? 0,
        'night_stay_rate': _rates['night_stay_rate'] ?? 0,
        'lunch_rate': _rates['lunch_rate_per_day'] ?? 0,
        'starting_fuel': _rates['starting_fuel_rate'] ?? 0,
        'replace_day_rate': _rates['replace_day_rate'] ?? 0,
        'absent_day_rate': _rates['absent_day_rate'] ?? 0,
        
        'total_bill_amount': _totalBill,
        'status': 'Verified',
        'updated_at': DateTime.now().toIso8601String(),
      };
      
      await ref.read(billingRepositoryProvider).saveMonthlyBill(billData);
      
      if (mounted) {
        AppSnackbar.showSuccess(context, "Bill Verified Successfully");
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        AppSnackbar.showError(context, "Error saving bill");
      }
    }
  }

  Widget _buildField(String label, TextEditingController ctrl, {bool isInt = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(
            flex: 1,
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.numberWithOptions(decimal: !isInt),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.right,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 300,
        decoration: const BoxDecoration(color: Color(0xFF131621), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    final formatter = NumberFormat('#,##0.00');

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF131621),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Verify Monthly Bill', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(DateFormat('MMMM yyyy').format(widget.monthDate), style: const TextStyle(color: Colors.white54, fontSize: 13)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: () => Navigator.pop(context)),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyan.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Claimed (App Data)', style: TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold)),
                        Text('${widget.claimedKm}km | ${(widget.claimedOvertimeMins / 60).toStringAsFixed(1)}h | ${widget.claimedDaysWorked}d', 
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('ACTUAL VERIFIED DATA', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  _buildField('CNG KM (Tk ${_rates['cng_rate_per_km']}/km)', _cngKmCtrl),
                  _buildField('Octane KM (Tk ${_rates['octane_rate_per_km']}/km)', _octaneKmCtrl),
                  _buildField('LPG KM (Tk ${_rates['lpg_rate_per_km']}/km)', _lpgKmCtrl),
                  _buildField('Overtime Hours (Tk ${_rates['overtime_rate_per_hour']}/h)', _overtimeHrCtrl),
                  _buildField('Working Days (Tk ${_rates['lunch_rate_per_day']}/day)', _lunchDaysCtrl, isInt: true),
                  _buildField('Night Stays (Tk ${_rates['night_stay_rate']})', _nightStayCtrl, isInt: true),
                  _buildField('Toll & Parking', _tollCtrl),
                  
                  const Divider(color: Colors.white12, height: 32),
                  
                  const Text('DEDUCTIONS & ADDITIONS', style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 1, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  _buildField('Replace Days (+Tk ${_rates['replace_day_rate']})', _replaceDaysCtrl, isInt: true),
                  _buildField('Absent Days (-Tk ${_rates['absent_day_rate']})', _absentDaysCtrl, isInt: true),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 24.0),
                    child: Text('Starting Fuel (+Tk ${_rates['starting_fuel_rate']}) is automatically added.', style: const TextStyle(color: Colors.white30, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2336),
              border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Bill', style: TextStyle(color: Colors.white54, fontSize: 12)),
                    Text(
                      'Tk ${formatter.format(_totalBill)}',
                      style: const TextStyle(color: Colors.cyanAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2))
                      : const Text('Verify & Save', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

