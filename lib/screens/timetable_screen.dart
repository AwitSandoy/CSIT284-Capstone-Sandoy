import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../models/firestore_service.dart';
import 'class_form_screen.dart';

class TimetableScreen extends StatelessWidget {
  const TimetableScreen({super.key});

  static const List<String> _dayOrder = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandela - Weekly Timetable'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClassFormScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<ClassSchedule>>(
        stream: firestoreService.getClassesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final classes = List<ClassSchedule>.from(snapshot.data ?? []);
          if (classes.isEmpty) {
            return const Center(child: Text('No classes found in Firestore.'));
          }

          classes.sort((a, b) => _dayOrder
              .indexOf(a.dayOfWeek)
              .compareTo(_dayOrder.indexOf(b.dayOfWeek)));

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final item = classes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(item.dayOfWeek.substring(0, 3)),
                  ),
                  title: Text(
                    '${item.subjectCode} (${item.dayOfWeek})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${item.subjectName}\n${item.startTime} - ${item.endTime} @ ${item.room} • ${item.instructor}',
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        tooltip: 'Edit Schedule',
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ClassFormScreen(existingClass: item),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        tooltip: 'Delete Schedule',
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await firestoreService.deleteClass(item.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}