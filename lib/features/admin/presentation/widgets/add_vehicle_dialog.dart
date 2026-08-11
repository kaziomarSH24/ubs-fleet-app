import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../providers/admin_providers.dart';

class AddVehicleDialog extends ConsumerStatefulWidget {
  const AddVehicleDialog({super.key});

  @override
  ConsumerState<AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends ConsumerState<AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  String _vehicleModel = 'Toyota HiAce';
  final _yearController = TextEditingController();
  final _plateController = TextEditingController();
  String _fuelType = 'Octane';
  bool _isLoading = false;

  @override
  void dispose() {
    _yearController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      final fullModelName = '${_vehicleModel} ${_yearController.text.trim()}'.trim();
      
      await repo.addVehicle(
        model: fullModelName,
        plateNumber: _plateController.text.trim(),
        fuelType: _fuelType,
      );
      
      // Invalidate to refresh the list
      ref.invalidate(vehiclesProvider);
      if (mounted) {
        Navigator.pop(context);
        AppSnackbar.showSuccess(context, 'Vehicle added successfully');
      }
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, 'Error: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF171A24),
      title: const Text('Add New Vehicle', style: TextStyle(color: Colors.white)),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: _vehicleModel,
              dropdownColor: const Color(0xFF171A24),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Vehicle Model',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              items: ['Toyota HiAce', 'Toyota Noah', 'Toyota X-Noah', 'Sedan', 'Pickup', 'Microbus', 'Other']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _vehicleModel = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Model Year (e.g. 2018)',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _plateController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Plate Number',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: _fuelType,
              dropdownColor: const Color(0xFF171A24),
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Fuel Type',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
              ),
              items: ['Octane', 'CNG', 'LPG', 'Diesel', 'Hybrid', 'Electric']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => _fuelType = v!),
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
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          onPressed: _isLoading ? null : _submit,
          child: _isLoading 
            ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
            : const Text('Add Vehicle', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
