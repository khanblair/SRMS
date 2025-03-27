import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';

class AnalyticsService {
  final SupabaseClient _client = SupabaseConfig.client;

  Future<Map<String, dynamic>> getLecturerMetrics(String lecturerId) async {
    final response = await _client.rpc('get_lecturer_metrics', params: {
      'lecturer_id': lecturerId,
    });
    return response as Map<String, dynamic>;
  }

  Future<List<Map<String, dynamic>>> getDepartmentStats(String departmentId) async {
    final response = await _client.from('department_stats')
      .select('*')
      .eq('department_id', departmentId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> getApprovalTimelines() async {
    final response = await _client.from('approval_timelines').select('*');
    return List<Map<String, dynamic>>.from(response);
  }
}