import '../../../adapter/supabase.dart';
import '../../../core/model/app_db.dart';

class AppServices {
  final _table = "apps";
  final Map<String, AppDB> _cache = {};
  static final AppServices _instance = AppServices._internal();
  factory AppServices() {
    return _instance;
  }
  AppServices._internal();

  /// เพิ่มแอพใหม่
  Future<void> saveApp(AppDB app) async {
    final data = app.toJson();

    final _ = await SupabaseConfig.client.from(_table).insert(data);
  }

  /// เพิ่มแอพหลายตัว (batch insert)
  Future<void> saveBulkApps(List<AppDB> apps) async {
    if (apps.isEmpty) return;

    final data = apps.map((a) => a.toJson()).toList();

    final _ = await SupabaseConfig.client.from(_table).insert(data);
  }

  /// ค้นหาแอพทั้งหมดของ user
  Future<List<AppDB>> searchApps(int userId) async {
    final response = await SupabaseConfig.client
        .from(_table)
        .select()
        .eq("user_id", userId)
        .order("app_name", ascending: true);
    return response.map((row) => AppDB.fromJson(row)).toList();
  }

  Future<AppDB?> searchAppByPackage(int userId, String packageName) async {
    final key = "$userId::$packageName";

    // เช็ค cache ก่อน
    if (_cache.containsKey(key)) {
      return _cache[key];
    }

    // ไม่เจอ → query จาก Supabase
    final response = await SupabaseConfig.client
        .from(_table)
        .select()
        .eq("user_id", userId)
        .eq("package_name", packageName)
        .maybeSingle();

    if (response == null) return null;

    final app = AppDB.fromJson(response);
    _cache[key] = app; // เก็บลง cache
    return app;
  }

  void clearCache() {
    _cache.clear();
  }

  /// อัปเดตแอพ (เช่นเปลี่ยนชื่อ, icon)
  Future<void> updateApp(AppDB app) async {
    final _ = await SupabaseConfig.client
        .from(_table)
        .update(app.toJson())
        .eq("id", app.id);
  }

  /// ลบแอพ
  Future<void> deleteApp(int id) async {
    final _ = await SupabaseConfig.client.from(_table).delete().eq("id", id);
  }
}
