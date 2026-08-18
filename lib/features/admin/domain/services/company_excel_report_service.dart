import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;

class CompanyExcelReportService {
  static Future<void> generateAndExport({
    required String companyName,
    required String monthYear, // Format "2026-08"
    required List<Map<String, dynamic>> billingDataList,
  }) async {
    final String clientShort = companyName.isNotEmpty ? companyName : 'Client';
    
    // Create a new Excel Document.
    final xlsio.Workbook workbook = xlsio.Workbook();
    // Accessing worksheet via index.
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.name = 'Master Report';

    final List<String> headers = [
      'Sl', 'Code', 'Driver Name', 'Vehicle No', 'Fuel Type', 'Rent Amount', 'Duty Days',
      'Driver Log CNG', '$clientShort Final CNG', 'Replace CNG KM', 
      'Driver Log LPG', '$clientShort Final LPG',
      'Driver Log Octane', '$clientShort Final Octane', 'Replace Octen KM', 
      'Driver Claim OT', '$clientShort Final OT',
      'Night Stay Days', 'Toll & Parking', 'Replace Days', 'Absent Days', 'Advance Amount'
    ];

    // Build header row
    for (int col = 0; col < headers.length; col++) {
      final cell = sheet.getRangeByIndex(1, col + 1);
      cell.setText(headers[col]);
      cell.cellStyle.backColor = '#1e334a'; // Dark blue
      cell.cellStyle.fontColor = '#ffffff'; // White text
      cell.cellStyle.bold = true;
      cell.cellStyle.hAlign = xlsio.HAlignType.center;
      cell.cellStyle.vAlign = xlsio.VAlignType.center;
      cell.cellStyle.wrapText = true;
      sheet.autoFitColumn(col + 1);
    }
    
    // Make header row taller
    sheet.setRowHeightInPixels(1, 40);

    // Write Data
    int rowIdx = 2;
    int sl = 1;
    
    // Columns to highlight yellow (1-based index)
    // Duty Days (7), Driver Log CNG (8), Driver Log LPG (11), Driver Log Octane (13), Driver Claim OT (16), Night Stay Days (18)
    final yellowColumns = [7, 8, 11, 13, 16, 18];

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
      final replaceCng = 0; 
      
      final logLpg = bill['claimed_lpg_km'] ?? 0;
      final finalLpg = bill['actual_lpg_km'] ?? 0;
      
      final logOctane = bill['claimed_octane_km'] ?? 0;
      final finalOctane = bill['actual_octane_km'] ?? 0;
      final replaceOctane = 0;
      
      final logOT = bill['claimed_overtime_mins'] ?? 0;
      final finalOT = bill['actual_overtime_mins'] ?? 0;
      
      final nightStay = bill['actual_night_stays'] ?? 0;
      final toll = bill['actual_toll_parking'] ?? 0;
      final replaceDays = bill['actual_replace_days'] ?? 0;
      final absentDays = bill['actual_absent_days'] ?? 0;
      final advance = bill['advance_amount'] ?? 0;

      final dataRow = [
        sl, code.toString(), name, plate, fuelType, rentAmt.toInt(), dutyDays,
        logCng.toInt(), finalCng.toInt(), replaceCng,
        logLpg.toInt(), finalLpg.toInt(),
        logOctane.toInt(), finalOctane.toInt(), replaceOctane,
        logOT, finalOT,
        nightStay, toll.toInt(), replaceDays, absentDays, advance.toInt()
      ];

      for (int col = 0; col < dataRow.length; col++) {
        final cell = sheet.getRangeByIndex(rowIdx, col + 1);
        final val = dataRow[col];
        if (val is int) {
          cell.setNumber(val.toDouble());
        } else {
          cell.setText(val.toString());
        }
        
        // Add borders to data cells
        cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
        cell.cellStyle.borders.all.color = '#000000';
        cell.cellStyle.hAlign = xlsio.HAlignType.center;

        // Apply yellow background if required
        if (yellowColumns.contains(col + 1)) {
          cell.cellStyle.backColor = '#ffff00'; // Yellow
        }
      }
      
      rowIdx++;
      sl++;
    }

    // Add "RATE SETTINGS" block at column X (24)
    final rateSettingsStartCol = 24;
    
    final rateTitleCell = sheet.getRangeByIndex(1, rateSettingsStartCol);
    sheet.getRangeByIndex(1, rateSettingsStartCol, 1, rateSettingsStartCol + 1).merge();
    rateTitleCell.setText('RATE SETTINGS');
    rateTitleCell.cellStyle.backColor = '#1fa889'; // Teal/Cyan
    rateTitleCell.cellStyle.fontColor = '#ffffff';
    rateTitleCell.cellStyle.bold = true;
    rateTitleCell.cellStyle.hAlign = xlsio.HAlignType.center;
    rateTitleCell.cellStyle.vAlign = xlsio.VAlignType.center;

    final dateStr = DateFormat('MMMM yyyy').format(DateTime.parse('$monthYear-01'));
    
    // Add dummy rate settings similar to the image
    final rates = [
      ['CNG Rate/KM', 8.50],
      ['LPG Rate/KM', 12.50],
      ['Octane Rate/KM', 14.00],
      ['OT Rate/Hr', 40.00],
      ['Lunch Rate/Day', 70.00],
      ['Default Night Stay', 750.00],
      ['Hafizur Night Stay', 800.00],
      ['Starting Fuel', 1250.00],
      ['Replace Day Rate', 2100.00],
      ['Absent Day Rate', 4100.00],
      ['Billing Month', dateStr],
    ];

    for (int i = 0; i < rates.length; i++) {
      int curRow = i + 2;
      
      final labelCell = sheet.getRangeByIndex(curRow, rateSettingsStartCol);
      labelCell.setText(rates[i][0].toString());
      labelCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      labelCell.cellStyle.borders.all.color = '#000000';
      labelCell.cellStyle.bold = true;
      
      final valCell = sheet.getRangeByIndex(curRow, rateSettingsStartCol + 1);
      final val = rates[i][1];
      if (val is num) {
        valCell.setNumber(val.toDouble());
        valCell.cellStyle.numberFormat = '0.00';
      } else {
        valCell.setText(val.toString());
      }
      valCell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      valCell.cellStyle.borders.all.color = '#000000';
      valCell.cellStyle.hAlign = xlsio.HAlignType.center;
    }
    
    sheet.autoFitColumn(rateSettingsStartCol);
    sheet.autoFitColumn(rateSettingsStartCol + 1);

    // Save and dispose
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final dateStrFile = DateFormat('MMMM_yyyy').format(DateTime.parse('$monthYear-01'));
    final defaultFileName = '${companyName.replaceAll(' ', '_')}_Report_$dateStrFile.xlsx';
    
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Save Billing Report',
        fileName: defaultFileName,
        type: FileType.custom,
        allowedExtensions: ['xlsx'],
      );
      
      if (outputFile != null) {
        final file = File(outputFile);
        await file.writeAsBytes(bytes);
      }
    } else {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$defaultFileName';
      
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      await Share.shareXFiles([XFile(filePath)], text: 'Monthly Billing Report for $companyName');
    }
  }
}
