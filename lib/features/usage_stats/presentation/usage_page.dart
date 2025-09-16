import 'package:flutter/material.dart';
import '../domain/fetch_usuage_session.dart';
import '../domain/models/usage_session.dart';
import 'widget/usage_event_list.dart';

class UsagePage extends StatefulWidget {
  const UsagePage({super.key});

  @override
  State<UsagePage> createState() => _UsagePageState();
}

class _UsagePageState extends State<UsagePage> {
  List<UsageSession> sessions = [];

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _refreshData() async {
    final eventData = await fetchUsuageSessions();

    setState(() {
      sessions = eventData;
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
            // UsageSummaryList(usages: usages),
            // const Divider(),
            UsageEventList(sessions: sessions),
            // const Divider(),
            // const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     "Calendar View",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // UsageCalendar(sessions: sessions),
          ],
        ),
      ),
    );
  }
}
