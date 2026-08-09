import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/app_localizations.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../auth/data/services/auth_service.dart';
import '../../data/repositories/driver_repository.dart';
import '../../../../core/database/entities/daily_log_local.dart';

class DriverLogsScreen extends ConsumerStatefulWidget {
  const DriverLogsScreen({super.key});

  @override
  ConsumerState<DriverLogsScreen> createState() => _DriverLogsScreenState();
}

class _DriverLogsScreenState extends ConsumerState<DriverLogsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _currentMonth = DateTime.now();
  
  @override
  void initState() {
    super.initState();
    _syncExistingLogs();
  }

  Future<void> _syncExistingLogs() async {
    final profile = ref.read(authServiceProvider).getLocalProfile();
    if (profile != null) {
      await ref.read(driverRepositoryProvider).syncDownData(profile.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFF070D14), // Darker background to match image 3
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              radius: 16,
              child: Icon(Icons.person, color: Colors.black, size: 20),
            ),
            12.widthBox,
            (l10n?.tripHistory ?? "TRIP HISTORY").text.white.letterSpacing(1).bold.make(),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month, color: Colors.cyanAccent),
            onPressed: () => _selectDateRange(context),
          ),
          8.widthBox,
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/dark_map_optimized.jpg'),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: Column(
          children: [
            // Month Selector (One month at a time)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_startDate != null && _endDate != null) ...[
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent, size: 20),
                      onPressed: () {
                        setState(() {
                          _startDate = null;
                          _endDate = null;
                        });
                      },
                    ),
                    "${DateFormat('MMM d, yyyy').format(_startDate!)} - ${DateFormat('MMM d, yyyy').format(_endDate!)}"
                        .text.white.bold.make(),
                    const SizedBox(width: 48), // Balance row
                  ] else ...[
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                        });
                      },
                    ),
                    DateFormat('MMMM yyyy').format(_currentMonth).text.white.bold.lg.make(),
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios, color: _currentMonth.month == DateTime.now().month && _currentMonth.year == DateTime.now().year ? Colors.white24 : Colors.cyanAccent, size: 16),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        if (_currentMonth.month == DateTime.now().month && _currentMonth.year == DateTime.now().year) return;
                        setState(() {
                          _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                        });
                      },
                    ),
                  ]
                ],
              ),
            ),
            
            // Logs List
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: ref.read(driverRepositoryProvider).getLogsListenable(),
                builder: (context, box, _) {
                  final authService = ref.read(authServiceProvider);
                  final profile = authService.getLocalProfile();
                  
                  if (profile == null) {
                    return const Center(child: Text("No driver logged in", style: TextStyle(color: Colors.white)));
                  }
                  
                  final effectiveStart = _startDate ?? DateTime(_currentMonth.year, _currentMonth.month, 1);
                  final effectiveEnd = _endDate ?? DateTime(_currentMonth.year, _currentMonth.month + 1, 0, 23, 59, 59);

                  final logs = ref.read(driverRepositoryProvider).getLogs(
                    profile.id,
                    start: effectiveStart,
                    end: effectiveEnd,
                  );
                  
                  if (logs.isEmpty) {
                    return Center(child: "No logs found".text.white.make());
                  }

                  // Group logs by Date
                  final Map<String, List<DailyLogLocal>> groupedLogs = {};
                  for (var log in logs) {
                    final dateKey = DateFormat('yyyy-MM-dd').format(log.startTime);
                    groupedLogs.putIfAbsent(dateKey, () => []).add(log);
                  }
                  
                  final sortedDates = groupedLogs.keys.toList()..sort((a, b) => b.compareTo(a));

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).copyWith(bottom: 100),
                    itemCount: sortedDates.length,
                    itemBuilder: (context, index) {
                      final dateKey = sortedDates[index];
                      final dayLogs = groupedLogs[dateKey]!;
                      
                      // Calculate Daily Totals
                      int dailyKm = 0;
                      Duration dailyDuration = Duration.zero;
                      double dailyExpense = 0.0;
                      bool hasOngoing = false;
                      
                      for (var log in dayLogs) {
                        dailyKm += (log.totalKm ?? 0);
                        if (log.endTime != null) {
                          dailyDuration += log.endTime!.difference(log.startTime);
                        } else {
                          hasOngoing = true;
                        }
                        
                        final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
                        dailyExpense += expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
                      }
                      
                      final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(dateKey)).toUpperCase();
                      
                      String durationStr = "";
                      if (dailyDuration.inHours > 0) {
                        durationStr = "${dailyDuration.inHours} HR ${dailyDuration.inMinutes.remainder(60)} MIN";
                      } else {
                        durationStr = "${dailyDuration.inMinutes} MIN";
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Daily Summary Header
                          GestureDetector(
                            onTap: () => _showDailySummaryModal(context, dateKey, dayLogs),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              margin: EdgeInsets.only(bottom: 16, top: index == 0 ? 0 : 16),
                              decoration: BoxDecoration(
                                color: Colors.cyan.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        formattedDate.text.color(Colors.cyanAccent).bold.make(),
                                        6.heightBox,
                                        (hasOngoing ? "Includes Ongoing Duty" : "Daily Total").text.white.size(12).make(),
                                      ],
                                    ),
                                  ),
                                  8.widthBox,
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      "${hasOngoing && dailyKm == 0 ? '--' : dailyKm} KM | ${hasOngoing && dailyDuration.inMinutes == 0 ? '--' : durationStr}".text.white.bold.size(13).make(),
                                      6.heightBox,
                                      "৳ ${dailyExpense.toInt()}".text.color(Colors.greenAccent).bold.make(),
                                    ],
                                  ),
                                ],
                              ),
                            ).animate().fade(delay: (50 * index).ms).slideX(begin: -0.1, end: 0),
                          ),
                          
                          // Individual Logs for this Date
                          ...dayLogs.map((log) {
                            final isLatest = index == 0 && _startDate == null && log == dayLogs.first;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildLogCard(log, isLatest),
                            ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
                          }),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF0F1A2C),
              onSurface: Colors.white,
            ), dialogTheme: DialogThemeData(backgroundColor: const Color(0xFF0B1320)),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  Widget _buildLogCard(DailyLogLocal log, bool isLatest) {
    final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
    final totalExpense = expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
    
    final dateStr = DateFormat('EEE, MMM d').format(log.startTime).toUpperCase();
    final runKm = log.totalKm != null ? "${log.totalKm} KM" : "ONGOING";
    
    String durationStr = "ONGOING";
    if (log.endTime != null) {
      final diff = log.endTime!.difference(log.startTime);
      if (diff.inHours > 0) {
        durationStr = "${diff.inHours} HR ${diff.inMinutes.remainder(60)} MIN";
      } else {
        durationStr = "${diff.inMinutes} MIN";
      }
    }
    return GestureDetector(
      onTap: () => _showLogDetailsModal(context, log, totalExpense),
      child: Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLatest ? Colors.cyanAccent : Colors.white10,
          width: isLatest ? 1.5 : 1.0,
        ),
        boxShadow: isLatest ? [
          BoxShadow(
            color: Colors.cyanAccent.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
          )
        ] : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              dateStr.text.color(Colors.cyanAccent).size(12).bold.make(),
              8.heightBox,
              (log.status == 'ongoing' ? 'ACTIVE LOG' : 'DAILY LOG').text.white.xl2.bold.make(),
              12.heightBox,
              Row(
                children: [
                  const Icon(Icons.speed, color: Colors.greenAccent, size: 16),
                  6.widthBox,
                  runKm.text.color(Colors.greenAccent).bold.make(),
                ],
              ),
            ],
          ),
          
          // Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Icon(Icons.speed, color: Colors.cyanAccent.withValues(alpha: 0.7), size: 16),
                  8.widthBox,
                  Icon(Icons.access_time, color: Colors.white54, size: 16),
                  8.widthBox,
                  Icon(Icons.receipt_long, color: Colors.greenAccent.withValues(alpha: 0.7), size: 16),
                ],
              ),
              16.heightBox,
              durationStr.text.color(Colors.white70).size(12).make(),
              8.heightBox,
              "EXPENSES: ৳ ${totalExpense.toInt()}".text.color(Colors.greenAccent).size(12).make(),
            ],
          ),
        ],
      ),
    ));
  }

  void _showLogDetailsModal(BuildContext context, DailyLogLocal log, double totalExpense) {
    final l10n = AppLocalizations.of(context)!;
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A2C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 2)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  24.heightBox,
                  "TRIP SUMMARY".text.xl2.bold.color(Colors.cyanAccent).letterSpacing(1.2).make(),
                  8.heightBox,
                  dateFormat.format(log.startTime).text.color(Colors.white54).make(),
                  24.heightBox,
                  
                  _buildDetailRow(Icons.play_circle_fill, "Start Time", timeFormat.format(log.startTime), color: Colors.greenAccent),
                  if (log.endTime != null) ...[
                    _buildDetailRow(Icons.stop_circle, "End Time", timeFormat.format(log.endTime!), color: Colors.redAccent),
                    
                    // Calculate Duty Hours and Overtime
                    Builder(
                      builder: (context) {
                        final diff = log.endTime!.difference(log.startTime);
                        final hours = diff.inHours;
                        final minutes = diff.inMinutes.remainder(60);
                        final durationStr = "${hours}h ${minutes}m";
                        
                        String overtimeStr = "0h";
                        if (diff > const Duration(hours: 10)) {
                          final extra = diff - const Duration(hours: 10);
                          overtimeStr = "${extra.inHours}h ${extra.inMinutes.remainder(60)}m";
                        }
                        
                        return Column(
                          children: [
                            const Divider(color: Colors.white10, height: 24),
                            _buildDetailRow(Icons.access_time, "Total Duty Hours", durationStr, color: Colors.cyanAccent, isBold: true),
                            _buildDetailRow(Icons.more_time, "Overtime (after 10h)", overtimeStr, color: Colors.orangeAccent),
                          ],
                        );
                      }
                    ),
                  ],
              
              const Divider(color: Colors.white10, height: 24),
              
              _buildDetailRow(Icons.speed, "Start KM", "${log.startKm} KM"),
              if (log.endKm != null)
                _buildDetailRow(Icons.speed, "End KM", "${log.endKm} KM"),
              if (log.totalKm != null)
                _buildDetailRow(Icons.route, "Total Distance", "${log.totalKm} KM", color: Colors.cyanAccent, isBold: true),
              
              if (log.cngKm != null && log.cngKm! > 0)
                _buildDetailRow(Icons.local_gas_station, "CNG Run", "${log.cngKm} KM", color: Colors.greenAccent),
              if (log.lpgKm != null && log.lpgKm! > 0)
                _buildDetailRow(Icons.local_gas_station, "LPG Run", "${log.lpgKm} KM", color: Colors.greenAccent),
              if (log.octaneKm != null && log.octaneKm! > 0)
                _buildDetailRow(Icons.local_gas_station, "Octane Run", "${log.octaneKm} KM", color: Colors.greenAccent),
              
              const Divider(color: Colors.white10, height: 24),
              
              _buildDetailRow(Icons.night_shelter, "Night Stay", log.nightStay ? "Yes" : "No"),
              _buildDetailRow(Icons.receipt_long, "Total Expenses", "৳ ${totalExpense.toInt()}", color: Colors.orangeAccent),
              
              if (log.isStartTimeEdited) ...[
                const Divider(color: Colors.white10, height: 24),
                Row(
                  children: [
                    const Icon(Icons.edit_note, color: Colors.orangeAccent, size: 20),
                    8.widthBox,
                    "Start time was manually edited".text.color(Colors.orangeAccent).size(12).italic.make(),
                  ],
                ),
              ],
              
                  32.heightBox,
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value, {Color color = Colors.white70, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.white30),
              12.widthBox,
              label.text.color(Colors.white54).make(),
            ],
          ),
          value.text.color(color).fontWeight(isBold ? FontWeight.bold : FontWeight.normal).make(),
        ],
      ),
    );
  }

  void _showDailySummaryModal(BuildContext context, String dateKey, List<DailyLogLocal> dayLogs) {
    int totalKm = 0;
    int totalCng = 0;
    int totalLpg = 0;
    int totalOctane = 0;
    Duration totalDuration = Duration.zero;
    double totalExpense = 0.0;
    bool hasOngoing = false;

    for (var log in dayLogs) {
      totalKm += (log.totalKm ?? 0);
      totalCng += (log.cngKm ?? 0);
      totalLpg += (log.lpgKm ?? 0);
      totalOctane += (log.octaneKm ?? 0);
      
      if (log.endTime != null) {
        totalDuration += log.endTime!.difference(log.startTime);
      } else {
        hasOngoing = true;
      }
      
      final expenses = ref.read(driverRepositoryProvider).getExpensesForLog(log.id);
      totalExpense += expenses.fold<double>(0, (sum, exp) => sum + exp.amount);
    }
    
    final formattedDate = DateFormat('EEEE, MMM d, yyyy').format(DateTime.parse(dateKey));
    
    final hours = totalDuration.inHours;
    final minutes = totalDuration.inMinutes.remainder(60);
    final durationStr = "${hours}h ${minutes}m";
    
    String overtimeStr = "0h";
    if (totalDuration > const Duration(hours: 10)) {
      final extra = totalDuration - const Duration(hours: 10);
      overtimeStr = "${extra.inHours}h ${extra.inMinutes.remainder(60)}m";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A2C),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(top: BorderSide(color: Colors.cyanAccent.withValues(alpha: 0.3), width: 2)),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  24.heightBox,
                  "DAILY SUMMARY".text.xl2.bold.color(Colors.cyanAccent).letterSpacing(1.2).make(),
                  8.heightBox,
                  formattedDate.text.color(Colors.white54).make(),
                  if (hasOngoing) ...[
                    4.heightBox,
                    "Includes Ongoing Duty".text.size(12).color(Colors.orangeAccent).italic.make(),
                  ],
                  24.heightBox,
                  
                  _buildDetailRow(Icons.access_time, "Total Duty Hours", durationStr, color: Colors.cyanAccent, isBold: true),
                  _buildDetailRow(Icons.more_time, "Total Overtime (after 10h)", overtimeStr, color: Colors.orangeAccent),
                  
                  const Divider(color: Colors.white10, height: 24),
                  
                  _buildDetailRow(Icons.route, "Total Distance", "$totalKm KM", color: Colors.cyanAccent, isBold: true),
                  if (totalCng > 0)
                    _buildDetailRow(Icons.local_gas_station, "Total CNG Run", "$totalCng KM", color: Colors.greenAccent),
                  if (totalLpg > 0)
                    _buildDetailRow(Icons.local_gas_station, "Total LPG Run", "$totalLpg KM", color: Colors.greenAccent),
                  if (totalOctane > 0)
                    _buildDetailRow(Icons.local_gas_station, "Total Octane Run", "$totalOctane KM", color: Colors.greenAccent),
                  
                  const Divider(color: Colors.white10, height: 24),
                  
                  _buildDetailRow(Icons.receipt_long, "Total Expenses", "৳ ${totalExpense.toInt()}", color: Colors.orangeAccent, isBold: true),
                  
                  32.heightBox,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
