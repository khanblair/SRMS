import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srms/state/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: themeProvider.isDarkMode,
            onChanged: themeProvider.toggleTheme,
          ),
          const Divider(),
          ListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Manage notification preferences'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to notification settings
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to help screen
            },
          ),
        ],
      ),
    );
  }
}