import 'package:flutter/material.dart';
import '../../../core/logging.dart';
import '../domain/event_to_sessions.dart';
import '../domain/models/app_usage.dart';
import '../domain/models/usage_session.dart';
import '../services/app_usage_services.dart';
import 'widget/usage_calendar.dart';
import 'widget/usage_event_list.dart';
import 'widget/usage_summary_list.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({super.key});

  @override
  State<UsagePage> createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage> {
  final service = AppUsageService();
  List<AppUsage> usages = [];
  List<UsageSession> sessions = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final usageData = await service.getTodayUsage();
    final eventData = await service.getUsageEvents();
    await AppLogger.log("Fetching usage data...");
    await AppLogger.log("Got ${sessions.length} sessions");
    (eventData);
    setState(() {
      usages = usageData.where((e) => e.totalTimeUsed > 60 * 1000).toList();
      sessions = eventsToSessions(eventData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Usage")),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            UsageSummaryList(usages: usages),
            const Divider(),
            UsageEventList(sessions: sessions),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Calendar View",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            UsageCalendar(sessions: sessions),
          ],
        ),
      ),
    );
  }
}
