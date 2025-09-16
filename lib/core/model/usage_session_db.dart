class UsageSessionDB {
  final int id;
  final int userId;
  final String packageName;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // วินาที

  UsageSessionDB({
    required this.id,
    required this.userId,
    required this.packageName,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory UsageSessionDB.fromJson(Map<String, dynamic> json) {
    return UsageSessionDB(
      id: json['id'],
      userId: json['user_id'],
      packageName: json['package_name'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'package_name': packageName,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration': duration,
    };
  }
}
