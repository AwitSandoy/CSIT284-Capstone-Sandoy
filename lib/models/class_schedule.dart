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

  Map<String, dynamic> toMap() {
    return {
      'subjectCode': subjectCode,
      'subjectName': subjectName,
      'dayOfWeek': dayOfWeek,
      'startTime': startTime,
      'endTime': endTime,
      'room': room,
      'instructor': instructor,
    };
  }

  factory ClassSchedule.fromMap(Map<String, dynamic> map, String id) {
    return ClassSchedule(
      id: id,
      subjectCode: map['subjectCode'] ?? '',
      subjectName: map['subjectName'] ?? '',
      dayOfWeek: map['dayOfWeek'] ?? '',
      startTime: map['startTime'] ?? '',
      endTime: map['endTime'] ?? '',
      room: map['room'] ?? '',
      instructor: map['instructor'] ?? '',
    );
  }
}