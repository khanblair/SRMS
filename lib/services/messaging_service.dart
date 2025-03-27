import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/message_model.dart';

class MessagingService {
  final SupabaseClient _client = SupabaseConfig.client;

  Stream<List<Conversation>> getConversations(String userId) {
    return _client.from('conversations')
      .stream(primaryKey: ['id'])
      .eq('participants.user_id', userId)
      .order('updated_at', ascending: false)
      .map((data) => data.map((json) => Conversation.fromJson(json)).toList());
  }

  Stream<List<Message>> getMessages(String conversationId) {
    return _client.from('messages')
      .stream(primaryKey: ['id'])
      .eq('conversation_id', conversationId)
      .order('created_at')
      .map((data) => data.map((json) => Message.fromJson(json)).toList());
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
    });
    
    // Update conversation last message timestamp
    await _client.from('conversations')
      .update({'updated_at': DateTime.now().toIso8601String()})
      .eq('id', conversationId);
  }

  Future<String> createConversation(List<String> participantIds) async {
    final response = await _client.from('conversations').insert({
      'participants': participantIds.map((id) => {'user_id': id}).toList(),
    }).select();
    return response.first['id'] as String;
  }
}