import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';

class DriverPaymentsScreen extends ConsumerStatefulWidget {
  const DriverPaymentsScreen({super.key});

  @override
  ConsumerState<DriverPaymentsScreen> createState() => _DriverPaymentsScreenState();
}

class _DriverPaymentsScreenState extends ConsumerState<DriverPaymentsScreen> {
  @override
  Widget build(BuildContext context) {
    // null driverId means fetch all payments
    final paymentsAsync = ref.watch(driverPaymentsProvider(null));

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
      child: paymentsAsync.when(
        data: (payments) {
          if (payments.isEmpty) {
            return const Center(child: Text('No payments found', style: TextStyle(color: Colors.white70)));
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
    );
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => const _AddPaymentDialog(),
    ).then((_) {
      ref.invalidate(driverPaymentsProvider);
    });
  }
}

class _AddPaymentDialog extends ConsumerStatefulWidget {
  const _AddPaymentDialog();

  @override
  ConsumerState<_AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends ConsumerState<_AddPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedDriverId;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDriverId == null) {
      if (_selectedDriverId == null) {
        AppSnackbar.showError(context, 'Please select a driver');
      }
      return;
    }

    setState(() => _isLoading = true);
    try {
      final amount = double.parse(_amountController.text);
      await ref.read(adminRepositoryProvider).addDriverPayment(
        driverId: _selectedDriverId!,
        amount: amount,
        paymentDate: DateTime.now(),
        note: _noteController.text.isNotEmpty ? _noteController.text.trim() : null,
      );
      if (mounted) {
        Navigator.pop(context, true);
        AppSnackbar.showSuccess(context, 'Payment added successfully');
      }
    } catch (e) {
      if (mounted) AppSnackbar.showError(context, 'Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(driversProvider);

    return AlertDialog(
      backgroundColor: const Color(0xFF171A24),
      title: const Text('Record Advance Payment', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            driversAsync.when(
              data: (drivers) {
                return DropdownButtonFormField<String>(
                  value: _selectedDriverId,
                  dropdownColor: const Color(0xFF171A24),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Select Driver',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  ),
                  items: drivers.map((d) {
                    return DropdownMenuItem<String>(
                      value: d['id'],
                      child: Text(d['full_name'] ?? 'Unknown'),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => _selectedDriverId = val),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => const Text('Error loading drivers', style: TextStyle(color: Colors.red)),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Amount (Tk)',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Note (Optional)',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.black,
          ),
          child: _isLoading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
              : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
