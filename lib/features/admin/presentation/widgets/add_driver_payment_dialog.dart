import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';
import '../../data/repositories/admin_repository.dart';

class AddDriverPaymentDialog extends ConsumerStatefulWidget {
  final String? initialDriverId;

  const AddDriverPaymentDialog({super.key, this.initialDriverId});

  @override
  ConsumerState<AddDriverPaymentDialog> createState() => _AddDriverPaymentDialogState();
}

class _AddDriverPaymentDialogState extends ConsumerState<AddDriverPaymentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedDriverId;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDriverId = widget.initialDriverId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.black,
              surface: Color(0xFF171A24),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
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
        paymentDate: _selectedDate,
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
        child: SingleChildScrollView(
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
                    onChanged: widget.initialDriverId != null ? null : (val) => setState(() => _selectedDriverId = val),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => const Text('Error loading drivers', style: TextStyle(color: Colors.red)),
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _selectDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                  ),
                  child: Text(
                    DateFormat('MMM dd, yyyy').format(_selectedDate),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
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
