import '../services/app_usage_services.dart';
import '../services/user_usuage_services.dart';
import 'event_to_sessions.dart';
import 'models/usage_session.dart';

Future<List<UsageSession>> fetchUsuageSessions() async {
  final userId = 1; // Dummy user_id
  final service = AppUsageService();
  final usuageStateService = UsageStateService();

  final res = await usuageStateService.searchUsageState(userId);
  final beginTimestamp =
      res?.lastFetchTime ??
      DateTime.now().toUtc().subtract(const Duration(days: 1));
  final lastStartMap = res?.lastStartMap ?? {};
  final eventData = await service.getUsageEvents(beginTimestamp);
  final sessionData = eventsToSessions(eventData, lastStartMap);
  await usuageStateService.saveUsageState(userId, lastStartMap);
  return sessionData;
}
