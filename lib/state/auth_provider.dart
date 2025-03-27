import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/constants.dart';
import 'package:srms/config/supabase_config.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _userRole;

  User? get user => _user;
  String? get userRole => _userRole;

  Future<void> initialize() async {
    _user = SupabaseConfig.client.auth.currentUser;
    if (_user != null) {
      await _fetchUserRole();
    }
    notifyListeners();
  }

  Future<void> _fetchUserRole() async {
    if (_user == null) return;
    
    final response = await SupabaseConfig.client
        .from('users')
        .select('role')
        .eq('id', _user!.id)
        .single();
    
    _userRole = response['role'] as String?;
    notifyListeners();
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      final response = await SupabaseConfig.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      _user = response.user;
      await _fetchUserRole();
      notifyListeners();
    } on AuthException catch (e) {
      throw e.message;
    } catch (e) {
      throw 'An unexpected error occurred';
    }
  }

  Future<void> signOut() async {
    await SupabaseConfig.client.auth.signOut();
    _user = null;
    _userRole = null;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;
  bool get isLecturer => _userRole == AppConstants.roleLecturer;
  bool get isHod => _userRole == AppConstants.roleHod;
  bool get isAdmin => _userRole == AppConstants.roleAdmin;
}