import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srms/state/auth_provider.dart';
import 'package:srms/widgets/common/app_bar.dart';
import 'package:srms/widgets/common/drawer.dart';
import 'package:srms/screens/requisitions/requisition_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Dashboard',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      drawer: const CustomDrawer(),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requisitions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: authProvider.isLecturer
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/requisitions/create');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return const Center(child: Text('Dashboard Content'));
      case 1:
        return const RequisitionListScreen();
      case 2:
        return const Center(child: Text('Profile Content'));
      default:
        return const Center(child: Text('Dashboard Content'));
    }
  }
}