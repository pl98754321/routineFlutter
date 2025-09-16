import 'package:flutter/material.dart';
import '../../domain/models/app_usage.dart';

class UsageSummaryList extends StatelessWidget {
  final List<AppUsage> usages;
  const UsageSummaryList({super.key, required this.usages});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Usage Summary ( > 1 min )",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...usages.map(
          (usage) => ListTile(
            title: Text(usage.appName ?? usage.packageName),
            subtitle: Text(
              "Used: ${(usage.totalTimeUsed / 1000 ~/ 60)} min\n"
              "Last used: ${DateTime.fromMillisecondsSinceEpoch(usage.lastTimeUsed)}\n"
              "First used: ${DateTime.fromMillisecondsSinceEpoch(usage.firstTimeStamp)}",
            ),
          ),
        ),
      ],
    );
  }
}
