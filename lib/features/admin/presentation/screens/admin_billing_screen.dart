import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_aurora_background.dart';

class AdminBillingScreen extends StatelessWidget {
  const AdminBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAuroraBackground(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Billing & Expenses', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      child: const Center(
        child: Text('Billing Screen', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
