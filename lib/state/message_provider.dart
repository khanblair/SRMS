import 'package:flutter/material.dart';
import 'package:srms/models/message_model.dart';
import 'package:srms/services/messaging_service.dart';

class MessageProvider with ChangeNotifier {
  final MessagingService _messagingService;
  List<Conversation> _conversations = [];
  bool _isLoading = false;

  MessageProvider(this._messagingService);

  List<Conversation> get conversations => _conversations;
  bool get isLoading => _isLoading;

  Future<void> loadConversations(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _conversations = await _messagingService.getConversations(userId).first;
    } catch (e) {
      throw Exception('Failed to load conversations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    try {
      await _messagingService.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        content: content,
      );
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<String> createConversation(List<String> participantIds) async {
    try {
      return await _messagingService.createConversation(participantIds);
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }
}