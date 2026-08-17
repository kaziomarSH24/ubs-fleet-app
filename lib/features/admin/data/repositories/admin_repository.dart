import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch all company drivers
  Future<List<Map<String, dynamic>>> getAllDrivers({String? clientId}) async {
    var query = _supabase
        .from('profiles')
        .select('*, clients(*), vehicles(*)')
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

  /// Delete a vehicle document
  Future<void> deleteVehicleDocument(String docId) async {
    try {
      // Note: Ideally, we should also delete the file from storage, but for now we just delete the db record.
      // Or we can fetch the url, parse path, and delete from storage.
      await _supabase.from('vehicle_documents').delete().eq('id', docId);
    } catch (e) {
      throw Exception('Failed to delete document: $e');
    }
  }

  /// Delete a vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _supabase.from('vehicles').delete().eq('id', vehicleId);
    } catch (e) {
      throw Exception('Failed to delete vehicle: $e');
    }
  }

  /// Fetch vehicle models
  Future<List<String>> getVehicleModels() async {
    try {
      final response = await _supabase
          .from('vehicle_models')
          .select('name')
          .order('name', ascending: true);
      return (response as List).map((e) => e['name'] as String).toList();
    } catch (e) {
      throw Exception('Failed to fetch vehicle models: $e');
    }
  }

  /// Add a new vehicle model
  Future<void> addVehicleModel(String name) async {
    try {
      await _supabase.from('vehicle_models').insert({'name': name});
    } catch (e) {
      throw Exception('Failed to add vehicle model: $e');
    }
  }

  // ==========================================
  // DRIVER MANAGEMENT
  // ==========================================

  /// Create a new driver using the RPC
  Future<void> createDriver({
    required String password,
    required String phone,
    required String fullName,
    String? clientId,
  }) async {
    try {
      await _supabase.rpc('admin_create_driver', params: {
        'driver_password': password,
        'driver_phone': phone,
        'driver_full_name': fullName,
        'assign_client_id': clientId,
      });
    } catch (e) {
      throw Exception('Failed to create driver: $e');
    }
  }

  /// Toggle driver status (active/inactive)
  Future<void> toggleDriverStatus(String driverId, bool isActive) async {
    try {
      await _supabase
          .from('profiles')
          .update({'is_active': isActive})
          .eq('id', driverId);
    } catch (e) {
      throw Exception('Failed to update driver status: $e');
    }
  }

  /// Fetch documents for a specific driver
  Future<List<Map<String, dynamic>>> getDriverDocuments(String driverId) async {
    try {
      final response = await _supabase
          .from('driver_documents')
          .select()
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch driver documents: $e');
    }
  }

  /// Upload a driver document
  Future<void> uploadDriverDocument({
    required String driverId,
    required String docType,
    required File file,
    required String fileName,
    required DateTime? expiryDate,
  }) async {
    try {
      final storagePath = 'drivers/$driverId/$docType-${DateTime.now().millisecondsSinceEpoch}-$fileName';
      
      // Ensure the 'driver_documents' storage bucket exists in Supabase, 
      // or we can use a generic 'documents' bucket. Assuming 'driver_documents' for now.
      await _supabase.storage.from('driver_documents').upload(storagePath, file);
      
      await _supabase.from('driver_documents').insert({
        'driver_id': driverId,
        'doc_type': docType,
        'file_url': storagePath,
        'expiry_date': expiryDate?.toIso8601String(),
        'status': 'approved' // Uploaded by admin, so auto-approved
      });
    } catch (e) {
      throw Exception('Failed to upload driver document: $e');
    }
  }

  /// Delete a driver document
  Future<void> deleteDriverDocument(String docId) async {
    try {
      await _supabase.from('driver_documents').delete().eq('id', docId);
    } catch (e) {
      throw Exception('Failed to delete driver document: $e');
    }
  }

  /// Approve or Reject a driver document
  Future<void> updateDriverDocumentStatus(String docId, String status) async {
    try {
      await _supabase
          .from('driver_documents')
          .update({'status': status})
          .eq('id', docId);
    } catch (e) {
      throw Exception('Failed to update document status: $e');
    }
  }
}
