import 'package:educare/features/students/domain/entities/alumni_record.dart';

class AlumniRecordModel extends AlumniRecord {
  const AlumniRecordModel({
    required super.id,
    required super.name,
    required super.passedOutYear,
    required super.course,
    required super.email,
  });

  factory AlumniRecordModel.fromJson(Map<String, dynamic> json) {
    return AlumniRecordModel(
      id: json['id'] as int,
      name: json['name'] as String,
      passedOutYear: json['passed_out_year'] as String,
      course: json['course'] as String,
      email: json['email'] as String,
    );
  }
}
