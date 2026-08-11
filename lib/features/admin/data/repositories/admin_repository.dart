import 'dart:io';
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

  /// Add a new vehicle
  Future<void> addVehicle({
    required String model,
    required String plateNumber,
    required String fuelType,
  }) async {
    try {
      await _supabase.from('vehicles').insert({
        'model': model,
        'plate_number': plateNumber,
        'fuel_type': fuelType,
        'status': 'active', // default status
      });
    } catch (e) {
      throw Exception('Failed to add vehicle: $e');
    }
  }

  /// Update vehicle status
  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    try {
      await _supabase
          .from('vehicles')
          .update({'status': status})
          .eq('id', vehicleId);
    } catch (e) {
      throw Exception('Failed to update vehicle status: $e');
    }
  }

  /// Assign driver to vehicle
  Future<void> assignDriverToVehicle(String vehicleId, String? driverId) async {
    try {
      if (driverId != null) {
        // Unassign this driver from any other vehicle they might be assigned to
        await _supabase
            .from('vehicles')
            .update({'current_driver_id': null})
            .eq('current_driver_id', driverId);
      }

      // Assign the driver to the new vehicle
      await _supabase
          .from('vehicles')
          .update({'current_driver_id': driverId})
          .eq('id', vehicleId);
    } catch (e) {
      throw Exception('Failed to assign driver: $e');
    }
  }

  /// Fetch documents for a specific vehicle
  Future<List<Map<String, dynamic>>> getVehicleDocuments(String vehicleId) async {
    try {
      final response = await _supabase
          .from('vehicle_documents')
          .select()
          .eq('vehicle_id', vehicleId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch vehicle documents: $e');
    }
  }

  /// Upload a vehicle document
  Future<void> uploadVehicleDocument({
    required String vehicleId,
    required String docType,
    required File file,
    required String fileName,
    required DateTime? expiryDate,
  }) async {
    try {
      final storagePath = '$vehicleId/$docType-${DateTime.now().millisecondsSinceEpoch}-$fileName';
      
      await _supabase.storage.from('vehicle_documents').upload(storagePath, file);
      final fileUrl = _supabase.storage.from('vehicle_documents').getPublicUrl(storagePath);
      
      await _supabase.from('vehicle_documents').insert({
        'vehicle_id': vehicleId,
        'doc_type': docType,
        'file_url': fileUrl,
        'expiry_date': expiryDate?.toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to upload document: $e');
    }
  }
}
