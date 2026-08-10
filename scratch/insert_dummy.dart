import 'package:supabase/supabase.dart';

void main() async {
  final supabase = SupabaseClient(
    'https://bdobkjfrkpyqztnxhapd.supabase.co',
    'sb_publishable_DVPArQwHzjj32hmyfXv3LQ_sZ3LREaT',
  );

  try {
    // Get first driver
    final profiles = await supabase.from('profiles').select().limit(1);
    if (profiles.isEmpty) {
      print("No profiles found");
      return;
    }
    final driverId = profiles.first['id'];
    
    // Get first vehicle
    final vehicles = await supabase.from('vehicles').select().limit(1);
    if (vehicles.isEmpty) {
      print("No vehicles found");
      return;
    }
    final vehicleId = vehicles.first['id'];

    print("Driver ID: $driverId");
    print("Vehicle ID: $vehicleId");

    // First delete existing logs from August to prevent duplicates
    print("Cleaning up previous dummy data...");
    await supabase
        .from('daily_logs')
        .delete()
        .gte('start_time', '2026-08-01T00:00:00Z')
        .lte('start_time', '2026-08-31T23:59:59Z');

    // Generate dummy logs for August 2026
    List<Map<String, dynamic>> logsToInsert = [];
    
    int currentKm = 15000;
    
    for (int i = 1; i <= 31; i++) {
      // Skip some days randomly
      if (i % 7 == 0 || i == 15) continue;
      
      final startTime = DateTime.utc(2026, 8, i, 8, 30);
      final endTime = DateTime.utc(2026, 8, i, 18, 45);
      
      final startKm = currentKm;
      final dailyDistance = 50 + (i * 3 % 40);
      final endKm = startKm + dailyDistance;
      currentKm = endKm;

      logsToInsert.add({
        'driver_id': driverId,
        'vehicle_id': vehicleId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'start_km': startKm,
        'end_km': endKm,
        'cng_km': dailyDistance - 10,
        'octane_km': 10,
        'status': 'completed',
        'night_stay': i % 5 == 0,
      });
    }

    print("Inserting ${logsToInsert.length} logs...");
    final insertedLogs = await supabase.from('daily_logs').insert(logsToInsert).select();
    
    List<Map<String, dynamic>> expensesToInsert = [];
    int i = 1;
    for (var log in insertedLogs) {
      if (i % 3 == 0) {
        expensesToInsert.add({
          'log_id': log['id'],
          'driver_id': driverId,
          'expense_type': 'Fuel',
          'amount': 500.0,
          'created_at': log['start_time'],
        });
      }
      i++;
    }

    print("Inserting ${expensesToInsert.length} expenses...");
    await supabase.from('expenses').insert(expensesToInsert);
    
    print("Successfully inserted dummy data for August 2026!");
  } catch (e) {
    print("Error: $e");
  }
}
