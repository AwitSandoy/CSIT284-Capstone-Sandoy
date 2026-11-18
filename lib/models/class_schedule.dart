class ClassSchedule {
  final String id;
  final String subjectCode;
  final String subjectName;
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final String room;
  final String instructor;

  ClassSchedule({
    required this.id,
    required this.subjectCode,
    required this.subjectName,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.room,
    required this.instructor,
  });
}