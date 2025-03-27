import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/supabase_config.dart';
import 'package:srms/models/event_model.dart';

class CalendarService {
  final SupabaseClient _client = SupabaseConfig.client;

  Stream<List<Event>> getEvents(String userId) {
    return _client.from('events')
      .stream(primaryKey: ['id'])
      .or('organizer_id.eq.$userId,attendees.user_id.eq.$userId')
      .order('start_time')
      .map((data) => data.map((json) => Event.fromJson(json)).toList());
  }

  Future<Event> createEvent({
    required String title,
    required DateTime startTime,
    required DateTime endTime,
    required String organizerId,
    String? description,
    String? location,
    List<String>? attendeeIds,
  }) async {
    final response = await _client.from('events').insert({
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'organizer_id': organizerId,
      'attendees': attendeeIds?.map((id) => {'user_id': id}).toList(),
    }).select();
    return Event.fromJson(response.first);
  }

  Future<void> updateEventAttendance({
    required String eventId,
    required String userId,
    required String status,
  }) async {
    await _client.from('event_attendees').upsert({
      'event_id': eventId,
      'user_id': userId,
      'response_status': status,
    });
  }

  Future<void> updateEvent({
    required String eventId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    List<String>? attendeeIds,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (startTime != null) updates['start_time'] = startTime.toIso8601String();
    if (endTime != null) updates['end_time'] = endTime.toIso8601String();
    if (location != null) updates['location'] = location;
    if (attendeeIds != null) {
      updates['attendees'] = attendeeIds.map((id) => {'user_id': id}).toList();
    }

    await _client.from('events')
      .update(updates)
      .eq('id', eventId);
  }

  Future<void> deleteEvent(String eventId) async {
    await _client.from('events').delete().eq('id', eventId);
  }

  Future<List<Event>> getUpcomingEvents(String userId, {int limit = 5}) async {
    final now = DateTime.now().toIso8601String();
    final response = await _client.from('events')
      .select('*')
      .or('organizer_id.eq.$userId,attendees.user_id.eq.$userId')
      .gt('start_time', now)
      .order('start_time')
      .limit(limit);
    
    return response.map((json) => Event.fromJson(json)).toList();
  }
}