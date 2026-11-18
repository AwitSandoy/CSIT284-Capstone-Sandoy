import 'package:flutter/material.dart';
import '../models/dummy_data.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandela - Weekly Timetable'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: DummyData.classes.length,
        itemBuilder: (context, index) {
          final item = DummyData.classes[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text(item.dayOfWeek.substring(0, 3)),
            ),
            title: Text('${item.subjectCode} (${item.dayOfWeek})'),
            subtitle: Text('${item.subjectName}\n${item.startTime} - ${item.endTime} @ ${item.room}'),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}