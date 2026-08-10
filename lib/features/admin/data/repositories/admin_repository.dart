import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all company drivers
  Future<List<Map<String, dynamic>>> getAllDrivers() async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('role', 'driver')
        .order('full_name', ascending: true);
    return response;
  }

  /// Fetch all vehicles
  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    final response = await _supabase
        .from('vehicles')
        .select('*, profiles:current_driver_id(full_name)')
        .order('plate_number', ascending: true);
    return response;
  }

  /// Fetch recent logs (default 50)
  Future<List<Map<String, dynamic>>> getRecentLogs({int limit = 50}) async {
    final response = await _supabase
        .from('daily_logs')
        .select('*, profiles:driver_id(full_name), vehicles:vehicle_id(plate_number)')
        .order('start_time', ascending: false)
        .limit(limit);
    return response;
  }

  /// Fetch pending expenses
  Future<List<Map<String, dynamic>>> getPendingExpenses() async {
    // Assuming there's a 'status' field in expenses, if not we will fetch all for now
    // Wait, the expenses table doesn't have a status field yet!
    // We'll just fetch recent expenses.
    final response = await _supabase
        .from('expenses')
        .select('*, profiles:driver_id(full_name)')
        .order('created_at', ascending: false)
        .limit(50);
    return response;
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final vehiclesCount = await _supabase.from('vehicles').count();
      final activeDriversCount = await _supabase
          .from('daily_logs')
          .select('driver_id')
          .eq('status', 'ongoing');
      
      // Distinct active drivers today
      final activeCount = activeDriversCount.map((e) => e['driver_id']).toSet().length;

      return {
        'total_cars': vehiclesCount,
        'active_drivers': activeCount,
        // Mock data for Workshop until we have a maintenance table or status column in vehicles
        'in_workshop': 0, 
      };
    } catch (e) {
      print("Error fetching stats: $e");
      return {
        'total_cars': 0,
        'active_drivers': 0,
        'in_workshop': 0,
      };
    }
  }
}
