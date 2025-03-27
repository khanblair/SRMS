import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/notification_model.dart';

class NotificationService {
  final SupabaseClient _client = SupabaseConfig.client;

  Stream<List<Notification>> getNotifications(String userId) {
    return _client.from('notifications')
      .stream(primaryKey: ['id'])
      .eq('user_id', userId)
      .order('created_at', ascending: false)
      .map((data) => data.map((json) => Notification.fromJson(json)).toList());
  }

  Future<void> markAsRead(String notificationId) async {
    await _client.from('notifications')
      .update({'is_read': true, 'read_at': DateTime.now().toIso8601String()})
      .eq('id', notificationId);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String message,
    String? actionUrl,
  }) async {
    await _client.from('notifications').insert({
      'user_id': userId,
      'subject': title,
      'content': message,
      'action_url': actionUrl,
    });
  }
}