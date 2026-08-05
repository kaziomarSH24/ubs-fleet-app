import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/theme/app_colors.dart';

class DriverLogsScreen extends StatefulWidget {
  const DriverLogsScreen({super.key});

  @override
  State<DriverLogsScreen> createState() => _DriverLogsScreenState();
}

class _DriverLogsScreenState extends State<DriverLogsScreen> {
  // Mock data for UI (matches image 3 layout)
  final mockLogs = [
    {
      'dateStr': 'WED, AUG 15',
      'title': 'DAILY LOG',
      'run': '45.8 KM',
      'duration': '1 HR 12 MIN',
      'expense': 'EXPENSES: ৳ 1,200',
      'isLatest': true,
    },
    {
      'dateStr': 'THU, AUG 13',
      'title': 'DAILY LOG',
      'run': '22.5 KM',
      'duration': '45 MIN',
      'expense': 'EXPENSES: ৳ 420',
      'isLatest': false,
    },
    {
      'dateStr': 'TUE, AUG 11',
      'title': 'DAILY LOG',
      'run': '68.2 KM',
      'duration': '1 HR 40 MIN',
      'expense': 'EXPENSES: ৳ 1,210',
      'isLatest': false,
    },
    {
      'dateStr': 'MON, AUG 10',
      'title': 'DAILY LOG',
      'run': '15.1 KM',
      'duration': '25 MIN',
      'expense': 'EXPENSES: ৳ 0',
      'isLatest': false,
    },
  ];

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
                  const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent, size: 16),
                  "August 2026".text.white.bold.lg.make(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
                ],
              ),
            ),
            
            // Logs List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: mockLogs.length,
                itemBuilder: (context, index) {
                  final log = mockLogs[index];
                  final isLatest = log['isLatest'] as bool;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildLogCard(log, isLatest),
                  ).animate().fade(delay: (50 * index).ms).slideY(begin: 0.1, end: 0);
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

    if (picked != null && context.mounted) {
      // In the future, we will fetch Supabase data using this date range
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Filtering logs from ${picked.start.toString().split(' ')[0]} to ${picked.end.toString().split(' ')[0]}',
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.cyanAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildLogCard(Map<String, dynamic> log, bool isLatest) {
    return Container(
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
              (log['dateStr'] as String).text.color(Colors.cyanAccent).size(12).bold.make(),
              8.heightBox,
              (log['title'] as String).text.white.xl2.bold.make(),
              12.heightBox,
              Row(
                children: [
                  const Icon(Icons.speed, color: Colors.greenAccent, size: 16),
                  6.widthBox,
                  (log['run'] as String).text.color(Colors.greenAccent).bold.make(),
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
              (log['duration'] as String).text.color(Colors.white70).size(12).make(),
              8.heightBox,
              (log['expense'] as String).text.color(Colors.greenAccent).size(12).make(),
            ],
          ),
        ],
      ),
    );
  }
}
