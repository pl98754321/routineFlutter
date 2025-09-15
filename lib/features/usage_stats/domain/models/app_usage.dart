class AppUsage {
  final String packageName;
  final String? appName;
  final String? icon; // base64 string
  final int totalTimeUsed; // milliseconds
  final int lastTimeUsed; // epoch ms

  AppUsage({
    required this.packageName,
    this.appName,
    this.icon,
    required this.totalTimeUsed,
    required this.lastTimeUsed,
  });

  factory AppUsage.fromJson(Map<String, dynamic> json) {
    return AppUsage(
      packageName: json['packageName'],
      appName: json['appName'] ?? json['packageName'],
      icon: json['icon'],
      totalTimeUsed: json['totalTimeUsed'] ?? 0,
      lastTimeUsed: json['lastTimeUsed'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'icon': icon,
      'totalTimeUsed': totalTimeUsed,
      'lastTimeUsed': lastTimeUsed,
    };
  }

  @override
  String toString() => toJson().toString();
}
