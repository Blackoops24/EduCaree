import 'package:educare/features/academics/data/models/class_model.dart';
import 'package:educare/features/academics/data/models/exam_model.dart';
import 'package:educare/features/academics/data/models/marks_model.dart';
import 'package:educare/features/academics/data/models/report_card_model.dart';
import 'package:educare/features/academics/data/models/section_model.dart';
import 'package:educare/features/academics/data/models/subject_model.dart';
import 'package:educare/features/academics/data/models/timetable_model.dart';
import 'package:educare/features/academics/data/services/academic_service.dart';

class AcademicRemoteDatasource {
  final AcademicService _academicService;

  AcademicRemoteDatasource(this._academicService);

  // Class Management
  Future<List<ClassModel>> fetchClasses() async {
    final response = await _academicService.get('/academics/classes');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(ClassModel.fromJson).toList();
  }

  Future<bool> createClass(ClassModel classModel) async {
    final response = await _academicService.post('/academics/classes', data: classModel.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> updateClass(ClassModel classModel) async {
    final response = await _academicService.put(
      '/academics/classes/${classModel.id}',
      data: classModel.toJson(),
    );
    return response.statusCode == 200;
  }

  Future<bool> deleteClass(int classId) async {
    final response = await _academicService.delete('/academics/classes/$classId');
    return response.statusCode == 204 || response.statusCode == 200;
  }

  // Section Management
  Future<List<SectionModel>> fetchSections(int classId) async {
    final response = await _academicService.get('/academics/classes/$classId/sections');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(SectionModel.fromJson).toList();
  }

  Future<bool> createSection(SectionModel sectionModel) async {
    final response = await _academicService.post('/academics/sections', data: sectionModel.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  Future<bool> assignClassTeacher(int sectionId, int teacherId) async {
    final response = await _academicService.post(
      '/academics/sections/$sectionId/assign-teacher',
      data: {'teacher_id': teacherId},
    );
    return response.statusCode == 200;
  }

  // Subject Management
  Future<List<SubjectModel>> fetchSubjects(int classId) async {
    final response = await _academicService.get('/academics/classes/$classId/subjects');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(SubjectModel.fromJson).toList();
  }

  Future<bool> createSubject(SubjectModel subjectModel) async {
    final response = await _academicService.post('/academics/subjects', data: subjectModel.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Timetable Management
  Future<List<TimetableModel>> fetchWeeklyTimetable(int sectionId) async {
    final response = await _academicService.get('/academics/sections/$sectionId/timetable');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(TimetableModel.fromJson).toList();
  }

  Future<List<TimetableModel>> fetchTeacherTimetable(int teacherId) async {
    final response = await _academicService.get('/academics/teachers/$teacherId/timetable');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(TimetableModel.fromJson).toList();
  }

  // Exam Management
  Future<List<ExamModel>> fetchExams() async {
    final response = await _academicService.get('/academics/exams');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(ExamModel.fromJson).toList();
  }

  Future<bool> createExam(ExamModel examModel) async {
    final response = await _academicService.post('/academics/exams', data: examModel.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Marks Management
  Future<List<MarksModel>> fetchMarks(int examId, int sectionId) async {
    final response =
        await _academicService.get('/academics/exams/$examId/sections/$sectionId/marks');
    final rawList = List<Map<String, dynamic>>.from(response.data as List<dynamic>);
    return rawList.map(MarksModel.fromJson).toList();
  }

  Future<bool> submitMarks(MarksModel marksModel) async {
    final response = await _academicService.post('/academics/marks', data: marksModel.toJson());
    return response.statusCode == 201 || response.statusCode == 200;
  }

  // Report Cards
  Future<ReportCardModel> fetchReportCard(int studentId, int classId) async {
    final response = await _academicService.get('/academics/students/$studentId/report-card');
    return ReportCardModel.fromJson(Map<String, dynamic>.from(response.data as Map<String, dynamic>));
  }

  Future<bool> generateReportCard(int classId) async {
    final response = await _academicService.post('/academics/report-cards/generate', data: {
      'class_id': classId,
    });
    return response.statusCode == 201 || response.statusCode == 200;
  }
}
