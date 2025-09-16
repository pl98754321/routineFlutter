import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = "https://<YOUR-PROJECT-REF>.supabase.co";
  static const String anonKey = "<YOUR-ANON-KEY>";

  static Future<void> init() async {
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
