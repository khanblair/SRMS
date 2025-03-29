import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';

class AuthService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<User?> getCurrentUser() async {
    return _client.auth.currentUser;
  }

  Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<AuthResponse> signUpWithEmail(
    String email, 
    String password, 
    String fullName, 
    {String role = 'lecturer', 
    String? departmentId}
  ) async {
    // First, sign up the user with Supabase Auth
    final authResponse = await _client.auth.signUp(
      email: email,
      password: password,
    );

    // If user creation was successful, create a record in the users table
    if (authResponse.user != null) {
      await _client.from('users').upsert({
        'id': authResponse.user!.id,
        'email': email,
        'full_name': fullName,
        'role': role,
        'department_id': departmentId,
        'password_hash': '', // Note: Supabase handles password hashing
        'is_active': true,
      });
    }

    return authResponse;
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    
    await _client.from('users').upsert({
      'id': userId,
      ...updates,
    });
  }
}