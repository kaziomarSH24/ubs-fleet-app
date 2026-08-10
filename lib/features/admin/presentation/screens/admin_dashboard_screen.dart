import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Admin Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
      body: const Center(
        child: Text('Admin Dashboard', style: TextStyle(color: AppColors.textPrimary)),
      ),
    );
  }
}
