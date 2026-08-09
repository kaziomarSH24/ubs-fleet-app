import 'dart:io';
import 'package:supabase/supabase.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  final supabase = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
  );

  try {
    await supabase.from('daily_logs').insert({
      'driver_id': 'c88a8f15-77ef-4682-bb30-4be68b555776', // Need a valid UUID
      'vehicle_id': 'dummy-vehicle-id',
      'start_time': DateTime.now().toIso8601String(),
      'start_km': 1000,
      'status': 'ongoing',
    });
    print("Success");
  } catch (e) {
    print("Error: $e");
  }
}
