import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/requisition_model.dart';

class RequisitionService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<List<Requisition>> getRequisitions({String? userId, String? departmentId}) async {
    final query = _client.from('requisitions')
      .select('*, department:departments(*), lecturer:users(*)');
    
    if (userId != null) {
      query.eq('lecturer_id', userId);
    }
    if (departmentId != null) {
      query.eq('department_id', departmentId);
    }

    final data = await query.order('created_at', ascending: false);
    return data.map((json) => Requisition.fromJson(json)).toList();
  }

  Future<Requisition> createRequisition(Map<String, dynamic> requisitionData) async {
    final response = await _client.from('requisitions').insert(requisitionData).select();
    return Requisition.fromJson(response.first);
  }

  Future<void> updateRequisitionStatus(String requisitionId, String status) async {
    await _client.from('requisitions')
      .update({'status': status})
      .eq('id', requisitionId);
  }
}