import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final bool small;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionText,
    this.onAction,
    this.small = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: small ? 48 : 80,
              color: Color(AppConstants.primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: small ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: small ? null : 200,
                child: ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(AppConstants.primaryColor),
                  ),
                  child: Text(actionText!),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}