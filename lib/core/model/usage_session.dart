class UsageSession {
  final int id;
  final int userId;
  final int appId;
  final DateTime startTime;
  final DateTime endTime;
  final int duration; // วินาที

  UsageSession({
    required this.id,
    required this.userId,
    required this.appId,
    required this.startTime,
    required this.endTime,
    required this.duration,
  });

  factory UsageSession.fromJson(Map<String, dynamic> json) {
    return UsageSession(
      id: json['id'],
      userId: json['user_id'],
      appId: json['app_id'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'app_id': appId,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'duration': duration,
    };
  }
}
