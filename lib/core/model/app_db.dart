class AppDB {
  final int id;
  final int userId;
  final String packageName;
  final String appName;
  final String? icon;
  final DateTime installedAt;

  AppDB({
    required this.id,
    required this.userId,
    required this.packageName,
    required this.appName,
    this.icon,
    required this.installedAt,
  });

  factory AppDB.fromJson(Map<String, dynamic> json) {
    return AppDB(
      id: json['id'],
      userId: json['user_id'],
      packageName: json['package_name'],
      appName: json['app_name'],
      icon: json['icon'],
      installedAt: DateTime.parse(json['installed_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_name': packageName,
      'app_name': appName,
      'icon': icon,
      'installed_at': installedAt.toIso8601String(),
    };
  }
}
