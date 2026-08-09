import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../../core/database/entities/daily_log_local.dart';
import '../../../../core/database/entities/expense_local.dart';
import '../../../../core/database/entities/profile_local.dart';
import '../../../../core/database/entities/vehicle_local.dart';

class PdfLogbookService {
  static Future<void> generateAndPrintMonthlyLogbook({
    required String monthYearStr, // e.g. "August 2026"
    required ProfileLocal driver,
    required Map<String, dynamic>? vehicle,
    required List<DailyLogLocal> monthlyLogs,
    required Map<String, List<ExpenseLocal>> logsExpenses, // log.id -> expenses
  }) async {
    final pdf = pw.Document();

    // Load Logo Image
    final ByteData logoData = await rootBundle.load('assets/images/logo.jpg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final logoImage = pw.MemoryImage(logoBytes);

    // Group logs by Day of the Month (1 to 31)
    final Map<int, List<DailyLogLocal>> dayLogsMap = {};
    for (var log in monthlyLogs) {
      dayLogsMap.putIfAbsent(log.startTime.day, () => []).add(log);
    }

    // Prepare Summary Data
    int presentDays = 0;
    int totalRunKm = 0;
    int totalExtraMins = 0; // use minutes for total extra
    int totalCngKm = 0;
    int totalOctaneKm = 0;
    int totalLpgKm = 0;
    int nightStayClaimCount = 0;
    double tollParkingBills = 0.0;
    
    // Calculate total toll/parking from all expenses this month
    for (var expenses in logsExpenses.values) {
      for (var exp in expenses) {
        if (exp.expenseType == 'toll_parking') {
          tollParkingBills += exp.amount;
        }
      }
    }

    // Process daily grouped logs for summaries
    dayLogsMap.forEach((day, logs) {
      presentDays++;
      for (var log in logs) {
        totalRunKm += (log.totalKm ?? 0);
        totalCngKm += (log.cngKm ?? 0);
        totalOctaneKm += (log.octaneKm ?? 0);
        totalLpgKm += (log.lpgKm ?? 0);
        
        if (log.nightStay) {
          nightStayClaimCount++;
        }
      }
      
      // Calculate extra service hour per day by combining total time
      logs.sort((a, b) => a.startTime.compareTo(b.startTime));
      final dutyStart = logs.first.startTime;
      final logsWithEnd = logs.where((l) => l.endTime != null).toList();
      if (logsWithEnd.isNotEmpty) {
        logsWithEnd.sort((a, b) => a.endTime!.compareTo(b.endTime!));
        final dutyEnd = logsWithEnd.last.endTime!;
        
        final duration = dutyEnd.difference(dutyStart);
        if (duration.inMinutes > 480) {
          totalExtraMins += (duration.inMinutes - 480);
        }
      }
    });

    String fullPlate = vehicle?['plate_number'] ?? "N/A";
    String shortPlate = fullPlate;
    if (fullPlate.contains(' ')) {
      shortPlate = fullPlate.split(' ').last;
    }
    
    String vehicleModel = vehicle?['model'] ?? "N/A";
    // Remove year (e.g. 2018) from the end if it exists
    vehicleModel = vehicleModel.replaceAll(RegExp(r'\s*\b\d{4}\b\s*$'), '').trim();

    String rawFuelType = vehicle?['fuel_type']?.toString().toLowerCase() ?? vehicle?['fuelType']?.toString().toLowerCase() ?? '';
    bool isLpg = rawFuelType.contains('lpg');
    String cngLpgHeader = isLpg ? 'LPG Run\nKM' : 'CNG Run\nKM';
    String cngLpgSummaryTitle = isLpg ? 'LPG Run KM' : 'CNG Run KM';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        build: (pw.Context context) {
          return [
            // HEADER ROW
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 60, // Smaller logo
                  child: pw.Image(logoImage),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 10),
                  child: pw.Text(
                    'LOG BOOK SUMMERY',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
                pw.SizedBox(width: 60), // Balance the layout
              ],
            ),
            
            pw.SizedBox(height: 12),

            // METADATA ROW 1
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaText('Supplier Name :', ' UNIQUE BUSINESS SOLUTIONS'),
                _buildMetaText('Month :', ' $monthYearStr'),
              ],
            ),
            pw.SizedBox(height: 4),
            
            // METADATA ROW 2
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaText('Vehicle Number :', ' $shortPlate'),
                _buildMetaText('Location :', ' ____________________'),
              ],
            ),
            pw.SizedBox(height: 4),
            
            // METADATA ROW 3
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                _buildMetaText('Vehicle Type :', ' $vehicleModel'),
                _buildMetaText('Driver Name :', ' ${driver.fullName}'),
                _buildMetaText('User Name :', ' ____________________'),
              ],
            ),
            
            pw.SizedBox(height: 8),

            // MAIN TABLE
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black, width: 1),
              columnWidths: {
                0: const pw.FlexColumnWidth(0.8), // Date
                1: const pw.FlexColumnWidth(1.2), // Start KM
                2: const pw.FlexColumnWidth(1.2), // End KM
                3: const pw.FlexColumnWidth(1.2), // Total Run
                4: const pw.FlexColumnWidth(1.2), // CNG Run
                5: const pw.FlexColumnWidth(1.2), // OCT Run
                6: const pw.FlexColumnWidth(1.2), // Duty Start
                7: const pw.FlexColumnWidth(1.2), // Duty End
                8: const pw.FlexColumnWidth(1.0), // Duty Hour
                9: const pw.FlexColumnWidth(1.2), // Extra
                10: const pw.FlexColumnWidth(1.2), // Night Stay
              },
              children: [
                // Table Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildHeaderCell('Date'),
                    _buildHeaderCell('Start KM'),
                    _buildHeaderCell('End KM'),
                    _buildHeaderCell('Total Run\nKM'),
                    _buildHeaderCell(cngLpgHeader),
                    _buildHeaderCell('OCT Run\nKM'),
                    _buildHeaderCell('Duty start\nTime'),
                    _buildHeaderCell('Duty End\nTime'),
                    _buildHeaderCell('Total Duty\nHour'),
                    _buildHeaderCell('Extra\nService'),
                    _buildHeaderCell('Night Stay'),
                  ],
                ),
                  
                  // Generate 31 Rows
                  ...List.generate(31, (index) {
                    final day = index + 1;
                    final logs = dayLogsMap[day] ?? [];

                    String startKm = '';
                    String endKm = '';
                    String totalKm = '';
                    String cngRunKm = '';
                    String octRunKm = '';
                    String startTime = '';
                    String endTime = '';
                    String totalHour = '';
                    String extraService = '';
                    String nightStayStr = '';
                    
                    // Determine if it's Friday or Saturday for coloring
                    // Create a date object to check weekday
                    // Note: dart DateTime weekday: Monday = 1, Friday = 5, Saturday = 6
                    // Since monthYearStr might not give us the exact year/month easily,
                    // we can get the year/month from the first log if it exists.
                    // If no logs exist, we can't accurately highlight weekends without passing the exact Month/Year.
                    // As a safe fallback, if there are logs, we use their year/month.
                    int? year, month;
                    if (monthlyLogs.isNotEmpty) {
                      year = monthlyLogs.first.startTime.year;
                      month = monthlyLogs.first.startTime.month;
                    }
                    
                    bool isWeekend = false;
                    if (year != null && month != null) {
                      // Validate if day is within valid days of month
                      final daysInMonth = DateTime(year, month + 1, 0).day;
                      if (day <= daysInMonth) {
                        final date = DateTime(year, month, day);
                        if (date.weekday == DateTime.friday || date.weekday == DateTime.saturday) {
                          isWeekend = true;
                        }
                      }
                    }

                    if (logs.isNotEmpty) {
                      logs.sort((a, b) => a.startTime.compareTo(b.startTime));
                      
                      // Values across all logs for the day
                      startKm = logs.first.startKm.toString();
                      
                      final logsWithEnd = logs.where((l) => l.endTime != null).toList();
                      if (logsWithEnd.isNotEmpty) {
                        logsWithEnd.sort((a, b) => a.endKm!.compareTo(b.endKm!));
                        endKm = logsWithEnd.last.endKm.toString();
                        
                        final logsWithTime = logs.where((l) => l.endTime != null).toList();
                        logsWithTime.sort((a, b) => a.endTime!.compareTo(b.endTime!));
                        final dutyEnd = logsWithTime.last.endTime!;
                        
                        endTime = DateFormat('h:mm a').format(dutyEnd);
                        
                        final duration = dutyEnd.difference(logs.first.startTime);
                        totalHour = '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
                        
                        if (duration.inMinutes > 480) {
                          final extraMins = duration.inMinutes - 480;
                          extraService = '${(extraMins / 60.0).toStringAsFixed(1)}h';
                        }
                      }
                      
                      startTime = DateFormat('h:mm a').format(logs.first.startTime);
                      
                      int dTotalKm = 0;
                      int dCngKm = 0;
                      int dOctaneKm = 0;
                      int dLpgKm = 0;
                      int dNightStay = 0;
                      
                      for (var l in logs) {
                        dTotalKm += (l.totalKm ?? 0);
                        dCngKm += (l.cngKm ?? 0);
                        dOctaneKm += (l.octaneKm ?? 0);
                        dLpgKm += (l.lpgKm ?? 0);
                        if (l.nightStay) dNightStay++;
                      }
                      
                      if (dTotalKm > 0) totalKm = dTotalKm.toString();
                      
                      // Handling fuel based on what user filled out (cng_km, octane_km, etc.)
                      if (dCngKm > 0 || dLpgKm > 0) {
                        cngRunKm = (dCngKm + dLpgKm).toString(); // Merge LPG into CNG column for simplicity, or handle based on app's structure
                      }
                      if (dOctaneKm > 0) {
                        octRunKm = dOctaneKm.toString();
                      }
                      
                      if (dNightStay > 0) nightStayStr = dNightStay.toString();
                    }

                    return pw.TableRow(
                      decoration: isWeekend ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
                      children: [
                        _buildDataCell(day.toString()),
                        _buildDataCell(startKm),
                        _buildDataCell(endKm),
                        _buildDataCell(totalKm),
                        _buildDataCell(cngRunKm), // CNG/LPG
                        _buildDataCell(octRunKm),
                        _buildDataCell(startTime),
                        _buildDataCell(endTime),
                        _buildDataCell(totalHour),
                        _buildDataCell(extraService),
                        _buildDataCell(nightStayStr), // Night Stay
                      ],
                    );
                  }),
                ],
              ),
              
            pw.SizedBox(height: 8),

            // SUMMARY TABLE
            pw.Container(
              width: 320,
              child: pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(children: [ 
                    _buildSumCell('Present Day', presentDays.toString()), 
                    _buildSumCell('Extra Service Hour', totalExtraMins > 0 ? '${(totalExtraMins / 60.0).toStringAsFixed(1)}h' : '') 
                  ]),
                  pw.TableRow(children: [ 
                    _buildSumCell(cngLpgSummaryTitle, totalCngKm > 0 || totalLpgKm > 0 ? (totalCngKm + totalLpgKm).toString() : ''), 
                    _buildSumCell('Night Stay Claim', nightStayClaimCount > 0 ? nightStayClaimCount.toString() : '') 
                  ]),
                  pw.TableRow(children: [ 
                    _buildSumCell('Oct Run KM', totalOctaneKm > 0 ? totalOctaneKm.toString() : (totalCngKm == 0 && totalLpgKm == 0 ? totalRunKm.toString() : '')), 
                    _buildSumCell('Toll/Parking Bill', tollParkingBills > 0 ? 'Tk ${tollParkingBills.toInt()}' : '') 
                  ]),
                ],
              ),
            ),
            
            pw.SizedBox(height: 20),

            // SIGNATURES
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(width: 140, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 4),
                    pw.Text('Supplier Concern Name and Signature', style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(width: 100, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 4),
                    pw.Text('Verified By User', style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Container(width: 100, height: 1, color: PdfColors.black),
                    pw.SizedBox(height: 4),
                    pw.Text('Verified By', style: const pw.TextStyle(fontSize: 8)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'LogBook_$monthYearStr.pdf',
    );
  }

  static pw.Widget _buildMetaText(String label, String value) {
    return pw.RichText(
      text: pw.TextSpan(
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.black),
        children: [
          pw.TextSpan(
            text: label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.TextSpan(
            text: value,
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildHeaderCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildDataCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _buildSumCell(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold)),
        ],
      )
    );
  }
}
