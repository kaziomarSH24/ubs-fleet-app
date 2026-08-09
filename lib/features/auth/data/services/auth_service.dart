import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_setup.dart';
import '../../../../core/database/entities/profile_local.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService(Supabase.instance.client);
});

class AuthService {
  final SupabaseClient _supabase;

  AuthService(this._supabase);

  // Sign in using either Employee ID or Phone Number
  Future<AuthResponse> signInWithIdOrPhone({
    required String input,
    required String pin,
  }) async {
    try {
      String loginIdentifier = input.trim();
      
      // Step 1: Check if input is a phone number or ID
      // If it contains only digits, it's likely a phone number.
      bool isPhoneNumber = RegExp(r'^[0-9]+$').hasMatch(loginIdentifier);

      String targetEmployeeId = loginIdentifier;

      if (isPhoneNumber) {
        // Step 2: If phone number, query the profiles table to get the Employee ID
        final response = await _supabase
            .from('profiles')
            .select('employee_id')
            .eq('phone_number', loginIdentifier)
            .maybeSingle();

        if (response == null) {
          throw const AuthException('No user found with this phone number.');
        }
        
        targetEmployeeId = response['employee_id'];
      }

      // Step 3: Construct the dummy email used for Supabase Auth
      // We assume every user is registered with [employee_id]@ubsfleet.com
      final dummyEmail = '${targetEmployeeId.toLowerCase()}@ubsfleet.com';

      // Step 4: Sign in with Supabase Auth
      final authResponse = await _supabase.auth.signInWithPassword(
        email: dummyEmail,
        password: pin, // using PIN as password
      );

      // Step 5: Fetch profile and save to Hive
      if (authResponse.user != null) {
        await fetchAndCacheProfile(authResponse.user!.id);
      }

      return authResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;
  
  // Fetch profile from Supabase and cache it
  Future<void> fetchAndCacheProfile(String userId) async {
    final response = await _supabase
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();

    if (response != null) {
      final profile = ProfileLocal(
        id: response['id'],
        fullName: response['full_name'] ?? 'Unknown',
        employeeId: response['employee_id'] ?? '',
        phoneNumber: response['phone_number'] ?? '',
        role: response['role'] ?? 'driver',
        avatarUrl: response['avatar_url'],
        drivingLicenseNo: response['driving_license_no'],
      );

      final box = Hive.box<ProfileLocal>(HiveSetup.profilesBox);
      await box.put(userId, profile);
    }
  }

  // Get locally cached profile
  ProfileLocal? getLocalProfile() {
    final session = currentSession;
    if (session == null) return null;
    
    final box = Hive.box<ProfileLocal>(HiveSetup.profilesBox);
    return box.get(session.user.id);
  }

  // Stream of auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
}
