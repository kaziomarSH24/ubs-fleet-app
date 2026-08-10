import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AdminBillingScreen extends StatelessWidget {
  const AdminBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Billing & Expenses', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: const Center(
        child: Text('Billing Screen', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
