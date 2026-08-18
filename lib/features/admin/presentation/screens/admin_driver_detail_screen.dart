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
import '../widgets/add_driver_dialog.dart';
import '../widgets/add_driver_payment_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../driver/presentation/screens/driver_logs_screen.dart';
import '../../../driver/data/repositories/driver_repository.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/services/pdf_billing_slip_service.dart';
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
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.pencil, color: Colors.cyanAccent),
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => AddDriverDialog(driver: widget.driver),
              );
              if (result == true) {
                // Return to refresh local state if needed.
                if (mounted) Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
    
    final logs = ref.read(driverRepositoryProvider).getLogs(
      driverId,
      start: monthStart,
      end: monthEnd,
    );
    
    final Set<String> workedDays = {};
    final Map<String, List<dynamic>> dailyLogsMap = {};
    int totalCngKm = 0;
    int totalOctaneKm = 0;
    int totalLpgKm = 0;

    for (var log in logs) {
      final dateStr = DateFormat('yyyy-MM-dd').format(log.startTime);
      workedDays.add(dateStr);
      dailyLogsMap.putIfAbsent(dateStr, () => []).add(log);
      
      totalKm += (log.totalKm ?? 0);
      totalCngKm += (log.cngKm ?? 0);
      totalOctaneKm += (log.octaneKm ?? 0);
      totalLpgKm += (log.lpgKm ?? 0);
      
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
                          Expanded(
                            child: Column(
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
                    showDialog(
                      context: context,
                      builder: (context) => AddDriverPaymentDialog(initialDriverId: widget.driver['id']),
                    ).then((_) {
                      ref.invalidate(driverPaymentsProvider);
                      ref.invalidate(driverDetailProvider(widget.driver['id']));
                    });
                  },
                  icon: const Icon(LucideIcons.banknote, size: 18, color: Colors.black87),
                  label: const Text('Add Advance Payment', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amberAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              12.heightBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final vehicleList = widget.driver['vehicles'] as List<dynamic>?;
                    final defaultRent = (vehicleList != null && vehicleList.isNotEmpty) 
                        ? ((vehicleList[0]['rent_amount'] ?? 0.0) as num).toDouble()
                        : 0.0;
                    final fuelType = (vehicleList != null && vehicleList.isNotEmpty) 
                        ? (vehicleList[0]['fuel_type'] ?? 'Unknown')
                        : 'Unknown';
                    
                    _showVerifyBillSheet(
                      context, 
                      driverId: widget.driver['id'], 
                      vehicleRentAmount: defaultRent,
                      vehicleFuelType: fuelType.toString(),
                      claimedKm: totalKm,
                      claimedCngKm: totalCngKm,
                      claimedOctaneKm: totalOctaneKm,
                      claimedLpgKm: totalLpgKm,
                      claimedOvertimeHours: totalOvertime.inHours,
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
              12.heightBox,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final monthStr = DateFormat('yyyy-MM').format(now);
                      final existingBill = await ref.read(billingRepositoryProvider).getMonthlyBill(widget.driver['id'], monthStr);
                      if (existingBill == null || existingBill.isEmpty) {
                        if (mounted) AppSnackbar.showError(context, "No verified bill found for ${DateFormat('MMM yyyy').format(now)}");
                        return;
                      }
                      
                      await PdfBillingSlipService.generateAndPrintSlip(
                        driverData: widget.driver,
                        billData: existingBill,
                      );
                    } catch (e) {
                      if (mounted) AppSnackbar.showError(context, "Failed to generate slip: $e");
                    }
                  },
                  icon: const Icon(LucideIcons.download, size: 18, color: Colors.white),
                  label: const Text('Download Driver Slip (PDF)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    side: const BorderSide(color: Colors.cyanAccent),
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
    required double vehicleRentAmount,
    required String vehicleFuelType,
    required int claimedKm,
    required int claimedCngKm,
    required int claimedOctaneKm,
    required int claimedLpgKm,
    required int claimedOvertimeHours,
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
        vehicleRentAmount: vehicleRentAmount,
        vehicleFuelType: vehicleFuelType,
        claimedKm: claimedKm,
        claimedCngKm: claimedCngKm,
        claimedOctaneKm: claimedOctaneKm,
        claimedLpgKm: claimedLpgKm,
        claimedOvertimeHours: claimedOvertimeHours,
        claimedDaysWorked: claimedDaysWorked,
        claimedToll: claimedToll,
        monthDate: monthDate,
      ),
    );
  }
}

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

class _VerifyBillSheet extends ConsumerStatefulWidget {
  final String driverId;
  final double vehicleRentAmount;
  final String vehicleFuelType;
  final int claimedKm;
  final int claimedCngKm;
  final int claimedOctaneKm;
  final int claimedLpgKm;
  final int claimedOvertimeHours;
  final int claimedDaysWorked;
  final double claimedToll;
  final DateTime monthDate;

  const _VerifyBillSheet({
    required this.driverId,
    required this.vehicleRentAmount,
    required this.vehicleFuelType,
    required this.claimedKm,
    required this.claimedCngKm,
    required this.claimedOctaneKm,
    required this.claimedLpgKm,
    required this.claimedOvertimeHours,
    required this.claimedDaysWorked,
    required this.claimedToll,
    required this.monthDate,
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
  late TextEditingController _rentCtrl;
  late TextEditingController _advanceCtrl;
  
  bool _startingFuelAdded = false;
  bool _rentBillAdded = false;

  @override
  void initState() {
    super.initState();
    int cng = widget.claimedCngKm;
    int lpg = widget.claimedLpgKm;
    if (widget.vehicleFuelType.toLowerCase() == 'lpg') {
      lpg += cng;
      cng = 0;
    } else if (widget.vehicleFuelType.toLowerCase() == 'cng') {
      cng += lpg;
      lpg = 0;
    }
    
    _cngKmCtrl = TextEditingController(text: cng.toString());
    _octaneKmCtrl = TextEditingController(text: widget.claimedOctaneKm.toString());
    _lpgKmCtrl = TextEditingController(text: lpg.toString());
    _overtimeHrCtrl = TextEditingController(text: widget.claimedOvertimeHours.toString());
    _nightStayCtrl = TextEditingController(text: "0");
    _lunchDaysCtrl = TextEditingController(text: widget.claimedDaysWorked.toString());
    _tollCtrl = TextEditingController(text: widget.claimedToll.toString());
    _replaceDaysCtrl = TextEditingController(text: "0");
    _absentDaysCtrl = TextEditingController(text: "0");
    _rentBillAdded = widget.vehicleRentAmount > 0;
    _rentCtrl = TextEditingController(text: _rentBillAdded ? widget.vehicleRentAmount.toString() : "0");
    _advanceCtrl = TextEditingController(text: "0");
    
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final monthStr = DateFormat('yyyy-MM').format(widget.monthDate);
      final rates = await ref.read(billingRepositoryProvider).getDriverRates(widget.driverId);
      final existingBill = await ref.read(billingRepositoryProvider).getMonthlyBill(widget.driverId, monthStr);
      
      final payments = await ref.read(driverRepositoryProvider).getDriverPayments(widget.driverId);
      final currentMonthPayments = payments.where((p) {
        if (p['payment_date'] == null) return false;
        final date = DateTime.tryParse(p['payment_date'].toString());
        if (date == null) return false;
        return date.year == widget.monthDate.year && date.month == widget.monthDate.month;
      }).toList();
      final totalAdvance = currentMonthPayments.fold<double>(0.0, (sum, p) => sum + (double.tryParse(p['amount'].toString()) ?? 0.0));

      if (mounted) {
        setState(() {
          _rates = rates;
          _advanceCtrl.text = totalAdvance.toString(); 
          if (existingBill != null) {
            int cng = (existingBill['actual_cng_km'] as num?)?.toInt() ?? 0;
            int lpg = (existingBill['actual_lpg_km'] as num?)?.toInt() ?? 0;

            if (widget.vehicleFuelType.toLowerCase() == 'lpg') {
              lpg += cng;
              cng = 0;
            } else if (widget.vehicleFuelType.toLowerCase() == 'cng') {
              cng += lpg;
              lpg = 0;
            }

            _cngKmCtrl.text = cng.toString();
            _octaneKmCtrl.text = (existingBill['actual_octane_km']?.toString() ?? '0');
            _lpgKmCtrl.text = lpg.toString();
            _overtimeHrCtrl.text = (existingBill['actual_overtime_hours']?.toString() ?? '0');
            _nightStayCtrl.text = (existingBill['actual_night_stays']?.toString() ?? '0');
            _lunchDaysCtrl.text = (existingBill['actual_working_days']?.toString() ?? '0');
            _tollCtrl.text = (existingBill['actual_toll_parking']?.toString() ?? '0');
            _replaceDaysCtrl.text = (existingBill['replace_days']?.toString() ?? '0');
            _absentDaysCtrl.text = (existingBill['absent_days']?.toString() ?? '0');
            
            final existingRent = existingBill['vehicle_rent_amount'] ?? 0;
            if (existingRent > 0) {
              _rentBillAdded = true;
              _rentCtrl.text = existingRent.toString();
            } else {
              _rentBillAdded = false;
              _rentCtrl.text = "0";
            }
            
            // Always default to the real-time sum of payments in the DB
            // rather than the stale saved value. Admin can manually override if needed before saving.
            // _advanceCtrl.text is already set to totalAdvance.toString() above.
            _startingFuelAdded = existingBill['starting_fuel_added'] == true;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        AppSnackbar.showError(context, "Failed to load billing data");
        print("Error in _loadData: $e");
      }
    }
  }

  double get _cngTotal => ((double.tryParse(_cngKmCtrl.text) ?? 0) * (_rates['cng_rate_per_km'] ?? 0)).toDouble();
  double get _octaneTotal => ((double.tryParse(_octaneKmCtrl.text) ?? 0) * (_rates['octane_rate_per_km'] ?? 0)).toDouble();
  double get _lpgTotal => ((double.tryParse(_lpgKmCtrl.text) ?? 0) * (_rates['lpg_rate_per_km'] ?? 0)).toDouble();
  double get _startingFuelTotal => _startingFuelAdded ? (_rates['starting_fuel_rate'] ?? 0).toDouble() : 0.0;
  
  double get _totalFuelBill => _cngTotal + _octaneTotal + _lpgTotal + _startingFuelTotal;

  double get _otTotal => ((double.tryParse(_overtimeHrCtrl.text) ?? 0) * (_rates['overtime_rate_per_hour'] ?? 0)).toDouble();
  double get _nightTotal => ((int.tryParse(_nightStayCtrl.text) ?? 0) * (_rates['night_stay_rate'] ?? 0)).toDouble();
  double get _lunchTotal => ((int.tryParse(_lunchDaysCtrl.text) ?? 0) * (_rates['lunch_rate_per_day'] ?? 0)).toDouble();
  double get _tollTotal => double.tryParse(_tollCtrl.text) ?? 0;
  
  double get _totalAllowances => _otTotal + _nightTotal + _lunchTotal + _tollTotal;

  double get _driverTotal => _totalFuelBill + _totalAllowances - _advanceDeduction;

  double get _rentBill => double.tryParse(_rentCtrl.text) ?? 0;
  double get _replaceDeduction => ((int.tryParse(_replaceDaysCtrl.text) ?? 0) * (_rates['replace_day_rate'] ?? 0)).toDouble();
  double get _absentDeduction => ((int.tryParse(_absentDaysCtrl.text) ?? 0) * (_rates['absent_day_rate'] ?? 0)).toDouble();
  double get _advanceDeduction => double.tryParse(_advanceCtrl.text) ?? 0;

  double get _adjustmentsSubtotal => _rentBill - _replaceDeduction - _absentDeduction;

  double get _finalPayableAmount => _driverTotal + _adjustmentsSubtotal;

  Future<void> _saveBill() async {
    setState(() => _isSaving = true);
    try {
      final monthStr = DateFormat('yyyy-MM').format(widget.monthDate);
      
      final billData = {
        'driver_id': widget.driverId,
        'month_year': monthStr,
        
        // Claimed
        'claimed_total_km': widget.claimedKm, 
        'claimed_overtime_hours': widget.claimedOvertimeHours,
        'claimed_working_days': widget.claimedDaysWorked,
        'claimed_toll_parking': widget.claimedToll,
        
        // Actual
        'actual_cng_km': (double.tryParse(_cngKmCtrl.text) ?? 0).toInt(),
        'actual_octane_km': (double.tryParse(_octaneKmCtrl.text) ?? 0).toInt(),
        'actual_lpg_km': (double.tryParse(_lpgKmCtrl.text) ?? 0).toInt(),
        'actual_overtime_hours': (double.tryParse(_overtimeHrCtrl.text) ?? 0).toInt(),
        'actual_night_stays': int.tryParse(_nightStayCtrl.text) ?? 0,
        'actual_working_days': int.tryParse(_lunchDaysCtrl.text) ?? 0,
        'actual_toll_parking': double.tryParse(_tollCtrl.text) ?? 0,
        'starting_fuel_added': _startingFuelAdded,
        'actual_replace_days': int.tryParse(_replaceDaysCtrl.text) ?? 0,
        'actual_absent_days': int.tryParse(_absentDaysCtrl.text) ?? 0,
        'vehicle_rent_amount': double.tryParse(_rentCtrl.text) ?? 0,
        'advance_amount': double.tryParse(_advanceCtrl.text) ?? 0,
        
        'total_bill_amount': _finalPayableAmount,
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
        AppSnackbar.showError(context, "Error saving bill: ${e.toString()}");
      }
    }
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.white, fontSize: 13, letterSpacing: 1.2, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFieldRow(String label, TextEditingController ctrl, double amount, {bool isInt = false, bool isDeduction = false}) {
    final formatter = NumberFormat('#,##0.00');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(
            flex: 2,
            child: TextField(
              controller: ctrl,
              keyboardType: TextInputType.numberWithOptions(decimal: !isInt),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              '${isDeduction ? '-' : ''}Tk ${formatter.format(amount)}',
              textAlign: TextAlign.right,
              style: TextStyle(color: isDeduction ? Colors.redAccent : Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRentRow() {
    final formatter = NumberFormat('#,##0.00');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Row(
              children: [
                const Text('Rent Bill (+)', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const Spacer(),
                Transform.scale(
                  scale: 0.7,
                  child: Switch(
                    value: _rentBillAdded,
                    onChanged: (val) {
                      setState(() {
                        _rentBillAdded = val;
                        if (val) {
                          _rentCtrl.text = widget.vehicleRentAmount.toString();
                        } else {
                          _rentCtrl.text = "0";
                        }
                      });
                    },
                    activeColor: Colors.cyanAccent,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _rentCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white, fontSize: 14),
              textAlign: TextAlign.center,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.05),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Tk ${formatter.format(_rentBill)}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow(String label, bool value, ValueChanged<bool>? onChanged, double amount) {
    final formatter = NumberFormat('#,##0.00');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13))),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.center,
              child: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.cyanAccent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              'Tk ${formatter.format(amount)}',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtotal(String label, double amount) {
    final formatter = NumberFormat('#,##0.00');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
          Text('Tk ${formatter.format(amount)}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.90;

    if (_isLoading) {
      return Container(
        height: sheetHeight,
        decoration: const BoxDecoration(color: Color(0xFF131621), borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: const Center(child: CircularProgressIndicator(color: Colors.cyanAccent)),
      );
    }

    final formatter = NumberFormat('#,##0.00');

    return Container(
      height: sheetHeight,
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
                    const Text('DRIVER MONTHLY BILL SLIP', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
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
                  // App Data Claimed
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
                        Text('${widget.claimedKm}km | ${widget.claimedOvertimeHours}h | ${widget.claimedDaysWorked}d', 
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  
                  // Section 1: Fuel Bill
                  _buildSectionHeader('1. Fuel Bill Calculation'),
                  
                  if (widget.vehicleFuelType.toLowerCase().contains('cng'))
                    _buildFieldRow('CNG (Tk ${_rates['cng_rate_per_km']}/km)', _cngKmCtrl, _cngTotal),
                  
                  if (widget.vehicleFuelType.toLowerCase().contains('octane') || 
                      widget.vehicleFuelType.toLowerCase().contains('lpg') || 
                      widget.vehicleFuelType.toLowerCase().contains('cng'))
                    _buildFieldRow('Octane (Tk ${_rates['octane_rate_per_km']}/km)', _octaneKmCtrl, _octaneTotal),
                  
                  if (widget.vehicleFuelType.toLowerCase().contains('lpg'))
                    _buildFieldRow('LPG (Tk ${_rates['lpg_rate_per_km']}/km)', _lpgKmCtrl, _lpgTotal),
                  
                  _buildSwitchRow(
                    'Starting Fuel (Tk ${_rates['starting_fuel_rate']})', 
                    _startingFuelAdded, 
                    widget.vehicleFuelType.toLowerCase() == 'octane' ? null : (val) => setState(() => _startingFuelAdded = val), 
                    _startingFuelTotal
                  ),
                  _buildSubtotal('Total Fuel Bill', _totalFuelBill),

                  // Section 2: Allowances
                  _buildSectionHeader('2. Allowances & Others'),
                  _buildFieldRow('Overtime (Tk ${_rates['overtime_rate_per_hour']}/h)', _overtimeHrCtrl, _otTotal),
                  _buildFieldRow('Night Stay (Tk ${_rates['night_stay_rate']})', _nightStayCtrl, _nightTotal, isInt: true),
                  _buildFieldRow('Day Meal / Lunch (Tk ${_rates['lunch_rate_per_day']})', _lunchDaysCtrl, _lunchTotal, isInt: true),
                  _buildFieldRow('Toll & Parking', _tollCtrl, _tollTotal),
                  _buildSubtotal('Total Allowances', _totalAllowances),
                  
                  _buildFieldRow('Advance Amount / Fuel (-)', _advanceCtrl, _advanceDeduction, isDeduction: true),

                  // Driver Total
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'NET DRIVER PAY', 
                            style: TextStyle(color: Colors.cyanAccent, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text('Tk ${formatter.format(_driverTotal)}', style: const TextStyle(color: Colors.cyanAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),

                  // Section 3: Adjustments
                  _buildSectionHeader('3. Rent & Absent Adjustments'),
                  _buildRentRow(),
                  _buildFieldRow('Replace Deduction (-)', _replaceDaysCtrl, _replaceDeduction, isInt: true, isDeduction: true),
                  _buildFieldRow('Absent Deduction (-)', _absentDaysCtrl, _absentDeduction, isInt: true, isDeduction: true),
                  _buildSubtotal('Adjustments Subtotal', _adjustmentsSubtotal),
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Bottom Bar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              border: Border(top: BorderSide(color: Colors.green.withValues(alpha: 0.3))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('FINAL PAYABLE AMOUNT', style: TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text(
                      'Tk ${formatter.format(_finalPayableAmount)}',
                      style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _isSaving ? null : _saveBill,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(120, 48),
                  ),
                  child: _isSaving
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black87, strokeWidth: 2))
                      : const Text('Verify & Save', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

