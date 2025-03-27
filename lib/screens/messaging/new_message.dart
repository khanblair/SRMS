import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/state/message_provider.dart';
import 'package:srms/models/user_model.dart';
import 'package:srms/services/messaging_service.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  String? _selectedUserId;
  List<AppUser> _users = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final currentUserId = authProvider.user?.id;
      if (currentUserId == null) return;

      final response = await SupabaseConfig.client
          .from('users')
          .select('id, full_name, email, role')
          .neq('id', currentUserId);

      setState(() {
        _users = response.map((json) => AppUser.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users: $e')),
      );
    }
  }

  Future<void> _sendMessage() async {
    if (!_formKey.currentState!.validate() || _selectedUserId == null) return;

    setState(() => _isLoading = true);
    try {
      final authProvider = context.read<AuthProvider>();
      final currentUserId = authProvider.user?.id;
      if (currentUserId == null) return;

      final messageProvider = context.read<MessageProvider>();
      final conversationId = await messageProvider.createConversation([
        currentUserId,
        _selectedUserId!,
      ]);

      await messageProvider.sendMessage(
        conversationId: conversationId,
        senderId: currentUserId,
        content: _messageController.text,
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send message: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Message')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedUserId,
                      items: _users.map((user) {
                        return DropdownMenuItem(
                          value: user.id,
                          child: Text('${user.fullName} (${user.role})'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedUserId = value),
                      decoration: const InputDecoration(
                        labelText: 'Recipient',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value == null ? 'Please select a recipient' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a message';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendMessage,
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Send Message'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}