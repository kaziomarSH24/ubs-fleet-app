import 'dart:io';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PdfBillingSlipService {
  static Future<void> generateAndPrintSlip({
    required Map<String, dynamic> driverData,
    required Map<String, dynamic> billData,
  }) async {
    final pdf = pw.Document();

    final formatter = NumberFormat("#,##0.00", "en_US");
    
    // Extracting Data
    final driverName = driverData['full_name'] ?? 'Unknown';
    final dutyStation = driverData['duty_station'] ?? 'Unknown';
    
    // Vehicle info
    String vehicleNo = 'Unknown';
    
    // Try to get from passed data first
    if (driverData['vehicles'] != null && (driverData['vehicles'] as List).isNotEmpty) {
      vehicleNo = driverData['vehicles'][0]['plate_number'] ?? 'Unknown';
    }
    
    // If not found, fetch dynamically from Supabase
    if (vehicleNo == 'Unknown' && driverData['id'] != null) {
      try {
        final vehicle = await Supabase.instance.client
            .from('vehicles')
            .select('plate_number')
            .eq('current_driver_id', driverData['id'])
            .maybeSingle();
        if (vehicle != null) {
          vehicleNo = vehicle['plate_number'] ?? 'Unknown';
        }
      } catch (e) {
        // Ignore and keep 'Unknown'
      }
    }

    final monthStr = billData['month_year'] ?? ''; // e.g. "2026-08"
    String monthDisplay = monthStr;
    if (monthStr.length == 7) {
      final date = DateTime.tryParse('$monthStr-01');
      if (date != null) {
        monthDisplay = DateFormat('MMMM yyyy').format(date);
      }
    }

    // Fuel Bills
    final cngKm = (billData['actual_cng_km'] ?? 0).toDouble();
    final cngRate = (billData['cng_rate'] ?? 0).toDouble();
    final cngTotal = cngKm * cngRate;

    final lpgKm = (billData['actual_lpg_km'] ?? 0).toDouble();
    final lpgRate = (billData['lpg_rate'] ?? 0).toDouble();
    final lpgTotal = lpgKm * lpgRate;

    final octaneKm = (billData['actual_octane_km'] ?? 0).toDouble();
    final octaneRate = (billData['octane_rate'] ?? 0).toDouble();
    final octaneTotal = octaneKm * octaneRate;

    final startingFuel = (billData['starting_fuel'] ?? 0).toDouble();
    
    final totalFuelBill = cngTotal + lpgTotal + octaneTotal + startingFuel;

    // Allowances
    final otMins = (billData['actual_overtime_mins'] ?? 0).toInt();
    final otHrs = otMins / 60.0;
    final otRate = (billData['overtime_rate'] ?? 0).toDouble();
    final otTotal = otHrs * otRate;

    final nightStays = (billData['actual_night_stays'] ?? 0).toInt();
    final nightRate = (billData['night_stay_rate'] ?? 0).toDouble();
    final nightTotal = nightStays * nightRate;

    final lunchDays = (billData['actual_working_days'] ?? 0).toInt();
    final lunchRate = (billData['lunch_rate'] ?? 0).toDouble();
    final lunchTotal = lunchDays * lunchRate;

    final toll = (billData['actual_toll_parking'] ?? 0).toDouble();

    final totalAllowances = otTotal + nightTotal + lunchTotal + toll;

    // Adjustments
    final rentAmount = (billData['vehicle_rent_amount'] ?? 0).toDouble();
    
    final replaceDays = (billData['actual_replace_days'] ?? 0).toInt();
    final replaceRate = (billData['replace_day_rate'] ?? 0).toDouble();
    final replaceDeduction = replaceDays * replaceRate;

    final absentDays = (billData['actual_absent_days'] ?? 0).toInt();
    final absentRate = (billData['absent_day_rate'] ?? 0).toDouble();
    final absentDeduction = absentDays * absentRate;

    final advanceAmount = (billData['advance_amount'] ?? 0).toDouble();

    final driverTotal = totalFuelBill + totalAllowances - advanceAmount;

    final adjustmentsSubtotal = rentAmount - replaceDeduction - absentDeduction;
    final finalPayable = driverTotal + adjustmentsSubtotal;

    // Colors to match Excel
    final headerBgColor = PdfColor.fromHex('#1a365d'); // Dark blue
    final sectionBgColor = PdfColor.fromHex('#e2e8f0'); // Light gray for rows

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Main Title Header
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: headerBgColor,
                  border: pw.Border.all(color: PdfColors.black, width: 1),
                ),
                child: pw.Center(
                  child: pw.Text(
                    'AUTO CALCULATED DRIVER SLIP - ${monthDisplay.toUpperCase()}',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 16),

              // Driver Info
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _buildCell('Driver Name:', isBold: true),
                      _buildCell(driverName),
                      _buildCell('Vehicle No:', isBold: true),
                      _buildCell(vehicleNo),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildCell('Duty Station:'), // Not duty days, station as in Excel first img
                      _buildCell(dutyStation),
                      _buildCell('Billing Month:', isBold: true),
                      _buildCell(monthDisplay),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // 1. FUEL BILL CALCULATION
              pw.Text('1. FUEL BILL CALCULATION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey500),
                columnWidths: {
                  0: const pw.FlexColumnWidth(1.5),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(1.5),
                  4: const pw.FlexColumnWidth(2),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerBgColor),
                    children: [
                      _buildCell('Period', isHeader: true),
                      _buildCell('Fuel Type', isHeader: true),
                      _buildCell('Run (KM)', isHeader: true, alignRight: true),
                      _buildCell('Rate (BDT)', isHeader: true, alignRight: true),
                      _buildCell('Total Amount (BDT)', isHeader: true, alignRight: true),
                    ],
                  ),
                  // Rows
                  _buildFuelRow('Full Month', 'CNG', cngKm, cngRate, cngTotal, formatter),
                  _buildFuelRow('Full Month', 'LPG', lpgKm, lpgRate, lpgTotal, formatter),
                  _buildFuelRow('Full Month', 'Octane', octaneKm, octaneRate, octaneTotal, formatter),
                  pw.TableRow(
                    children: [
                      _buildCell('Full Month'),
                      _buildCell('Starting Fuel'),
                      _buildCell('-', alignRight: true),
                      _buildCell('-', alignRight: true),
                      _buildCell(formatter.format(startingFuel), alignRight: true),
                    ]
                  ),
                  // Total
                  pw.TableRow(
                    children: [
                      _buildCell(''),
                      _buildCell(''),
                      _buildCell(''),
                      _buildCell('Total Fuel Bill', isBold: true, alignRight: true),
                      _buildCell(formatter.format(totalFuelBill), isBold: true, alignRight: true),
                    ]
                  ),
                ],
              ),
              pw.SizedBox(height: 24),

              // 2. ALLOWANCES & OTHERS
              pw.Text('2. ALLOWANCES & OTHERS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey500),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerBgColor),
                    children: [
                      _buildCell('Particulars', isHeader: true),
                      _buildCell('Unit/Days/Hrs', isHeader: true, alignRight: true),
                      _buildCell('Rate (BDT)', isHeader: true, alignRight: true),
                      _buildCell('Total Amount (BDT)', isHeader: true, alignRight: true),
                    ],
                  ),
                  _buildAllowanceRow('Overtime (OT)', otHrs, otRate, otTotal, formatter),
                  _buildAllowanceRow('Night Stay', nightStays.toDouble(), nightRate, nightTotal, formatter),
                  _buildAllowanceRow('Day Meal Allowance', lunchDays.toDouble(), lunchRate, lunchTotal, formatter),
                  pw.TableRow(
                    children: [
                      _buildCell('Toll & Parking'),
                      _buildCell('-', alignRight: true),
                      _buildCell('-', alignRight: true),
                      _buildCell(formatter.format(toll), alignRight: true),
                    ]
                  ),
                  pw.TableRow(
                    children: [
                      _buildCell(''),
                      _buildCell(''),
                      _buildCell('Total Allowances', isBold: true, alignRight: true),
                      _buildCell(formatter.format(totalAllowances), isBold: true, alignRight: true),
                    ]
                  ),
                  if (advanceAmount > 0)
                    pw.TableRow(
                      children: [
                        _buildCell('Advance Amount (-)', isDeduction: true, isBold: true),
                        _buildCell('-', alignRight: true),
                        _buildCell('-', alignRight: true),
                        _buildCell(formatter.format(advanceAmount), alignRight: true, textColor: PdfColors.red, isBold: true),
                      ]
                    ),
                ],
              ),
              pw.SizedBox(height: 12),
              
              // DRIVER TOTAL
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1.5), // Thick border for emphasis
                columnWidths: {
                  0: const pw.FlexColumnWidth(6),
                  1: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    children: [
                      _buildCell('DRIVER TOTAL (Fuel + Allowances)', isBold: true, alignRight: true),
                      _buildCell(formatter.format(driverTotal), isBold: true, alignRight: true),
                    ]
                  )
                ]
              ),

              pw.SizedBox(height: 24),

              // 3. RENT & ABSENT ADJUSTMENTS
              pw.Text('3. RENT & ABSENT ADJUSTMENTS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              pw.SizedBox(height: 4),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey500),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1.5),
                  2: const pw.FlexColumnWidth(1.5),
                  3: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: headerBgColor),
                    children: [
                      _buildCell('Particulars', isHeader: true),
                      _buildCell('Days/Unit', isHeader: true, alignRight: true),
                      _buildCell('Rate (BDT)', isHeader: true, alignRight: true),
                      _buildCell('Total Amount (BDT)', isHeader: true, alignRight: true),
                    ],
                  ),
                  pw.TableRow(
                    children: [
                      _buildCell('Rent Bill (+)'),
                      _buildCell('-', alignRight: true),
                      _buildCell('-', alignRight: true),
                      _buildCell(formatter.format(rentAmount), alignRight: true),
                    ]
                  ),
                  _buildAllowanceRow('Replace Deduction (-)', replaceDays.toDouble(), replaceRate, replaceDeduction, formatter, isDeduction: true),
                  _buildAllowanceRow('Absent Deduction (-)', absentDays.toDouble(), absentRate, absentDeduction, formatter, isDeduction: true),
                  pw.TableRow(
                    children: [
                      _buildCell(''),
                      _buildCell(''),
                      _buildCell('Adjustments Subtotal', isBold: true, alignRight: true, italic: true),
                      _buildCell(formatter.format(adjustmentsSubtotal), isBold: true, alignRight: true),
                    ]
                  ),
                ],
              ),
              
              pw.SizedBox(height: 12),

              // FINAL PAYABLE
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1.5),
                columnWidths: {
                  0: const pw.FlexColumnWidth(6),
                  1: const pw.FlexColumnWidth(2),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.green), // Green background like excel
                    children: [
                      _buildCell('FINAL PAYABLE AMOUNT (BDT)', isBold: true, alignRight: true, textColor: PdfColors.white),
                      _buildCell(formatter.format(finalPayable), isBold: true, alignRight: true, textColor: PdfColors.black, bgColor: PdfColors.white),
                    ]
                  )
                ]
              ),
              
            ],
          );
        },
      ),
    );

    // Share / Print PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Driver_Slip_${driverName.replaceAll(' ', '_')}_$monthDisplay.pdf',
    );
  }

  static pw.Widget _buildCell(String text, {
    bool isHeader = false, 
    bool isBold = false, 
    bool alignRight = false,
    bool italic = false,
    bool isDeduction = false,
    PdfColor? textColor,
    PdfColor? bgColor,
  }) {
    final style = pw.TextStyle(
      color: textColor ?? (isHeader ? PdfColors.white : (isDeduction ? PdfColors.red : PdfColors.black)),
      fontWeight: (isHeader || isBold) ? pw.FontWeight.bold : pw.FontWeight.normal,
      fontStyle: italic ? pw.FontStyle.italic : pw.FontStyle.normal,
      fontSize: 10,
    );

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: bgColor,
      child: pw.Text(
        text,
        style: style,
        textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.left,
      ),
    );
  }

  static pw.TableRow _buildFuelRow(String period, String type, double km, double rate, double total, NumberFormat fmt) {
    return pw.TableRow(
      children: [
        _buildCell(period),
        _buildCell(type),
        _buildCell(fmt.format(km), alignRight: true),
        _buildCell(fmt.format(rate), alignRight: true),
        _buildCell(fmt.format(total), alignRight: true),
      ]
    );
  }

  static pw.TableRow _buildAllowanceRow(String part, double unit, double rate, double total, NumberFormat fmt, {bool isDeduction = false}) {
    return pw.TableRow(
      children: [
        _buildCell(part, isDeduction: isDeduction),
        _buildCell(fmt.format(unit), alignRight: true),
        _buildCell(fmt.format(rate), alignRight: true),
        _buildCell(fmt.format(total), alignRight: true),
      ]
    );
  }
}
