import '../services/app_usage_services.dart';
import '../services/user_usuage_services.dart';
import '../services/usuage_session_services.dart';
import 'event_to_sessions.dart';
import 'models/usage_session.dart';

Future<List<UsageSession>> fetchUsuageSessions() async {
  final userId = 1; // Dummy user_id
  final appUsuageService = AppUsageService();
  final usuageStateService = UsageStateService();
  final usuageSessionServices = UsageSessionService();
  final beginTimestamp = DateTime.now().toUtc().subtract(
    const Duration(days: 7),
  );

  final res = await usuageStateService.searchUsageState(userId);
  final lastestFetchTimestamp =
      res?.lastFetchTime ??
      DateTime.now().toUtc().subtract(const Duration(days: 1));
  final lastStartMap = res?.lastStartMap ?? {};
  final eventData = await appUsuageService.getUsageEvents(
    lastestFetchTimestamp,
  );
  final sessionData = eventsToSessions(eventData, lastStartMap);
  await usuageStateService.saveUsageState(userId, lastStartMap);
  final sessionDataDb = sessionData
      .map((s) => s.toUsageSessionDB(userId))
      .toList();
  await usuageSessionServices.saveBulkUsageSessions(sessionDataDb);

  // Old session Nedd to create Converting function
  final oldSessions = await usuageSessionServices.searchUsageSessions(
    userId,
    since: beginTimestamp,
  );

  return sessionData;
}
