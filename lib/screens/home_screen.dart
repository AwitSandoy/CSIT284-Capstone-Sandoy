import 'package:flutter/material.dart';
import '../models/dummy_data.dart';
import 'timetable_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Filter dummy classes for demonstration (e.g., Monday's classes)
    final todaysClasses = DummyData.classes.where((c) => c.dayOfWeek == 'Monday').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandela - Today\'s Classes'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Classes Scheduled for Today (Monday)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: todaysClasses.length,
                itemBuilder: (context, index) {
                  final item = todaysClasses[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('${item.subjectCode}: ${item.subjectName}'),
                      subtitle: Text('${item.startTime} - ${item.endTime} | ${item.room}'),
                      trailing: Text(item.instructor, style: const TextStyle(fontSize: 12)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TimetableScreen()),
                  );
                },
                icon: const Icon(Icons.calendar_view_week),
                label: const Text('View Full Weekly Timetable'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}