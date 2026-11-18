import 'package:flutter/material.dart';
import '../models/class_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final ClassSchedule schedule;

  const ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context) {
    return Card(  
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            schedule.dayOfWeek.substring(0, 3),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
          ),
        ),
        title: Text(
          '${schedule.subjectCode}: ${schedule.subjectName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Time: ${schedule.startTime} - ${schedule.endTime}\nRoom: ${schedule.room} | Instructor: ${schedule.instructor}',
        ),
        isThreeLine: true,
      ),
    );
  }
}