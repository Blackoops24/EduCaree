import 'package:educare/features/academics/domain/entities/class.dart';

class ClassModel extends Class {
  const ClassModel({
    required super.id,
    required super.name,
    required super.description,
    required super.totalStrength,
    required super.createdDate,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      totalStrength: json['total_strength'] as int,
      createdDate: json['created_date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'total_strength': totalStrength,
      'created_date': createdDate,
    };
  }
}
