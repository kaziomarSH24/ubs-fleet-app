import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  final supabase = SupabaseClient(
    dotenv.env['SUPABASE_URL']!,
    dotenv.env['SUPABASE_ANON_KEY']!,
  );

  try {
    final response = await supabase
        .from('profiles')
        .select('octane_rate_per_km, cng_rate_per_km, lpg_rate_per_km, overtime_rate_per_hour, night_stay_rate, lunch_rate_per_day, starting_fuel_rate, replace_day_rate, absent_day_rate')
        .limit(1);
    print("Success: $response");
  } catch (e) {
    print("Error: $e");
  }
}
