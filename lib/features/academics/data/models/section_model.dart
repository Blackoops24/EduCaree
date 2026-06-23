import 'package:educare/features/academics/domain/entities/section.dart';

class SectionModel extends Section {
  const SectionModel({
    required super.id,
    required super.classId,
    required super.sectionName,
    required super.strength,
    super.classTeacherId,
    super.classTeacherName,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'] as int,
      classId: json['class_id'] as int,
      sectionName: json['section_name'] as String,
      strength: json['strength'] as int,
      classTeacherId: json['class_teacher_id'] as int?,
      classTeacherName: json['class_teacher_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'class_id': classId,
      'section_name': sectionName,
      'strength': strength,
      'class_teacher_id': classTeacherId,
      'class_teacher_name': classTeacherName,
    };
  }
}
