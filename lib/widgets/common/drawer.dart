import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/config/constants.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(AppConstants.primaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.person, size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  authProvider.user?.email ?? 'Guest',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  authProvider.userRole ?? 'No role',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          if (authProvider.isLecturer) ...[
            ListTile(
              leading: const Icon(Icons.request_page),
              title: const Text('My Requisitions'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/requisitions');
              },
            ),
          ],
          if (authProvider.isHod || authProvider.isAdmin) ...[
            ListTile(
              leading: const Icon(Icons.approval),
              title: const Text('Approvals'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to approvals screen
              },
            ),
          ],
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              await authProvider.signOut();
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}