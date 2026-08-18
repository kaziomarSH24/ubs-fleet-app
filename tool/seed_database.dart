import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';

void main() async {
  print('Generating SQL script...');
  
  final drivers = [
    {'name': 'Sumon', 'code': '1135', 'vehicle': '42-4670', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Saddam', 'code': '1136', 'vehicle': '43-2207', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Rahmatullah', 'code': '1137', 'vehicle': '26-3543', 'fuel': 'LPG', 'rent': 38000},
    {'name': 'Saiful', 'code': '1138', 'vehicle': '43-1649', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Akash', 'code': '1139', 'vehicle': '43-9029', 'fuel': 'LPG', 'rent': 38000},
    {'name': 'Monjur Islam', 'code': '1141', 'vehicle': '32-6463', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Shahid', 'code': '1142', 'vehicle': '43-7019', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Hasim', 'code': '1143', 'vehicle': '32-4614', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Rabbi', 'code': '1144', 'vehicle': '28-2367', 'fuel': 'CNG', 'rent': 38000},
    {'name': 'Abdul Azizul', 'code': '1149', 'vehicle': '37-7218', 'fuel': 'LPG', 'rent': 38000},
    {'name': 'Shahidul', 'code': '1173', 'vehicle': '34-6708', 'fuel': 'Octane', 'rent': 38000},
    {'name': 'Monzur', 'code': '1176', 'vehicle': '45-4482', 'fuel': 'LPG', 'rent': 38000},
    {'name': 'Shahin', 'code': '1177', 'vehicle': '26-2774', 'fuel': 'Octane', 'rent': 38000},
    {'name': 'Mahadi', 'code': '1193', 'vehicle': '24-3197', 'fuel': 'Octane', 'rent': 38000},
    {'name': 'Hafizur Rahman', 'code': '1194', 'vehicle': '36-4484', 'fuel': 'Octane', 'rent': 38000},
    {'name': 'Ashraful Alom', 'code': '1205', 'vehicle': '28-5947', 'fuel': 'Octane', 'rent': 38000},
  ];

  final random = Random();
  final sqlBuffer = StringBuffer();
  
  sqlBuffer.writeln('DO \$\$');
  sqlBuffer.writeln('DECLARE');
  sqlBuffer.writeln('  uid uuid;');
  sqlBuffer.writeln('  vid uuid;');
  sqlBuffer.writeln('  client_id uuid;');
  sqlBuffer.writeln('BEGIN');
  
  sqlBuffer.writeln('  -- Get a default client ID if exists');
  sqlBuffer.writeln('  SELECT id INTO client_id FROM public.profiles WHERE role = \'client\' LIMIT 1;');
  
  for (var d in drivers) {
    final email = 'driver${d['code']}@ubs.com';
    
    sqlBuffer.writeln('\n  -- Driver: ${d['name']}');
    sqlBuffer.writeln('  uid := gen_random_uuid();');
    sqlBuffer.writeln('  vid := gen_random_uuid();');
    
    // Insert into auth.users (minimal required fields)
    sqlBuffer.writeln('  INSERT INTO auth.users (id, instance_id, aud, role, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, confirmation_token, recovery_token, email_change_token_new, email_change) ');
    sqlBuffer.writeln('  VALUES (uid, \'00000000-0000-0000-0000-000000000000\', \'authenticated\', \'authenticated\', \'$email\', crypt(\'123456\', gen_salt(\'bf\')), now(), \'{"provider":"email","providers":["email"]}\', \'{}\', now(), now(), \'\', \'\', \'\', \'\');');
    
    // Insert into profiles
    sqlBuffer.writeln('  INSERT INTO public.profiles (id, full_name, employee_id, role, cng_rate_per_km, lpg_rate_per_km, octane_rate_per_km, lunch_rate_per_day, night_stay_rate, overtime_rate_per_hour, starting_fuel_rate, replace_day_rate, absent_day_rate, client_id)');
    sqlBuffer.writeln('  VALUES (uid, \'${d['name']}\', \'${d['code']}\', \'driver\', 10, 12, 15, 150, 300, 100, 100, 500, 0, client_id);');

    // Insert into vehicles
    sqlBuffer.writeln('  INSERT INTO public.vehicles (id, current_driver_id, plate_number, model, fuel_type, rent_amount)');
    sqlBuffer.writeln('  VALUES (vid, uid, \'${d['vehicle']}\', \'Sedan 2012\', \'${d['fuel']}\', ${d['rent']});');

    // Insert daily logs (last 60 days)
    final now = DateTime.now();
    for (int i = 0; i < 60; i++) {
      final date = now.subtract(Duration(days: i));
      if (date.weekday == DateTime.friday && random.nextBool()) continue;

      int totalKm = 80 + random.nextInt(40);
      int cngKm = 0, lpgKm = 0, octaneKm = 0;
      
      if (d['fuel'].toString().toLowerCase() == 'lpg') {
        lpgKm = totalKm;
      } else if (d['fuel'].toString().toLowerCase() == 'octane') {
        octaneKm = totalKm;
      } else {
        cngKm = totalKm;
      }
      
      if (random.nextInt(10) > 7 && d['fuel'].toString().toLowerCase() != 'octane') {
         octaneKm = 2 + random.nextInt(5);
      }
      
      final startStr = DateTime(date.year, date.month, date.day, 8, 0).toIso8601String();
      final endStr = DateTime(date.year, date.month, date.day, 18, 0).toIso8601String();
      final nightStay = random.nextInt(10) > 8 ? 'true' : 'false';

      sqlBuffer.writeln('  INSERT INTO public.daily_logs (driver_id, vehicle_id, start_time, end_time, start_km, end_km, cng_km, lpg_km, octane_km, status, night_stay)');
      sqlBuffer.writeln('  VALUES (uid, vid, \'$startStr\', \'$endStr\', 1000, 1000 + $totalKm, $cngKm, $lpgKm, $octaneKm, \'completed\', $nightStay);');
    }
    
    // Insert Payments (Advances)
    for (int m = 0; m < 3; m++) {
      final advanceMonth = DateTime(now.year, now.month - m, 15);
      final advanceDateStr = DateFormat('yyyy-MM-dd').format(advanceMonth);
      sqlBuffer.writeln('  INSERT INTO public.driver_payments (driver_id, payment_date, amount, note)');
      sqlBuffer.writeln('  VALUES (uid, \'$advanceDateStr\', ${(random.nextInt(3) + 1) * 1000}, \'Advance\');');
    }

    // Insert monthly bills (last 2 months)
    for (int m = 1; m <= 2; m++) {
      final billMonth = DateTime(now.year, now.month - m, 1);
      final monthYearStr = DateFormat('yyyy-MM').format(billMonth);
      int claimedTotalKm = random.nextInt(500) + 2000;
      int cLpg = d['fuel'].toString().toLowerCase() == 'lpg' ? claimedTotalKm : 0;
      int cCng = d['fuel'].toString().toLowerCase() == 'cng' ? claimedTotalKm : 0;
      int cOct = d['fuel'].toString().toLowerCase() == 'octane' ? claimedTotalKm : 100;
      
      sqlBuffer.writeln('  INSERT INTO public.monthly_bills (driver_id, month_year, claimed_total_km, claimed_cng_km, claimed_lpg_km, claimed_octane_km, claimed_overtime_hours, claimed_night_stays, claimed_working_days, claimed_toll_parking, actual_working_days, advance_amount, vehicle_rent_amount)');
      sqlBuffer.writeln('  VALUES (uid, \'$monthYearStr\', $claimedTotalKm, $cCng, $cLpg, $cOct, 10, 2, 26, 300, 26, 2000, ${d['rent']});');
    }
  }

  sqlBuffer.writeln('END \$\$;');
  
  final outFile = File('seed_data.sql');
  await outFile.writeAsString(sqlBuffer.toString());
  print('Successfully generated seed_data.sql!');
  print('Please open seed_data.sql, copy everything, and paste it into the Supabase Dashboard -> SQL Editor and hit Run.');
}
