import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';

class RequisitionForm extends StatefulWidget {
  final TextEditingController hoursController;
  final TextEditingController rateController;
  final TextEditingController coursesController;
  final bool isUrgent;
  final ValueChanged<bool> onUrgentChanged;

  const RequisitionForm({
    super.key,
    required this.hoursController,
    required this.rateController,
    required this.coursesController,
    required this.isUrgent,
    required this.onUrgentChanged,
  });

  @override
  State<RequisitionForm> createState() => _RequisitionFormState();
}

class _RequisitionFormState extends State<RequisitionForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.hoursController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Hours Worked',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter hours worked';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.rateController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rate per Hour (KES)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter rate per hour';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: widget.coursesController,
            decoration: const InputDecoration(
              labelText: 'Courses Taught (comma separated)',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter courses taught';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Mark as Urgent'),
            subtitle: const Text('Request expedited processing'),
            value: widget.isUrgent,
            onChanged: widget.onUrgentChanged,
            activeColor: Color(AppConstants.accentColor),
          ),
          const SizedBox(height: 8),
          if (widget.isUrgent)
            Text(
              'Note: Urgent requests may require additional approval',
              style: TextStyle(
                color: Colors.orange[800],
                fontStyle: FontStyle.italic,
              ),
            ),
        ],
      ),
    );
  }
}