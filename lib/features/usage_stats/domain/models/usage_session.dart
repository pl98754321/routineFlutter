import '../../../../core/model/usage_session_db.dart';

class UsageSession {
  final String packageName;
  final String appName;
  final String? icon; // base64 string
  final DateTime startTime;
  final DateTime endTime;
  final Duration duration;

  UsageSession({
    required this.packageName,
    required this.appName,
    this.icon,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory UsageSession.fromJson(Map<String, dynamic> json) {
    return UsageSession(
      packageName: json['packageName'],
      appName: json['appName'] ?? json['packageName'],
      icon: json['icon'],
      startTime: DateTime.fromMillisecondsSinceEpoch(json['startTime']),
      endTime: DateTime.fromMillisecondsSinceEpoch(json['endTime']),
      duration: Duration(milliseconds: json['duration'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'icon': icon,
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime.millisecondsSinceEpoch,
      'duration': duration.inMilliseconds,
    };
  }

  UsageSessionDB toUsageSessionDB(int userId) {
    return UsageSessionDB(
      id: 0,
      userId: userId,
      packageName: packageName,
      startTime: startTime,
      endTime: endTime,
      duration: duration.inSeconds,
    );
  }

  @override
  String toString() => toJson().toString();
}
