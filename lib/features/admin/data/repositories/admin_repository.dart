import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all company drivers
  Future<List<Map<String, dynamic>>> getAllDrivers({String? clientId}) async {
    var query = _supabase
        .from('profiles')
        .select()
        .eq('role', 'driver');
    
    if (clientId != null) {
      query = query.eq('client_id', clientId);
    }
    
    final response = await query.order('full_name', ascending: true);
    return response;
  }

  /// Fetch all vehicles
  Future<List<Map<String, dynamic>>> getAllVehicles({String? clientId}) async {
    var query = _supabase
        .from('vehicles')
        .select('*, profiles:current_driver_id(full_name)');
        
    if (clientId != null) {
      query = query.eq('client_id', clientId);
    }
    
    final response = await query.order('plate_number', ascending: true);
    return response;
  }

  // Fetch all clients
  Future<List<Map<String, dynamic>>> getClients() async {
    try {
      final response = await _supabase
          .from('clients')
          .select()
          .order('name', ascending: true);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch clients: $e');
    }
  }

  /// Fetch recent logs (default 50)
  Future<List<Map<String, dynamic>>> getRecentLogs({int limit = 50, String? clientId}) async {
    try {
      var query = _supabase
          .from('daily_logs')
          .select('''
            *,
            profiles!inner(full_name, client_id),
            vehicles(plate_number)
          ''');
          
      if (clientId != null) {
        query = query.eq('profiles.client_id', clientId);
      }
      
      final response = await query.order('start_time', ascending: false).limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch logs: $e');
    }
  }

  /// Fetch pending expenses
  Future<List<Map<String, dynamic>>> getPendingExpenses({String? clientId}) async {
    try {
      var query = _supabase
          .from('expenses')
          .select('''
            *,
            profiles!inner(full_name, client_id)
          ''');
          
      if (clientId != null) {
        query = query.eq('profiles.client_id', clientId);
      }
      
      final response = await query.order('created_at', ascending: false).limit(50);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats({String? clientId}) async {
    try {
      var vehiclesQuery = _supabase.from('vehicles').select('id');
      if (clientId != null) {
        vehiclesQuery = vehiclesQuery.eq('client_id', clientId);
      }
      final vehiclesList = await vehiclesQuery;
      final vehiclesCount = vehiclesList.length;
      
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
