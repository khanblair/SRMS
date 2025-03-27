import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/requisition_model.dart';

class RequisitionProvider with ChangeNotifier {
  List<Requisition> _requisitions = [];
  bool _isLoading = false;
  String? _error;

  List<Requisition> get requisitions => _requisitions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadRequisitions({String? userId, String? departmentId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final query = SupabaseConfig.client.from('requisitions')
        .select('*, department:departments(*), lecturer:users(*)');
      
      if (userId != null) query.eq('lecturer_id', userId);
      if (departmentId != null) query.eq('department_id', departmentId);

      final data = await query.order('created_at', ascending: false);
      _requisitions = data.map((json) => Requisition.fromJson(json)).toList();
    } on PostgrestException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load requisitions';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createRequisition(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await SupabaseConfig.client
          .from('requisitions')
          .insert(data)
          .select();
      
      final newRequisition = Requisition.fromJson(response.first);
      _requisitions.insert(0, newRequisition);
    } on PostgrestException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to create requisition';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateRequisitionStatus(String id, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseConfig.client
          .from('requisitions')
          .update({'status': status})
          .eq('id', id);
      
      final index = _requisitions.indexWhere((req) => req.id == id);
      if (index != -1) {
        _requisitions[index] = _requisitions[index].copyWith(status: status);
      }
    } on PostgrestException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to update requisition';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}