import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class CustomProgressIndicator extends StatelessWidget {
  final String? label;
  final double? value;
  final Color? color;

  const CustomProgressIndicator({
    super.key,
    this.label,
    this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
        ],
        SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: 8,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? Color(AppConstants.primaryColor),
            ),
          ),
        ),
      ],
    );
  }
}

class LinearLoadingIndicator extends StatelessWidget {
  final String? label;
  final Color? color;

  const LinearLoadingIndicator({
    super.key,
    this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
        LinearProgressIndicator(
          minHeight: 4,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? Color(AppConstants.primaryColor),
          ),
        ),
      ],
    );
  }
}