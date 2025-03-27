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

  Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;
    
    await _client.from('users').update(updates).eq('id', userId);
  }
}