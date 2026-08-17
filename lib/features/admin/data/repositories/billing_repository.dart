import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final billingRepositoryProvider = Provider<BillingRepository>((ref) {
  return BillingRepository();
});

class BillingRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Update a driver's billing rates in the profiles table
  Future<void> updateDriverRates(String driverId, Map<String, dynamic> rates) async {
    try {
      await _supabase
          .from('profiles')
          .update(rates)
          .eq('id', driverId);
    } catch (e) {
      throw Exception('Failed to update driver rates: $e');
    }
  }

  /// Get driver rates
  Future<Map<String, dynamic>> getDriverRates(String driverId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('octane_rate_per_km, cng_rate_per_km, lpg_rate_per_km, overtime_rate_per_hour, night_stay_rate, lunch_rate_per_day, starting_fuel_rate, replace_day_rate, absent_day_rate')
          .eq('id', driverId)
          .single();
      return response;
    } catch (e) {
      throw Exception('Failed to get driver rates: $e');
    }
  }

  /// Check if a bill already exists for the given month
  Future<Map<String, dynamic>?> getMonthlyBill(String driverId, String monthYear) async {
    try {
      final response = await _supabase
          .from('monthly_bills')
          .select()
          .eq('driver_id', driverId)
          .eq('month_year', monthYear)
          .maybeSingle();
      return response;
    } catch (e) {
      throw Exception('Failed to get monthly bill: $e');
    }
  }

  /// Save or update a monthly bill
  Future<void> saveMonthlyBill(Map<String, dynamic> billData) async {
    try {
      await _supabase
          .from('monthly_bills')
          .upsert(billData, onConflict: 'driver_id, month_year');
    } catch (e) {
      throw Exception('Failed to save monthly bill: $e');
    }
  }

  /// Get all bills for a specific client and month
  Future<List<Map<String, dynamic>>> getMonthlyBillsForClient(String clientId, String monthYear) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select('*, vehicles(*), monthly_bills(*)')
          .eq('role', 'driver')
          .eq('client_id', clientId)
          .eq('monthly_bills.month_year', monthYear);
          
      List<Map<String, dynamic>> results = [];
      for (var profile in response) {
        final bills = profile['monthly_bills'] as List<dynamic>? ?? [];
        if (bills.isNotEmpty) {
          final bill = bills.first; // Since we filtered by monthYear, there should be exactly one
          final vehicleList = profile['vehicles'] as List<dynamic>? ?? [];
          final vehicle = vehicleList.isNotEmpty ? vehicleList.first : {};
          
          results.add({
            'driver': profile,
            'vehicle': vehicle,
            'bill': bill,
          });
        }
      }
      return results;
    } catch (e) {
      throw Exception('Failed to get monthly bills for client: $e');
    }
  }
}
