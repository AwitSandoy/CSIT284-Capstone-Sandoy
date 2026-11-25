import 'package:flutter/material.dart';
import '../models/class_schedule.dart';
import '../models/realtime_database_service.dart';
import '../widgets/schedule_card.dart';
import 'class_form_screen.dart';
import 'timetable_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  String _getCurrentDayName() {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }

  void _showReminderDialog(BuildContext context, ClassSchedule item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: const Icon(Icons.notifications_active),
        title: const Text('10-Minute Class Reminder'),
        content: Text(
          'Upcoming class in 10 minutes:\n\n'
          '${item.subjectCode}: ${item.subjectName}\n'
          'Time: ${item.startTime} - ${item.endTime}\n'
          'Room: ${item.room}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Dismiss'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final databaseService = RealtimeDatabaseService();
    final today = _getCurrentDayName();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mandela - Today\'s Classes'),
        actions: [
          IconButton(
            tooltip: 'Seed Dummy Classes to Realtime Database',
            icon: const Icon(Icons.cloud_upload),
            onPressed: () async {
              await databaseService.seedDummyData();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Seeded classes to Realtime Database.'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ClassFormScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Class Schedule'),
      ),
      body: StreamBuilder<List<ClassSchedule>>(
        stream: databaseService.getClassesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final allClasses = snapshot.data ?? [];
          final todaysClasses =
              allClasses.where((c) => c.dayOfWeek == today).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (todaysClasses.isNotEmpty)
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: ListTile(
                      leading: const Icon(Icons.alarm),
                      title: Text(
                        'Next Reminder: ${todaysClasses.first.subjectCode} at ${todaysClasses.first.startTime}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Room ${todaysClasses.first.room} • 10-minute alert ready',
                      ),
                      trailing: TextButton(
                        onPressed: () =>
                            _showReminderDialog(context, todaysClasses.first),
                        child: const Text('Preview Alert'),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                Text(
                  'Classes Scheduled for Today ($today)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: todaysClasses.isEmpty
                      ? Center(
                          child: Text(
                            allClasses.isEmpty
                                ? 'No classes in Realtime Database yet. Tap the cloud upload icon to seed your classes.'
                                : 'No classes scheduled for $today.',
                          ),
                        )
                      : ListView.builder(
                          itemCount: todaysClasses.length,
                          itemBuilder: (context, index) {
                            return ScheduleCard(schedule: todaysClasses[index]);
                          },
                        ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TimetableScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.calendar_view_week),
                    label: const Text('View Weekly Schedule'),
                  ),
                ),
                const SizedBox(height: 56),
              ],
            ),
          );
        },
      ),
    );
  }
}