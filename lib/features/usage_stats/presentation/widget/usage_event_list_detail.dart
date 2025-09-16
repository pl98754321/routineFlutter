import 'package:flutter/material.dart';
import '../../domain/models/usage_event.dart';
import '../../domain/base64_to_img.dart';

class UsageEventListDetail extends StatelessWidget {
  final List<UsageEvent> events;
  const UsageEventListDetail({super.key, required this.events});

  String _eventTypeLabel(int type) {
    switch (type) {
      case 1:
        return "Foreground";
      case 23:
        return "Background";
      default:
        return "Other ($type)";
    }
  }

  Icon _eventTypeIcon(int type) {
    switch (type) {
      case 1:
        return const Icon(Icons.play_arrow, color: Colors.green);
      case 23:
        return const Icon(Icons.stop_circle, color: Colors.red);
      default:
        return const Icon(Icons.device_unknown, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Usage Events (raw events)",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...events.map(
          (e) => ListTile(
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
                    decodeBase64Icon(e.icon) ??
                    const Icon(Icons.apps, color: Colors.white),
              ),
            ),
            title: Text(e.appName),
            subtitle: Text(
              "Event: ${_eventTypeLabel(e.eventType)}\n"
              "Time: ${DateTime.fromMillisecondsSinceEpoch(e.timeStamp)}",
            ),
            trailing: _eventTypeIcon(e.eventType),
          ),
        ),
      ],
    );
  }
}
