import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';
import '../widgets/add_driver_payment_dialog.dart';

class DriverPaymentsScreen extends ConsumerStatefulWidget {
  const DriverPaymentsScreen({super.key});

  @override
  ConsumerState<DriverPaymentsScreen> createState() => _DriverPaymentsScreenState();
}

class _DriverPaymentsScreenState extends ConsumerState<DriverPaymentsScreen> {
  DateTime _selectedMonth = DateTime.now();

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + offset, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    // null driverId means fetch all payments, filtered by _selectedMonth
    final paymentsAsync = ref.watch(driverPaymentsProvider((driverId: null, month: _selectedMonth)));

    return AppAuroraBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Driver Advances', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        icon: const Icon(LucideIcons.plus, color: Colors.black),
        label: const Text('Add Payment', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        onPressed: _showAddPaymentDialog,
      ),
      child: Column(
        children: [
          // Month Selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_selectedMonth),
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),
          Expanded(
            child: paymentsAsync.when(
              data: (payments) {
                if (payments.isEmpty) {
                  return const Center(child: Text('No payments found for this month', style: TextStyle(color: Colors.white70)));
                }
          return ListView.builder(
            padding: const EdgeInsets.all(20).copyWith(bottom: 100),
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final date = DateTime.parse(payment['payment_date']);
              final driverName = payment['profiles']?['full_name'] ?? 'Unknown Driver';
              
              return Card(
                color: const Color(0xFF171A24).withValues(alpha: 0.6),
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                    child: Icon(LucideIcons.banknote, color: Colors.black, size: 20),
                  ),
                  title: Text(driverName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(date)} ${payment['note'] != null ? '· ${payment['note']}' : ''}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  trailing: Text(
                    'Tk ${payment['amount']}',
                    style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              );
            },
          );
        },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => const AddDriverPaymentDialog(),
    ).then((_) {
      ref.invalidate(driverPaymentsProvider);
    });
  }
}
