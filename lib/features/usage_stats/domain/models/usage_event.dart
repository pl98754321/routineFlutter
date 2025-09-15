class UsageEvent {
  final String packageName;
  final String appName;
  final String? icon; // base64 string
  final int eventType; // 1 = foreground, 2 = background
  final int timeStamp; // epoch ms

  UsageEvent({
    required this.packageName,
    required this.appName,
    this.icon,
    required this.eventType,
    required this.timeStamp,
  });

  factory UsageEvent.fromJson(Map<String, dynamic> json) {
    return UsageEvent(
      packageName: json['packageName'],
      appName: json['appName'] ?? json['packageName'],
      icon: json['icon'],
      eventType: json['eventType'],
      timeStamp: json['timeStamp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'packageName': packageName,
      'appName': appName,
      'eventType': eventType,
      'timeStamp': timeStamp,
    };
  }

  @override
  String toString() => toJson().toString();
}
