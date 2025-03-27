import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/state/theme_provider.dart';
import 'package:srms/widgets/ui/empty_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();
  bool _isLoading = true;
  bool _isEditing = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (userId == null) return;

    try {
      final response = await SupabaseConfig.client
          .from('users')
          .select('full_name, phone_number, bio, dark_mode_enabled, department:departments(name)')
          .eq('id', userId)
          .single();

      setState(() {
        _nameController.text = response['full_name'] as String? ?? '';
        _phoneController.text = response['phone_number'] as String? ?? '';
        _bioController.text = response['bio'] as String? ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.user?.id;
      if (userId == null) return;

      await SupabaseConfig.client.from('users').update({
        'full_name': _nameController.text,
        'phone_number': _phoneController.text,
        'bio': _bioController.text,
      }).eq('id', userId);

      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $e')),
      );
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
          if (_isEditing)
            IconButton(
              icon: _isSaving
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.save),
              onPressed: _isSaving ? null : _saveProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              child: Text(
                authProvider.user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(height: 16),
            if (!_isEditing) ...[
              Text(
                _nameController.text,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                authProvider.user?.email ?? '',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              if (_phoneController.text.isNotEmpty)
                Text(
                  _phoneController.text,
                  style: const TextStyle(fontSize: 16),
                ),
              const SizedBox(height: 16),
              if (_bioController.text.isNotEmpty)
                Text(
                  _bioController.text,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
            ] else ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Name is required' : null,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                    ),
                    TextFormField(
                      controller: _bioController,
                      decoration: const InputDecoration(labelText: 'Bio'),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authProvider.signOut();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
    );
  }
}