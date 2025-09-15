import 'package:flutter/material.dart';
import '../../domain/models/usage_session.dart';
import '../../domain/base64_to_img.dart';

class UsageEventList extends StatelessWidget {
  final List<UsageSession> sessions;
  const UsageEventList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Usage Events (start/stop)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...sessions.map(
          (s) => ListTile(
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child:
                    decodeBase64Icon(s.icon) ??
                    const Icon(Icons.apps, color: Colors.white),
              ),
            ),
            title: Text(s.appName),
            subtitle: Text(
              "Start: ${s.startTime}\n"
              "End: ${s.endTime}\n"
              "Duration: ${s.duration.inMinutes} min",
            ),
          ),
        ),
      ],
    );
  }
}
