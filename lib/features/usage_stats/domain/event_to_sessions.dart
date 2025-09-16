import 'models/usage_event.dart';
import 'models/usage_session.dart';

List<UsageSession> eventsToSessions(
  List<UsageEvent> events,
  Map<String, UsageEvent> lastStartMap,
) {
  List<UsageSession> sessions = [];

  for (var e in events) {
    switch (e.eventType) {
      // START events
      case 1: // MOVE_TO_FOREGROUND
        lastStartMap[e.packageName] = e;
        break;

      case 23: // ACTIVITY_STOPPED
        final startEvent = lastStartMap[e.packageName];
        if (startEvent != null) {
          final start = DateTime.fromMillisecondsSinceEpoch(
            startEvent.timeStamp,
          );
          final end = DateTime.fromMillisecondsSinceEpoch(e.timeStamp);
          final duration = end.difference(start);

          if (duration.inMinutes >= 5) {
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
          lastStartMap.remove(e.packageName);
        }
        break;
      default:
        break;
    }
  }
  return sessions;
}
