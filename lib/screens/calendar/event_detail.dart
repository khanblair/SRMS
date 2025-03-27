import 'package:flutter/material.dart';
import 'package:lecturer_requisition/models/event_model.dart';
import 'package:lecturer_requisition/services/calendar_service.dart';
import 'package:provider/provider.dart';
import 'package:lecturer_requisition/state/auth_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final userId = authProvider.user?.id;
    final calendarService = CalendarService();

    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              event.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (event.description != null) ...[
              Text(
                event.description!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Date & Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatDate(event.startTime)} - ${_formatTime(event.startTime)} to ${_formatTime(event.endTime)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (event.location != null) ...[
              const Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.location!,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              'Duration',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.duration,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            if (userId != null && event.organizerId != userId)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await calendarService.updateEventAttendance(
                        eventId: event.id,
                        userId: userId,
                        status: 'accepted',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Attendance confirmed!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to confirm attendance: $e')),
                      );
                    }
                  },
                  child: const Text('Confirm Attendance'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }
}