import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dummy_data.dart';
import 'class_schedule.dart';

class RealtimeDatabaseService {
  final DatabaseReference _classesRef = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
        'https://mandela-capstone-default-rtdb.asia-southeast1.firebasedatabase.app',
  ).ref('classes');

  Stream<List<ClassSchedule>> getClassesStream() {
    return _classesRef.onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) {
        return <ClassSchedule>[];
      }

      final items = <ClassSchedule>[];
      value.forEach((key, entry) {
        if (entry is Map) {
          final data = Map<String, dynamic>.from(entry);
          items.add(ClassSchedule.fromMap(data, key.toString()));
        }
      });
      return items;
    });
  }

  Future<void> addClass(ClassSchedule schedule) async {
    final newRef = _classesRef.push();
    await newRef.set(schedule.toMap());
  }

  Future<void> updateClass(ClassSchedule schedule) async {
    await _classesRef.child(schedule.id).update(schedule.toMap());
  }

  Future<void> deleteClass(String id) async {
    await _classesRef.child(id).remove();
  }

  Future<void> seedDummyData() async {
    final snapshot = await _classesRef.get();
    if (snapshot.exists) return;

    for (final item in DummyData.classes) {
      await _classesRef.push().set(item.toMap());
    }
  }
}