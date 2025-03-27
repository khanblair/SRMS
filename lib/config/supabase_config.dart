import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:srms/config/constants.dart';

class SupabaseConfig {
  static const String url = 'https://uitlgvfcjpagldmrdfht.supabase.co';
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVpdGxndmZjanBhZ2xkbXJkZmh0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDI4MTIwNDksImV4cCI6MjA1ODM4ODA0OX0.L-kDiriDGAsBe0_lfXtUUKyfky69unEwRCgJSzK11Nc';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}