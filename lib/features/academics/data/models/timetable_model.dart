import 'package:educare/features/academics/domain/entities/timetable.dart';

class TimetableModel extends Timetable {
  const TimetableModel({
    required super.id,
    required super.classId,
    required super.sectionId,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.subjectId,
    required super.subjectName,
    super.teacherId,
    super.teacherName,
    super.roomNumber,
  });

  factory TimetableModel.fromJson(Map<String, dynamic> json) {
    return TimetableModel(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      sectionId: json['section_id'] as int,
      dayOfWeek: json['day_of_week'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      subjectId: json['subject_id'] as int,
      subjectName: json['subject_name'] as String,
      teacherId: json['teacher_id'] as int?,
      teacherName: json['teacher_name'] as String?,
      roomNumber: json['room_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'section_id': sectionId,
      'day_of_week': dayOfWeek,
      'start_time': startTime,
      'end_time': endTime,
      'subject_id': subjectId,
      'subject_name': subjectName,
      'teacher_id': teacherId,
      'teacher_name': teacherName,
      'room_number': roomNumber,
    };
  }
}
