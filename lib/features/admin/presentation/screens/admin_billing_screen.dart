import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';
import '../../data/repositories/billing_repository.dart';
import '../../domain/services/company_excel_report_service.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminBillingScreen extends ConsumerStatefulWidget {
  const AdminBillingScreen({super.key});

  @override
  ConsumerState<AdminBillingScreen> createState() => _AdminBillingScreenState();
}

class _AdminBillingScreenState extends ConsumerState<AdminBillingScreen> {
  DateTime _selectedMonth = DateTime.now();
  String? _selectedClientId;
  bool _isExporting = false;

  Future<void> _exportReport(String clientName) async {
    if (_selectedClientId == null) {
      AppSnackbar.showError(context, "Please select a client first");
      return;
    }
    
    setState(() => _isExporting = true);
    try {
      final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
      final repo = ref.read(billingRepositoryProvider);
      
      final bills = await repo.getMonthlyBillsForClient(_selectedClientId!, monthStr);
      if (bills.isEmpty) {
        if (mounted) AppSnackbar.showError(context, "No verified bills found for ${DateFormat('MMMM yyyy').format(_selectedMonth)}");
        return;
      }
      
      await CompanyExcelReportService.generateAndExport(
        companyName: clientName,
        monthYear: monthStr,
        billingDataList: bills,
      );
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, "Failed to export report: $e");
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthDisplay = DateFormat('MMMM yyyy').format(_selectedMonth);
    final clientsAsync = ref.watch(clientsProvider);
    
    return AppAuroraBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Billing & Invoicing', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Generate Invoice".text.white.xl2.bold.make(),
                    32.heightBox,
                    
                    "Client Company".text.color(Colors.white70).make(),
                    8.heightBox,
                    clientsAsync.when(
                      data: (clients) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedClientId,
                              hint: "Select a Client".text.color(Colors.white54).make(),
                              isExpanded: true,
                              dropdownColor: const Color(0xFF1E2336),
                              icon: const Icon(LucideIcons.chevronDown, color: Colors.white54),
                              items: clients.map((client) {
                                return DropdownMenuItem<String>(
                                  value: client['id'].toString(),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          color: Colors.cyanAccent.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          client['name'].toString().isNotEmpty ? client['name'].toString().substring(0, 1).toUpperCase() : 'C',
                                          style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      12.widthBox,
                                      Expanded(
                                        child: Text(
                                          client['name'],
                                          style: const TextStyle(color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() => _selectedClientId = val);
                              },
                            ),
                          ),
                        );
                      },
                      loading: () => const CircularProgressIndicator().centered(),
                      error: (err, stack) => Text("Error loading clients", style: const TextStyle(color: Colors.red)),
                    ),
                    
                    24.heightBox,
                    "Month Picker".text.color(Colors.white70).make(),
                    8.heightBox,
                    InkWell(
                      onTap: () async {
                        final selected = await showMonthPicker(
                          context: context,
                          initialDate: _selectedMonth,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (selected != null) {
                          setState(() => _selectedMonth = selected);
                        }
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(LucideIcons.calendar, color: Colors.white70, size: 20),
                                12.widthBox,
                                Text(monthDisplay, style: const TextStyle(color: Colors.white, fontSize: 16)),
                              ],
                            ),
                            const Icon(LucideIcons.chevronRight, color: Colors.white54, size: 20),
                          ],
                        ),
                      ),
                    ),
                    
                    32.heightBox,
                    
                    // Generate PDF Invoice Button (Placeholder for future)
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blueAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.3), blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          AppSnackbar.showSuccess(context, "PDF Invoice feature coming soon!");
                        },
                        icon: const Icon(LucideIcons.fileText, color: Colors.black87),
                        label: const Text('Generate PDF Invoice', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    
                    16.heightBox,
                    
                    // Export to Excel Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.greenAccent, Colors.tealAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.greenAccent.withValues(alpha: 0.2), blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: _isExporting ? null : () {
                          if (_selectedClientId == null) {
                            AppSnackbar.showError(context, "Please select a client first");
                            return;
                          }
                          // Find client name
                          final clients = clientsAsync.value ?? [];
                          final client = clients.firstWhere((c) => c['id'] == _selectedClientId, orElse: () => {'name': 'Client'});
                          _exportReport(client['name']);
                        },
                        icon: _isExporting 
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black87))
                            : const Icon(LucideIcons.sheet, color: Colors.black87),
                        label: Text(
                          _isExporting ? 'Generating Excel...' : 'Export Master Excel (XLSX)',
                          style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
