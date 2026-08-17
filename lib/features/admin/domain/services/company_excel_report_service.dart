import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class CompanyExcelReportService {
  static Future<void> generateAndExport({
    required String companyName,
    required String monthYear, // Format "2026-08"
    required List<Map<String, dynamic>> billingDataList,
  }) async {
    final List<String> headers = [
      'Sl', 'Code', 'Driver Name', 'V-no', 'F-Type', 'Rent (Tk.)', 'Duty Day',
      'Log CNG (Km)', 'Final CNG', 'Replace CNG', 'Log LPG', 'Final LPG',
      'Log Octane', 'Final Octane', 'Replace Oct', 'Log OT (Mins)', 'Final OT (Mins)',
      'Night Stay', 'Toll/Parking', 'Replace Days', 'Absent Days', 'Advance (Tk.)'
    ];
    final List<List<dynamic>> rows = [];
    rows.add(headers);

    // Iterate drivers
    int sl = 1;
    for (var rowData in billingDataList) {
      final driver = rowData['driver'] as Map<String, dynamic>? ?? {};
      final vehicle = rowData['vehicle'] as Map<String, dynamic>? ?? {};
      final bill = rowData['bill'] as Map<String, dynamic>? ?? {};

      final name = driver['full_name'] ?? '';
      final code = driver['employee_code'] ?? '';
      final plate = vehicle['plate_number'] ?? '';
      final fuelType = vehicle['fuel_type'] ?? '';
      
      final rentAmt = bill['vehicle_rent_amount'] ?? vehicle['rent_amount'] ?? 0;
      final dutyDays = bill['actual_working_days'] ?? 0;
      
      final logCng = bill['claimed_cng_km'] ?? 0;
      final finalCng = bill['actual_cng_km'] ?? 0;
      final replaceCng = 0; // Not explicitly tracked yet, use 0
      
      final logLpg = bill['claimed_lpg_km'] ?? 0;
      final finalLpg = bill['actual_lpg_km'] ?? 0;
      
      final logOctane = bill['claimed_octane_km'] ?? 0;
      final finalOctane = bill['actual_octane_km'] ?? 0;
      final replaceOctane = 0; // Not tracked, use 0
      
      // Note: we track overtime in mins, but Excel might want hours. 
      // The image showed 'Driver Claim OT' like 1020 (which is mins). We'll output mins.
      final logOT = bill['claimed_overtime_mins'] ?? 0;
      final finalOT = bill['actual_overtime_mins'] ?? 0;
      
      final nightStay = bill['actual_night_stays'] ?? 0;
      final toll = bill['actual_toll_parking'] ?? 0;
      final replaceDays = bill['actual_replace_days'] ?? 0;
      final absentDays = bill['actual_absent_days'] ?? 0;
      final advance = bill['advance_amount'] ?? 0;

      final dataRow = [
        sl,
        code.toString(),
        name,
        plate,
        fuelType,
        rentAmt.toInt(),
        dutyDays,
        logCng.toInt(),
        finalCng.toInt(),
        replaceCng,
        logLpg.toInt(),
        finalLpg.toInt(),
        logOctane.toInt(),
        finalOctane.toInt(),
        replaceOctane,
        logOT,
        finalOT,
        nightStay,
        toll.toInt(),
        replaceDays,
        absentDays,
        advance.toInt()
      ];
      
      rows.add(dataRow);
      sl++;
    }

    final String csvStr = Csv(lineDelimiter: '\n').encode(rows);
    final dir = await getApplicationDocumentsDirectory();
    final dateStr = DateFormat('MMMM_yyyy').format(DateTime.parse('$monthYear-01'));
    final filePath = '${dir.path}/${companyName.replaceAll(' ', '_')}_Report_$dateStr.csv';
    
    final file = File(filePath);
    await file.writeAsString(csvStr);

    await Share.shareXFiles([XFile(filePath)], text: 'Monthly Billing Report for $companyName');
  }
}
