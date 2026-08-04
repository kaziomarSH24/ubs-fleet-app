import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_colors.dart';

/// Main Dashboard Screen for the Driver
/// Shows current trip status, vehicle info, and quick actions like Add Expense.
class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  // Temporary state for UI demonstration
  bool _isOnTrip = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              32.heightBox,
              _buildCurrentVehicleCard(),
              32.heightBox,
              _buildTripActionCard(),
              32.heightBox,
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the top header with the driver's greeting and profile icon.
  Widget _buildHeaderSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            "Good Morning,".text.color(AppColors.textSecondary).lg.make(),
            "John Doe".text.xl3.bold.color(AppColors.textPrimary).make(),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary, width: 2),
          ),
          child: const CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.inputBackground,
            child: Icon(Icons.person, color: AppColors.primary),
          ),
        ),
      ],
    ).animate().fade().slideY(begin: -0.2, end: 0);
  }

  /// Builds a card displaying the currently assigned vehicle details.
  Widget _buildCurrentVehicleCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: AppColors.primary, size: 32),
          ),
          16.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Toyota Corolla".text.xl.bold.color(AppColors.textPrimary).make(),
                4.heightBox,
                "Plate: DHK-12345".text.color(AppColors.textSecondary).make(),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textSecondary),
        ],
      ),
    ).animate().fade(delay: 200.ms).slideX(begin: 0.2, end: 0);
  }

  /// Builds the main call-to-action card for starting or ending a trip.
  Widget _buildTripActionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _isOnTrip 
              ? [AppColors.accentPurple.withOpacity(0.8), AppColors.accentPurple]
              : [AppColors.primary.withOpacity(0.8), AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (_isOnTrip ? AppColors.accentPurple : AppColors.primary).withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            _isOnTrip ? Icons.stop_circle_outlined : Icons.play_circle_fill_outlined,
            size: 64,
            color: Colors.black87,
          ),
          16.heightBox,
          (_isOnTrip ? "End Current Trip" : "Start New Trip")
              .text
              .xl2
              .bold
              .color(Colors.black87)
              .make(),
          8.heightBox,
          "Tap to enter odometer reading"
              .text
              .color(Colors.black54)
              .make(),
        ],
      ),
    ).onInkTap(() {
      // Toggle state for UI demonstration
      setState(() {
        _isOnTrip = !_isOnTrip;
      });
    }).animate().fade(delay: 400.ms).scale(curve: Curves.easeOutBack);
  }

  /// Builds a grid of quick action buttons (e.g., Add Expense, History).
  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "Quick Actions".text.xl2.bold.color(AppColors.textPrimary).make(),
        16.heightBox,
        Row(
          children: [
            _buildActionCard(
              icon: Icons.receipt_long,
              title: "Add Expense",
              color: Colors.orange,
              onTap: () {
                // TODO: Navigate to Expense Screen
              },
            ).expand(),
            16.widthBox,
            _buildActionCard(
              icon: Icons.history,
              title: "History",
              color: Colors.green,
              onTap: () {
                // TODO: Navigate to History Screen
              },
            ).expand(),
          ],
        ),
      ],
    ).animate().fade(delay: 600.ms).slideY(begin: 0.2, end: 0);
  }

  /// Helper method to build individual quick action cards.
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          12.heightBox,
          title.text.bold.color(AppColors.textPrimary).make(),
        ],
      ),
    ).onInkTap(onTap);
  }
}
