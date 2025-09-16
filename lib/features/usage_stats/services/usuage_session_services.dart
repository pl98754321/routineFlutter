import '../../../adapter/supabase.dart';
import '../../../core/model/usage_session_db.dart';

class UsageSessionService {
  final _table = "usage_sessions";

  /// บันทึก UsageSession ลง Supabase
  Future<void> saveUsageSession(UsageSessionDB session) async {
    final data = session.toJson();

    final _ = await SupabaseConfig.client.from(_table).insert(data);
  }

  /// บันทึก UsageSessions หลายรายการ
  Future<void> saveBulkUsageSessions(List<UsageSessionDB> sessions) async {
    if (sessions.isEmpty) return;

    final data = sessions.map((s) => s.toJson()).toList();

    final _ = await SupabaseConfig.client.from(_table).insert(data);
  }

  /// ดึง UsageSessions ของ user
  Future<List<UsageSessionDB>> searchUsageSessions(
    int userId, {
    DateTime? since,
  }) async {
    var query = SupabaseConfig.client
        .from(_table)
        .select()
        .eq("user_id", userId);

    if (since != null) {
      query = query.gte("start_time", since.toUtc().toIso8601String());
    }
    final response = await query.order("start_time", ascending: false);

    return response.map((row) => UsageSessionDB.fromJson(row)).toList();
  }
}
