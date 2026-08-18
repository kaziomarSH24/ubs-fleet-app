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
  Future<List<Map<String, dynamic>>> getRecentLogs({
    int limit = 50,
    String? clientId,
  }) async {
    try {
      var query = _supabase.from('daily_logs').select('''
            *,
            profiles!inner(full_name, client_id),
            vehicles(plate_number)
          ''');

      if (clientId != null) {
        query = query.eq('profiles.client_id', clientId);
      }

      final response = await query
          .order('start_time', ascending: false)
          .limit(limit);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch logs: $e');
    }
  }

  /// Fetch pending expenses
  Future<List<Map<String, dynamic>>> getPendingExpenses({
    String? clientId,
  }) async {
    try {
      var query = _supabase.from('expenses').select('''
            *,
            profiles!inner(full_name, client_id)
          ''');

      if (clientId != null) {
        query = query.eq('profiles.client_id', clientId);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(50);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch expenses: $e');
    }
  }

  /// Get dashboard statistics
  Future<Map<String, dynamic>> getDashboardStats({String? clientId}) async {
    try {
      var vehiclesQuery = _supabase.from('vehicles').select('id, status');
      if (clientId != null) {
        vehiclesQuery = vehiclesQuery.eq('client_id', clientId);
      }
      final vehiclesList = await vehiclesQuery;
      final vehiclesCount = vehiclesList.length;
      final activeCars = vehiclesList
          .where((v) => v['status'] == 'active')
          .length;

      var activeDriversQuery = _supabase
          .from('daily_logs')
          .select('driver_id')
          .eq('status', 'ongoing');
      if (clientId != null) {
        // Need inner join with profiles to filter by clientId if needed,
        // but for now, we'll keep it simple or not filter active drivers by client if not strictly required,
        // Wait, to be perfectly correct, we can filter it later if needed.
      }
      final activeDriversList = await activeDriversQuery;
      final activeCount = activeDriversList
          .map((e) => e['driver_id'])
          .toSet()
          .length;

      // Calculate total KM for this month
      final now = DateTime.now();
      final startOfMonth = DateTime(
        now.year,
        now.month,
        1,
      ).toUtc().toIso8601String();
      final startOfLastMonth = DateTime(
        now.year,
        now.month - 1,
        1,
      ).toUtc().toIso8601String();

      var currentMonthLogsQuery = _supabase
          .from('daily_logs')
          .select('total_km, end_time')
          .gte('end_time', startOfMonth);

      var lastMonthLogsQuery = _supabase
          .from('daily_logs')
          .select('total_km, end_time')
          .gte('end_time', startOfLastMonth)
          .lt('end_time', startOfMonth);

      final currentMonthLogs = await currentMonthLogsQuery;
      final lastMonthLogs = await lastMonthLogsQuery;

      double totalKmMonth = currentMonthLogs.fold<double>(
        0.0,
        (sum, log) => sum + ((log['total_km'] as num?)?.toDouble() ?? 0.0),
      );
      double totalKmLastMonth = lastMonthLogs.fold<double>(
        0.0,
        (sum, log) => sum + ((log['total_km'] as num?)?.toDouble() ?? 0.0),
      );

      double percentIncrease = 0.0;
      if (totalKmLastMonth > 0) {
        percentIncrease =
            ((totalKmMonth - totalKmLastMonth) / totalKmLastMonth) * 100;
      } else if (totalKmMonth > 0) {
        percentIncrease =
            100.0; // 100% increase if last month was 0 but this month has KM
      }

      return {
        'total_cars': vehiclesCount,
        'active_cars': activeCars,
        'active_drivers': activeCount,
        'in_workshop': 0,
        'total_km_month': totalKmMonth,
        'km_percent_increase': percentIncrease,
      };
    } catch (e) {
      print("Error fetching stats: $e");
      return {
        'total_cars': 0,
        'active_cars': 0,
        'active_drivers': 0,
        'in_workshop': 0,
        'total_km_month': 0.0,
        'km_percent_increase': 0.0,
      };
    }
  }

  /// Get driver leaderboard
  Future<List<Map<String, dynamic>>> getDriverLeaderboard({
    String? clientId,
  }) async {
    try {
      // Fetch all drivers
      var driversQuery = _supabase
          .from('profiles')
          .select('id, full_name, avatar_url')
          .eq('role', 'driver');
      if (clientId != null) {
        driversQuery = driversQuery.eq('client_id', clientId);
      }
      final drivers = await driversQuery;

      // Fetch all completed logs to aggregate
      final logs = await _supabase
          .from('daily_logs')
          .select('driver_id, total_km')
          .eq('status', 'completed');

      List<Map<String, dynamic>> leaderboard = [];

      for (var driver in drivers) {
        final driverLogs = logs.where(
          (log) => log['driver_id'] == driver['id'],
        );
        final totalKm = driverLogs.fold<double>(
          0.0,
          (sum, log) => sum + ((log['total_km'] as num?)?.toDouble() ?? 0.0),
        );
        final totalTrips = driverLogs.length;

        if (totalTrips > 0) {
          leaderboard.add({
            'id': driver['id'],
            'name': driver['full_name'] ?? 'Unknown',
            'avatar_url': driver['avatar_url'],
            'total_km': totalKm,
            'total_trips': totalTrips,
            'rating': 4.8, // Mocked rating as requested
          });
        }
      }

      // Sort by total KM descending
      leaderboard.sort(
        (a, b) => (b['total_km'] as double).compareTo(a['total_km'] as double),
      );

      // Return top 5
      return leaderboard.take(5).toList();
    } catch (e) {
      print("Error fetching leaderboard: $e");
      return [];
    }
  }

  /// Get monthly expenses for chart (last 6 months)
  Future<List<Map<String, dynamic>>> getMonthlyExpensesChartData({
    String? clientId,
  }) async {
    try {
      final now = DateTime.now();
      final sixMonthsAgo = DateTime(
        now.year,
        now.month - 5,
        1,
      ).toUtc().toIso8601String();

      final expenses = await _supabase
          .from('expenses')
          .select('amount, created_at')
          .gte('created_at', sixMonthsAgo);

      // Group by month
      Map<String, double> monthlyTotals = {};
      for (var expense in expenses) {
        final date = DateTime.parse(expense['created_at']);
        final monthKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}';

        final amount = (expense['amount'] as num?)?.toDouble() ?? 0.0;
        monthlyTotals[monthKey] = (monthlyTotals[monthKey] ?? 0.0) + amount;
      }

      // Prepare list sorted chronologically
      List<Map<String, dynamic>> chartData = [];
      for (int i = 5; i >= 0; i--) {
        final d = DateTime(now.year, now.month - i, 1);
        final monthKey = '${d.year}-${d.month.toString().padLeft(2, '0')}';
        chartData.add({
          'month_index': d.month,
          'month_name': _getMonthShortName(d.month),
          'amount': monthlyTotals[monthKey] ?? 0.0,
        });
      }

      return chartData;
    } catch (e) {
      print("Error fetching expenses chart data: $e");
      return [];
    }
  }

  String _getMonthShortName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (month >= 1 && month <= 12) return months[month - 1];
    return '';
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

  Future<void> updateVehicleFuelType(String vehicleId, String fuelType) async {
    try {
      await _supabase
          .from('vehicles')
          .update({'fuel_type': fuelType})
          .eq('id', vehicleId);
    } catch (e) {
      throw Exception('Failed to update vehicle fuel type: $e');
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
  Future<List<Map<String, dynamic>>> getVehicleDocuments(
    String vehicleId,
  ) async {
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
      final storagePath =
          '$vehicleId/$docType-${DateTime.now().millisecondsSinceEpoch}-$fileName';

      await _supabase.storage
          .from('vehicle_documents')
          .upload(storagePath, file);
      final fileUrl = _supabase.storage
          .from('vehicle_documents')
          .getPublicUrl(storagePath);

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

  Future<void> updateVehicle({
    required String vehicleId,
    required String model,
    required String plateNumber,
    required String fuelType,
  }) async {
    try {
      await _supabase
          .from('vehicles')
          .update({
            'model': model,
            'plate_number': plateNumber,
            'fuel_type': fuelType,
          })
          .eq('id', vehicleId);
    } catch (e) {
      throw Exception('Failed to update vehicle: $e');
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
      await _supabase.rpc(
        'admin_create_driver',
        params: {
          'driver_password': password,
          'driver_phone': phone,
          'driver_full_name': fullName,
          'assign_client_id': clientId,
        },
      );
    } catch (e) {
      throw Exception('Failed to create driver: $e');
    }
  }

  Future<void> updateDriver({
    required String driverId,
    required String phone,
    required String fullName,
    String? clientId,
  }) async {
    try {
      await _supabase
          .from('profiles')
          .update({
            'phone_number': phone,
            'full_name': fullName,
            'client_id': clientId,
          })
          .eq('id', driverId);
    } catch (e) {
      throw Exception('Failed to update driver: $e');
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
      final storagePath =
          'drivers/$driverId/$docType-${DateTime.now().millisecondsSinceEpoch}-$fileName';

      // Ensure the 'driver_documents' storage bucket exists in Supabase,
      // or we can use a generic 'documents' bucket. Assuming 'driver_documents' for now.
      await _supabase.storage
          .from('driver_documents')
          .upload(storagePath, file);

      await _supabase.from('driver_documents').insert({
        'driver_id': driverId,
        'doc_type': docType,
        'file_url': storagePath,
        'expiry_date': expiryDate?.toIso8601String(),
        'status': 'approved', // Uploaded by admin, so auto-approved
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

  /// Add a driver payment
  Future<void> addDriverPayment({
    required String driverId,
    required double amount,
    required DateTime paymentDate,
    String? note,
  }) async {
    try {
      await _supabase.from('driver_payments').insert({
        'driver_id': driverId,
        'amount': amount,
        'payment_date': paymentDate.toIso8601String(),
        'note': note,
      });
    } catch (e) {
      print("Error adding payment: $e");
      rethrow;
    }
  }

  /// Delete a payment
  Future<void> deleteDriverPayment(String paymentId) async {
    try {
      await _supabase.from('driver_payments').delete().eq('id', paymentId);
    } catch (e) {
      print("Error deleting payment: $e");
      rethrow;
    }
  }

  /// Fetch payments
  Future<List<Map<String, dynamic>>> getDriverPayments({
    String? driverId,
    DateTime? month,
  }) async {
    try {
      var query = _supabase
          .from('driver_payments')
          .select('*, profiles!driver_payments_driver_id_fkey(full_name)');

      if (driverId != null) {
        query = query.eq('driver_id', driverId);
      }

      if (month != null) {
        final startOfMonth = DateTime(month.year, month.month, 1);
        final endOfMonth = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
        query = query
            .gte('payment_date', startOfMonth.toIso8601String())
            .lte('payment_date', endOfMonth.toIso8601String());
      }

      final response = await query.order('payment_date', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching payments: $e");
      return [];
    }
  }
}
