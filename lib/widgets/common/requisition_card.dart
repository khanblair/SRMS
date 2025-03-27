import 'package:flutter/material.dart';
import 'package:srms/config/constants.dart';
import 'package:srms/models/requisition_model.dart';

class RequisitionCard extends StatelessWidget {
  final Requisition requisition;
  final VoidCallback onTap;

  const RequisitionCard({
    super.key,
    required this.requisition,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'approved':
        return Color(AppConstants.accentColor);
      case 'rejected':
        return Colors.red;
      case 'paid':
        return Colors.green;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'KES ${requisition.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Chip(
                    label: Text(
                      requisition.status.toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(requisition.status),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${requisition.hoursWorked} hours @ KES ${requisition.paymentRate}/hour',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (requisition.departmentName != null) ...[
                const SizedBox(height: 4),
                Text(
                  requisition.departmentName!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 4,
                children: requisition.coursesTaught
                    .map((course) => Chip(
                          label: Text(course),
                          visualDensity: VisualDensity.compact,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Submitted: ${requisition.submissionDate.toLocal().toString().split(' ')[0]}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (requisition.isUrgent)
                    const Icon(Icons.warning, color: Colors.red),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}