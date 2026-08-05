import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:ubs_fleet_app/l10n/app_localizations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_text_field.dart';

class DailyLogScreen extends StatefulWidget {
  final DateTime? dutyStartTime;
  final int? startKm;
  
  const DailyLogScreen({super.key, this.dutyStartTime, this.startKm});

  @override
  State<DailyLogScreen> createState() => _DailyLogScreenState();
}

class _DailyLogScreenState extends State<DailyLogScreen> {
  late int _startKm; 
  
  final _endKmController = TextEditingController();
  final _octaneKmController = TextEditingController();
  final _tollParkingController = TextEditingController();
  
  int _totalRun = 0;
  int _cngRun = 0;
  bool _isNightStay = false;
  
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _startKm = widget.startKm ?? 250507;
    _startTime = widget.dutyStartTime ?? DateTime.now().subtract(const Duration(hours: 8));
    _endTime = DateTime.now();
    
    _endKmController.addListener(_calculateTotal);
    _octaneKmController.addListener(_calculateFuel);
  }

  void _calculateTotal() {
    final endKm = int.tryParse(_endKmController.text) ?? 0;
    if (endKm >= _startKm) {
      setState(() {
        _totalRun = endKm - _startKm;
      });
      _calculateFuel(); // Re-calculate cng if total changes
    } else {
      setState(() {
        _totalRun = 0;
        _calculateFuel(); // Reset fuel too
      });
    }
  }

  void _calculateFuel() {
    final octaneKm = int.tryParse(_octaneKmController.text) ?? 0;
    setState(() {
      _cngRun = (_totalRun - octaneKm).clamp(0, 999999);
    });
  }
  
  String _calculateDutyHours() {
    final diff = _endTime.difference(_startTime);
    final hours = diff.inHours;
    final minutes = diff.inMinutes.remainder(60);
    return "${hours}h ${minutes}m";
  }

  String _calculateExtraService() {
    final diff = _endTime.difference(_startTime);
    if (diff.inHours >= 10 || (diff.inHours == 9 && diff.inMinutes.remainder(60) > 0)) {
      // If total time > 10 hours, calculate extra
      // Wait, 9h 30m is not > 10h. It should just be diff > 10 hours.
      if (diff > const Duration(hours: 10)) {
        final extraDiff = diff - const Duration(hours: 10);
        final extraHours = extraDiff.inHours;
        final extraMinutes = extraDiff.inMinutes.remainder(60);
        if (extraHours == 0) return "${extraMinutes}m";
        return "${extraHours}h ${extraMinutes}m";
      }
    }
    return "0h";
  }
  
  Future<void> _editStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: AppColors.background,
              onSurface: Colors.white,
            ),
          ),
          child: Localizations.override(
            context: context,
            locale: const Locale('en', 'US'),
            child: child!,
          ),
        );
      }
    );
    
    if (picked != null) {
      setState(() {
        _startTime = DateTime(
          _startTime.year,
          _startTime.month,
          _startTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  void dispose() {
    _endKmController.dispose();
    _octaneKmController.dispose();
    _tollParkingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final timeFormat = DateFormat('hh:mm a');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: l10n.endDutyTitle.text.bold.letterSpacing(1.5).white.make(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.cyanAccent.withValues(alpha: 0.1),
              ),
            ).box.withShadow([BoxShadow(color: Colors.cyanAccent.withValues(alpha: 0.2), blurRadius: 100)]).make(),
          ),
          
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // Time & Duty Hours Section
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.access_time, color: Colors.cyanAccent, size: 20),
                                8.widthBox,
                                "Duty Time".text.bold.color(Colors.cyanAccent).make(),
                              ],
                            ),
                            "Total: ${_calculateDutyHours()}".text.bold.white.make(),
                          ],
                        ),
                        const Divider(color: Colors.white12).py8(),
                        
                        // Start Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "Start Time".text.color(Colors.white70).make(),
                            Row(
                              children: [
                                timeFormat.format(_startTime).text.white.make(),
                                8.widthBox,
                                InkWell(
                                  onTap: _editStartTime,
                                  child: const Icon(Icons.edit, color: Colors.orangeAccent, size: 18).p4(),
                                ),
                              ],
                            ),
                          ],
                        ),
                        8.heightBox,
                        
                        // End Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            "End Time (Now)".text.color(Colors.white70).make(),
                            timeFormat.format(_endTime).text.white.make(),
                          ],
                        ),
                      ],
                    ),
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  16.heightBox,

                  // Start KM Card (Read-only)
                  _buildGlassCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.speed, color: Colors.white54),
                            12.widthBox,
                            l10n.startKm.text.color(Colors.white70).make(),
                          ],
                        ),
                        _startKm.toString().text.xl.bold.white.make(),
                      ],
                    ),
                  ).animate().fade(delay: 50.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  16.heightBox,

                  // End KM Input
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _endKmController,
                          hint: l10n.endKm,
                          icon: Icons.speed,
                          keyboardType: TextInputType.number,
                        ),
                        16.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            l10n.totalRun.text.color(Colors.cyanAccent).make(),
                            "$_totalRun KM".text.xl.bold.color(Colors.cyanAccent).make(),
                          ],
                        ).pSymmetric(h: 8),
                      ],
                    ),
                  ).animate().fade(delay: 100.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                  16.heightBox,

                  // Fuel Breakdown
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextField(
                          controller: _octaneKmController,
                          hint: l10n.octaneRun,
                          icon: Icons.local_gas_station,
                          keyboardType: TextInputType.number,
                        ),
                        16.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            l10n.cngRun.text.color(Colors.greenAccent).make(),
                            "$_cngRun KM".text.xl.bold.color(Colors.greenAccent).make(),
                          ],
                        ).pSymmetric(h: 8),
                      ],
                    ),
                  ).animate().fade(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),

                  16.heightBox,

                  // Additional Info
                  _buildGlassCard(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.design_services, color: Colors.white54),
                                12.widthBox,
                                l10n.extraService.text.color(Colors.white70).make(),
                              ],
                            ),
                            _calculateExtraService().text.xl.bold.color(Colors.cyanAccent).make(),
                          ],
                        ).pSymmetric(h: 8),
                        16.heightBox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.night_shelter, color: Colors.white54),
                                12.widthBox,
                                l10n.nightStay.text.color(Colors.white70).make(),
                              ],
                            ),
                            Switch(
                              value: _isNightStay,
                              onChanged: (val) {
                                setState(() {
                                  _isNightStay = val;
                                });
                              },
                              activeTrackColor: Colors.cyanAccent.withValues(alpha: 0.5),
                              activeThumbColor: Colors.cyanAccent,
                            ),
                          ],
                        ).pSymmetric(h: 8),
                      ],
                    ),
                  ).animate().fade(delay: 300.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  16.heightBox,

                  // Daily Expenses Section
                  _buildGlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.account_balance_wallet, color: Colors.cyanAccent, size: 20),
                                8.widthBox,
                                "Daily Expenses".text.bold.color(Colors.cyanAccent).make(),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.cyanAccent.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.camera_alt, color: Colors.cyanAccent, size: 14),
                                  4.widthBox,
                                  "Receipt".text.color(Colors.cyanAccent).size(12).bold.make(),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.white12).py8(),
                        
                        CustomTextField(
                          controller: _tollParkingController,
                          hint: "Toll / Parking (৳)",
                          icon: Icons.local_parking,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ).animate().fade(delay: 350.ms, duration: 400.ms).slideY(begin: 0.1, end: 0),
                  
                  40.heightBox,
                  
                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      // Submit action -> Return true to end duty on home screen
                      Navigator.pop(context, true); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 8,
                      shadowColor: Colors.cyanAccent.withValues(alpha: 0.5),
                    ),
                    child: l10n.submitLog.text.xl.bold.letterSpacing(1).make(),
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

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white12),
          ),
          child: child,
        ),
      ),
    );
  }
}
