import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository();
});

final selectedClientProvider = StateProvider<String?>((ref) => null);

final clientsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getClients();
});

final dashboardStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final clientId = ref.watch(selectedClientProvider);
  return repo.getDashboardStats(clientId: clientId);
});

final recentLogsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final clientId = ref.watch(selectedClientProvider);
  return repo.getRecentLogs(limit: 5, clientId: clientId); // Fetch 5 recent logs for dashboard
});

final pendingExpensesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final clientId = ref.watch(selectedClientProvider);
  return repo.getPendingExpenses(clientId: clientId);
});

final vehiclesProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final clientId = ref.watch(selectedClientProvider);
  return repo.getAllVehicles(clientId: clientId);
});

final driversProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repo = ref.read(adminRepositoryProvider);
  final clientId = ref.watch(selectedClientProvider);
  return repo.getAllDrivers(clientId: clientId);
});

final vehicleDocumentsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, vehicleId) async {
  final repo = ref.read(adminRepositoryProvider);
  return repo.getVehicleDocuments(vehicleId);
});
