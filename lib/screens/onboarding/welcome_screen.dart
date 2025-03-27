import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeScreen({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset('assets/images/welcome.png', height: 200),
            const SizedBox(height: 32),
            Text(
              'Lecturer Requisition System',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(AppConstants.primaryColor),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Easily submit and track your part-time teaching salary requests',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onGetStarted,
                child: const Text('Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}