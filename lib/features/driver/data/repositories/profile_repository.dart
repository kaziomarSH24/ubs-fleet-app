import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/database/hive_setup.dart';
import '../../../../core/database/entities/profile_local.dart';
import '../../../sync/domain/services/sync_service.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client, ref.read(syncServiceProvider));
});

class ProfileRepository {
  final SupabaseClient _supabase;
  final SyncService _syncService;

  ProfileRepository(this._supabase, this._syncService);

  // Upload Avatar
  Future<String> uploadAvatar(String driverId, File imageFile) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final path = '$driverId/$fileName';
    
    await _supabase.storage.from('avatars').upload(path, imageFile);
    final url = _supabase.storage.from('avatars').getPublicUrl(path);
    
    // Update Supabase Database
    await _supabase.from('profiles').update({'avatar_url': url}).eq('id', driverId);
    
    // Update Local Hive
    final profileBox = Hive.box<ProfileLocal>(HiveSetup.profilesBox);
    final profile = profileBox.get(driverId);
    if (profile != null) {
      final updatedProfile = ProfileLocal(
        id: profile.id,
        fullName: profile.fullName,
        employeeId: profile.employeeId,
        phoneNumber: profile.phoneNumber,
        role: profile.role,
        avatarUrl: url,
        drivingLicenseNo: profile.drivingLicenseNo,
      );
      await profileBox.put(driverId, updatedProfile);
    }
    
    return url;
  }

  // Update Phone Number
  Future<void> updatePhoneNumber(String driverId, String newPhone) async {
    // We can queue this action for offline support
    final payload = {
      'id': driverId,
      'phone_number': newPhone,
    };
    
    // For immediate UI update
    final profileBox = Hive.box<ProfileLocal>(HiveSetup.profilesBox);
    final profile = profileBox.get(driverId);
    if (profile != null) {
      final updatedProfile = ProfileLocal(
        id: profile.id,
        fullName: profile.fullName,
        employeeId: profile.employeeId,
        phoneNumber: newPhone,
        role: profile.role,
        avatarUrl: profile.avatarUrl,
        drivingLicenseNo: profile.drivingLicenseNo,
      );
      await profileBox.put(driverId, updatedProfile);
    }

    await _syncService.queueAction('UPDATE_PROFILE', payload);
  }

  // Upload Document
  Future<void> uploadDocument(String driverId, String docType, File file) async {
    // Safely extract the file name, handling both Windows (\) and Unix (/) paths
    final originalName = file.path.split(RegExp(r'[\\/]')).last;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$originalName';
    final path = '$driverId/$docType/$fileName';
    
    await _supabase.storage.from('driver_documents').upload(path, file);
    
    final dbPayload = {
      'driver_id': driverId,
      'doc_type': docType,
      'file_url': path,
      'status': 'pending',
    };
    
    await _supabase.from('driver_documents').insert(dbPayload);
  }

  // Get signed URL for private buckets
  Future<String> getSignedUrl(String bucket, String path) async {
    return await _supabase.storage.from(bucket).createSignedUrl(path, 60 * 60); // 1 hour expiry
  }

  // Fetch Documents
  Future<List<Map<String, dynamic>>> getDocuments(String driverId) async {
    try {
      final response = await _supabase
          .from('driver_documents')
          .select()
          .eq('driver_id', driverId)
          .order('created_at', ascending: false);
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }
  
  // Get Signed URL for document viewing
  Future<String> getDocumentUrl(String path) async {
    try {
       return await _supabase.storage.from('driver_documents').createSignedUrl(path, 60 * 60); // 1 hour
    } catch(e) {
       return "";
    }
  }
  
  // Delete Document
  Future<void> deleteDocument(String docId, String path) async {
    await _supabase.storage.from('driver_documents').remove([path]);
    await _supabase.from('driver_documents').delete().eq('id', docId);
  }
  
  // Fetch Assigned Vehicle
  Future<Map<String, dynamic>?> getAssignedVehicle(String driverId) async {
    try {
      final response = await _supabase
          .from('vehicles')
          .select()
          .eq('current_driver_id', driverId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }
}
