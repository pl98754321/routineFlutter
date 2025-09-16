import '../../../adapter/supabase.dart';
import '../domain/models/usage_event.dart';

class UsageState {
  final Map<String, UsageEvent> lastStartMap;
  final DateTime lastFetchTime;

  UsageState({required this.lastStartMap, required this.lastFetchTime});
}

class UsageStateService {
  final _table = "usage_state";

  /// Save หรืออัปเดต state ของ user
  Future<void> saveUsageState(
    int userId,
    Map<String, UsageEvent> lastStartMap,
  ) async {
    // แปลงเป็น JSON -> { packageName: timestamp }
    final stateMap = lastStartMap.map((pkg, e) => MapEntry(pkg, e.timeStamp));

    final data = {
      "user_id": userId,
      "last_start_map": stateMap,
      "last_fetch_time": DateTime.now().toUtc().toIso8601String(),
    };

    final response = await SupabaseConfig.client.from(_table).upsert(data);

    if (response.error != null) {
      throw Exception("Failed to save usage state: ${response.error!.message}");
    }
  }

  /// ดึง state ล่าสุดของ user
  Future<UsageState?> searchUsageState(int userId) async {
    final response = await SupabaseConfig.client
        .from(_table)
        .select()
        .eq("user_id", userId)
        .maybeSingle();

    if (response == null) {
      return null; // ยังไม่มี state
    }

    final rawMap = Map<String, dynamic>.from(response["last_start_map"]);
    final map = rawMap.map(
      (pkg, ts) => MapEntry(
        pkg,
        UsageEvent(
          packageName: pkg,
          eventType: 1, // ถือเป็น start
          timeStamp: ts,
          appName: "",
          icon: "",
        ),
      ),
    );

    return UsageState(
      lastStartMap: map,
      lastFetchTime: DateTime.parse(response["last_fetch_time"]),
    );
  }
}
