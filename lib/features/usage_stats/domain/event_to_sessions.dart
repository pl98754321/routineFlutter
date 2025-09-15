import 'models/usage_event.dart';
import 'models/usage_session.dart';

List<UsageSession> eventsToSessions(List<UsageEvent> events) {
  List<UsageSession> sessions = [];
  final Map<String, UsageEvent> lastStartMap =
      {}; // เก็บ start ของแต่ละ package

  for (var e in events) {
    if (e.eventType == 1) {
      // foreground → update start ของ package นี้
      lastStartMap[e.packageName] = e;
    } else if (e.eventType == 2) {
      // background → จับคู่กับ start ของ package เดียวกัน
      final startEvent = lastStartMap[e.packageName];
      if (startEvent != null) {
        final start = DateTime.fromMillisecondsSinceEpoch(startEvent.timeStamp);
        final end = DateTime.fromMillisecondsSinceEpoch(e.timeStamp);
        final duration = end.difference(start);

        if (duration.inMinutes > 0) {
          sessions.add(
            UsageSession(
              packageName: e.packageName,
              appName: e.appName,
              icon: e.icon,
              startTime: start,
              endTime: end,
              duration: duration,
            ),
          );
        }
        lastStartMap.remove(e.packageName); // เคลียร์ start ที่ใช้แล้ว
      }
    }
  }
  return sessions;
}
