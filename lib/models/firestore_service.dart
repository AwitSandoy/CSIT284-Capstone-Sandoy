import 'package:cloud_firestore/cloud_firestore.dart';
import 'class_schedule.dart';
import 'dummy_data.dart';

class FirestoreService {
  final CollectionReference _classesRef =
      FirebaseFirestore.instance.collection('classes');

  // CREATE
  Future<void> addClass(ClassSchedule schedule) async {
    await _classesRef.add(schedule.toMap());
  }

  // READ
  Stream<List<ClassSchedule>> getClassesStream() {
    return _classesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ClassSchedule.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  // UPDATE
  Future<void> updateClass(ClassSchedule schedule) async {
    await _classesRef.doc(schedule.id).update(schedule.toMap());
  }

  // DELETE
  Future<void> deleteClass(String id) async {
    await _classesRef.doc(id).delete();
  }

  // SEED INITIAL DUMMY DATA TO FIRESTORE
  Future<void> seedDummyData() async {
    final existing = await _classesRef.limit(1).get();
    if (existing.docs.isEmpty) {
      for (final item in DummyData.classes) {
        await addClass(item);
      }
    }
  }
}