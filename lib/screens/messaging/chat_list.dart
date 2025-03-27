import 'package:flutter/material.dart';
import 'package:srms/models/message_model.dart';
import 'package:srms/widgets/common/message_preview.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement actual data fetching
    final conversations = <Conversation>[]; // Replace with real data
    
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return MessagePreview(conversation: conversation);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/messages/new');
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}