import 'package:flutter/material.dart';
import 'package:srms/models/message_model.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;

  const ChatScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual data fetching
    final messages = <Message>[]; // Replace with real data
    
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          const MessageInput(),
        ],
      ),
    );
  }
}