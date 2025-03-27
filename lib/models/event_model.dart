class Event {
  final String id;
  final String title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final String organizerId;
  final List<Map<String, dynamic>>? attendees;
  final bool isRecurring;
  final String? recurrencePattern;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    required this.organizerId,
    this.attendees,
    this.isRecurring = false,
    this.recurrencePattern,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      location: json['location'] as String?,
      organizerId: json['organizer_id'] as String,
      attendees: json['attendees'] != null
          ? List<Map<String, dynamic>>.from(json['attendees'] as List)
          : null,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurrencePattern: json['recurrence_pattern'] as String?,
    );
  }

  String get duration {
    final duration = endTime.difference(startTime);
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  Event copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    String? organizerId,
    List<Map<String, dynamic>>? attendees,
    bool? isRecurring,
    String? recurrencePattern,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      organizerId: organizerId ?? this.organizerId,
      attendees: attendees ?? this.attendees,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
    );
  }
}