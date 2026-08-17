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
  bool _isExporting = false;

  Future<void> _exportReport() async {
    final clientId = ref.read(selectedClientProvider);
    if (clientId == null) {
      AppSnackbar.showError(context, "Please select a client first");
      return;
    }
    
    setState(() => _isExporting = true);
    try {
      final monthStr = DateFormat('yyyy-MM').format(_selectedMonth);
      final repo = ref.read(billingRepositoryProvider);
      
      final bills = await repo.getMonthlyBillsForClient(clientId, monthStr);
      if (bills.isEmpty) {
        if (mounted) AppSnackbar.showError(context, "No verified bills found for ${DateFormat('MMMM yyyy').format(_selectedMonth)}");
        return;
      }
      
      // Get client name for the file
      final clientResponse = await repo.getDriverRates(bills.first['driver']['id']); // we don't have client name easily here, just use 'Company'
      final clientName = bills.first['driver']['clients']?['name'] ?? 'Company';
      
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
    
    return AppAuroraBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Billing & Reports', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Master Billing Report',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.heightBox,
            const Text(
              'Export verified driver bills as a master CSV file for the selected company and month. This file can be easily opened in Excel.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            32.heightBox,
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Select Billing Month', style: TextStyle(color: Colors.white, fontSize: 16)),
                  12.heightBox,
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
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(monthDisplay, style: const TextStyle(color: Colors.white, fontSize: 16)),
                          const Icon(LucideIcons.calendar, color: Colors.cyanAccent, size: 20),
                        ],
                      ),
                    ),
                  ),
                  24.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isExporting ? null : _exportReport,
                      icon: _isExporting 
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Icon(LucideIcons.download, size: 18, color: Colors.black),
                      label: Text(
                        _isExporting ? 'Generating Report...' : 'Export Master Excel (CSV)',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
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
          ],
        ),
      ),
    );
  }
}
