import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../domain/models/usage_session.dart';

class UsageCalendar extends StatelessWidget {
  final List<UsageSession> sessions;
  const UsageCalendar({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SfCalendar(
        view: CalendarView.day,
        dataSource: UsageDataSource(sessions),
        timeSlotViewSettings: const TimeSlotViewSettings(
          startHour: 0,
          endHour: 24,
          timeIntervalHeight: 60,
        ),
      ),
    );
  }
}

class UsageDataSource extends CalendarDataSource {
  UsageDataSource(List<UsageSession> sessions) {
    appointments = sessions.map((s) {
      return Appointment(
        startTime: s.startTime,
        endTime: s.endTime,
        subject: s.appName,
        color: Colors.primaries[s.appName.hashCode % Colors.primaries.length],
      );
    }).toList();
  }
}
