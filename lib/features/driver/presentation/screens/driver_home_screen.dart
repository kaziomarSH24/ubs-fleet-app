import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isDutyOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFF0B1320,
      ), // Darker background similar to mockup
      body: Stack(
        children: [
          // Real Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/driver_bg.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileSection(),
                        30.heightBox,
                        _buildStartDutyCard(),
                        24.heightBox,
                        _buildMeterReadingCard(),
                        24.heightBox,
                        _buildRecentLogsSection(),
                        24.heightBox,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Colors.white70, size: 28),
          "DRIVER COMPANION".text.bold.letterSpacing(1.5).white.make(),
          const SizedBox(width: 28), // Spacer to balance the menu icon
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white24, width: 2),
              ),
              child: const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white10,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
            ),
            16.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "WELCOME,".text
                    .color(Colors.white54)
                    .size(12)
                    .letterSpacing(1)
                    .make(),
                "ALEX J.".text.white.xl2.bold.letterSpacing(1).make(),
              ],
            ),
          ],
        ),
        (_isDutyOn ? "ON DUTY" : "OFF DUTY").text
            .color(_isDutyOn ? Colors.greenAccent : Colors.white54)
            .bold
            .make(),
      ],
    );
  }

  Widget _buildStartDutyCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.cyan.withValues(alpha: 0.5), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.cyan.withValues(alpha: 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // ON / OFF toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    "ON".text
                        .color(_isDutyOn ? Colors.cyan : Colors.white54)
                        .bold
                        .make(),
                    " / ".text.color(Colors.white30).make(),
                    "OFF".text
                        .color(!_isDutyOn ? Colors.cyan : Colors.white54)
                        .bold
                        .make(),
                  ],
                ),
              ),
              24.heightBox,
              // Start Duty Button
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isDutyOn = !_isDutyOn;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _isDutyOn
                          ? [Colors.redAccent, Colors.orangeAccent]
                          : [Colors.cyan.shade400, Colors.tealAccent],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: (_isDutyOn ? Colors.redAccent : Colors.cyan)
                            .withValues(alpha: 0.4),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Center(
                    child: (_isDutyOn ? "END DUTY" : "START DUTY").text.xl2.bold
                        .color(Colors.black87)
                        .make(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMeterReadingCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "METER READING (KM)".text.bold.white.letterSpacing(1).make(),
              const Divider(color: Colors.white12, height: 24, thickness: 1),

              "Current Reading".text.color(Colors.white60).make(),
              8.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Digital Glowing Text
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        "24,567.8",
                        style: GoogleFonts.shareTechMono(
                          fontSize: 34,
                          color: Colors.greenAccent,
                          shadows: [
                            Shadow(
                              color: Colors.greenAccent.withValues(alpha: 0.6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      4.widthBox,
                      "KM".text.color(Colors.greenAccent).bold.make(),
                    ],
                  ),
                  // Log New Button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                    ),
                    child: "LOG NEW".text.bold.color(Colors.cyanAccent).make(),
                  ),
                ],
              ),
              16.heightBox,
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    "Yesterday's Closing".text
                        .color(Colors.white54)
                        .size(12)
                        .make(),
                    "24,490.2 KM".text.white.bold.make(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentLogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        "RECENT LOGS".text.color(Colors.white54).letterSpacing(1).make(),
        12.heightBox,
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12.0, sigmaY: 12.0),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      "UPLOAD RECEIPT".text.bold
                          .color(Colors.greenAccent)
                          .letterSpacing(1)
                          .make(),
                      4.heightBox,
                      "OPTIONAL".text
                          .color(Colors.white54)
                          .size(12)
                          .letterSpacing(1)
                          .make(),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.greenAccent.withValues(alpha: 0.3),
                      ),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: Colors.greenAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ).animate().fade(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildBottomNav() {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: BottomNavigationBar(
        backgroundColor: const Color(0xFF0B1320),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white54,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.speed),
            ),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.directions_car_outlined),
            ),
            label: "Vehicles",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.receipt_long_outlined),
            ),
            label: "Logs",
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.person_outline),
            ),
            label: "Account",
          ),
        ],
      ),
    );
  }
}
