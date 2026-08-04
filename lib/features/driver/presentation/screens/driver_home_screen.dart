import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ubs_fleet_app/l10n/app_localizations.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/providers/locale_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  bool _isDutyOn = false;
  DateTime? _dutyStartTime;
  int? _currentStartKm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                _buildAppBar(l10n),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildProfileSection(l10n),
                        30.heightBox,
                        _buildStartDutyCard(l10n),
                        24.heightBox,
                        _buildMeterReadingCard(l10n),
                        24.heightBox,
                        _buildRecentLogsSection(l10n),
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
    );
  }

  void _showStartDutyDialog(BuildContext context) {
    final startKmController = TextEditingController(text: '250507');
    final l10n = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.verifyStartKmTitle, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.verifyStartKmDesc,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: startKmController,
                  hint: l10n.startKm,
                  icon: Icons.speed,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel, style: const TextStyle(color: Colors.white54)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                setState(() {
                  _isDutyOn = true;
                  _dutyStartTime = DateTime.now();
                  _currentStartKm = int.tryParse(startKmController.text) ?? 250507;
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent),
              child: Text(l10n.startDuty, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }
    );
  }

  Widget _buildAppBar(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: Colors.white70, size: 28),
          l10n.appTitle.text.bold.letterSpacing(1.5).white.make(),
          Consumer(
            builder: (context, ref, child) {
              final locale = ref.watch(localeProvider);
              final isEn = locale.languageCode == 'en';
              return GestureDetector(
                onTap: () {
                  ref.read(localeProvider.notifier).state = Locale(isEn ? 'bn' : 'en');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.cyan.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyan.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.language, size: 16, color: Colors.cyanAccent),
                      const SizedBox(width: 6),
                      Text(
                        isEn ? "বাং" : "EN",
                        style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection(AppLocalizations l10n) {
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
                l10n.welcome.text
                    .color(Colors.white54)
                    .size(12)
                    .letterSpacing(1)
                    .make(),
                "ALEX J.".text.white.xl2.bold.letterSpacing(1).make(),
              ],
            ),
          ],
        ),
        (_isDutyOn ? l10n.onDuty : l10n.offDuty).text
            .color(_isDutyOn ? Colors.greenAccent : Colors.white54)
            .bold
            .make(),
        if (_isDutyOn && _dutyStartTime != null) ...[
          4.heightBox,
          "Started at: ${DateFormat('hh:mm a').format(_dutyStartTime!)}"
              .text
              .size(12)
              .color(Colors.white54)
              .make(),
        ],
      ],
    );
  }

  Widget _buildStartDutyCard(AppLocalizations l10n) {
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
                onTap: () async {
                  if (_isDutyOn) {
                    final result = await context.push(
                      '/driver/daily-log', 
                      extra: {
                        'startTime': _dutyStartTime,
                        'startKm': _currentStartKm,
                      }
                    );
                    if (result == true) {
                      setState(() {
                        _isDutyOn = false;
                        _dutyStartTime = null;
                        _currentStartKm = null;
                      });
                    }
                  } else {
                    _showStartDutyDialog(context);
                  }
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
                    child: (_isDutyOn ? l10n.endDuty : l10n.startDuty).text.xl2.bold
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

  Widget _buildMeterReadingCard(AppLocalizations l10n) {
    final displayKm = _isDutyOn && _currentStartKm != null ? _currentStartKm! : 250507;
    final formatter = NumberFormat('#,##0');
    final formattedKm = formatter.format(displayKm);
    
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
              l10n.meterReading.text.bold.white.letterSpacing(1).make(),
              const Divider(color: Colors.white12, height: 24, thickness: 1),
              l10n.currentReading.text.color(Colors.white60).make(),
              8.heightBox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Glowing Text
                  Expanded(
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            formattedKm,
                            style: const TextStyle(
                              fontFamily: 'Seven Segment',
                              fontSize: 45,
                              color: Color(0xFF2EFA73),
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: Color(0x992EFA73),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                          ),
                          8.widthBox,
                          "KM".text.color(const Color(0xFF2EFA73)).size(16).bold.make(),
                        ],
                      ),
                    ),
                  ),
                  12.widthBox,
                  // Log New Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.cyan.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                    ),
                    child: l10n.logNew.text.bold.color(Colors.cyanAccent).make(),
                  ).onTap(() {
                    context.push('/driver/expense');
                  }),
                ],
              ),
              16.heightBox,
              Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    l10n.yesterdaysClosing.text
                        .color(Colors.white54)
                        .size(12)
                        .make(),
                    "250,507 KM".text.white.bold.fontFamily('Orbitron').make(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fade(delay: 200.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildRecentLogsSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        l10n.recentLogs.text.color(Colors.white54).letterSpacing(1).make(),
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
                      l10n.uploadReceipt.text.bold
                          .color(Colors.greenAccent)
                          .letterSpacing(1)
                          .make(),
                      4.heightBox,
                      l10n.optional.text
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
}
