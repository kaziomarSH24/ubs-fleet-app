import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/providers/locale_provider.dart';


class DriverProfileScreen extends ConsumerWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    // Mock user & vehicle data
    final mockUser = {
      'name': 'Kazi Omar',
      'id': 'EMP-2401',
      'phone': '+880 1711-223344',
      'license': 'DL-BD-987654321',
    };
    
    final mockVehicle = {
      'model': 'Toyota HiAce 2018',
      'plate': 'Dhaka Metro-Cha 11-2233',
      'fuel': 'CNG + Octane',
    };

    return Scaffold(
      backgroundColor: const Color(0xFF070D14),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/driver_bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          // Heavy Glass Overlay
          Container(
            color: const Color(0xFF070D14).withValues(alpha: 0.85),
          ),
          
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20).copyWith(bottom: 100),
              child: Column(
                children: [
                  // App Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      24.widthBox, // Spacer
                      (l10n?.profileTitle ?? "MY PROFILE").text.white.letterSpacing(1).bold.xl.make(),
                      
                      // Language Toggle
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.3)),
                          color: Colors.cyanAccent.withValues(alpha: 0.1),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            final current = ref.read(localeProvider);
                            ref.read(localeProvider.notifier).state = Locale(current.languageCode == 'en' ? 'bn' : 'en');
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              children: [
                                const Icon(Icons.language, size: 16, color: Colors.cyanAccent),
                                4.widthBox,
                                (ref.watch(localeProvider).languageCode == 'en' ? 'বাং' : 'EN')
                                    .text
                                    .color(Colors.cyanAccent)
                                    .bold
                                    .make(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  40.heightBox,
                  
                  // Avatar Profile Picture
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blueAccent],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF0B1320),
                        child: Icon(Icons.person, size: 50, color: Colors.cyanAccent),
                      ),
                    ),
                  ).animate().scale(delay: 100.ms, duration: 400.ms),
                  16.heightBox,
                  (mockUser['name']!).text.white.bold.xl3.make(),
                  4.heightBox,
                  "ID: ${mockUser['id']!}".text.color(Colors.cyanAccent).letterSpacing(1).make(),
                  30.heightBox,
                  
                  // Personal Details Card (Glassmorphism)
                  _buildGlassCard(
                    title: l10n?.personalDetails ?? "PERSONAL DETAILS",
                    icon: Icons.badge_outlined,
                    children: [
                      _buildInfoRow(Icons.phone, l10n?.phoneNumber ?? "Phone Number", mockUser['phone']!),
                      const Divider(color: Colors.white10, height: 24),
                      _buildInfoRow(Icons.card_membership, l10n?.licenseNo ?? "License No", mockUser['license']!),
                    ],
                  ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0),
                  
                  20.heightBox,
                  
                  // Assigned Vehicle Card
                  _buildGlassCard(
                    title: l10n?.assignedVehicle ?? "ASSIGNED VEHICLE",
                    icon: Icons.directions_car_outlined,
                    children: [
                      _buildInfoRow(Icons.local_taxi, l10n?.vehicleModel ?? "Vehicle Model", mockVehicle['model']!),
                      const Divider(color: Colors.white10, height: 24),
                      _buildInfoRow(Icons.pin, l10n?.plateNumber ?? "Plate Number", mockVehicle['plate']!),
                      const Divider(color: Colors.white10, height: 24),
                      _buildInfoRow(Icons.local_gas_station, l10n?.fuelType ?? "Fuel Type", mockVehicle['fuel']!),
                    ],
                  ).animate().fade(delay: 300.ms).slideY(begin: 0.1, end: 0),
                  
                  40.heightBox,
                  
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement actual logout logic
                        context.go('/login');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
                        foregroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.redAccent, width: 1.5),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout),
                          8.widthBox,
                          (l10n?.logout ?? "LOGOUT").text.bold.letterSpacing(1).make(),
                        ],
                      ),
                    ),
                  ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  20.heightBox,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassCard({required String title, required IconData icon, required List<Widget> children}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.cyanAccent, size: 20),
                  8.widthBox,
                  title.text.color(Colors.cyanAccent).bold.letterSpacing(1).make(),
                ],
              ),
              16.heightBox,
              ...children,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        16.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              label.text.color(Colors.white54).size(12).make(),
              2.heightBox,
              value.text.white.bold.make(),
            ],
          ),
        ),
      ],
    );
  }
}
