import 'package:educare/features/academics/data/datasources/academic_remote_datasource.dart';
import 'package:educare/features/academics/data/models/class_model.dart';
import 'package:educare/features/academics/data/models/exam_model.dart';
import 'package:educare/features/academics/data/models/marks_model.dart';
import 'package:educare/features/academics/data/models/section_model.dart';
import 'package:educare/features/academics/data/models/subject_model.dart';
import 'package:educare/features/academics/domain/entities/class.dart';
import 'package:educare/features/academics/domain/entities/exam.dart';
import 'package:educare/features/academics/domain/entities/marks.dart';
import 'package:educare/features/academics/domain/entities/report_card.dart';
import 'package:educare/features/academics/domain/entities/section.dart';
import 'package:educare/features/academics/domain/entities/subject.dart';
import 'package:educare/features/academics/domain/entities/timetable.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class AcademicRepositoryImpl implements AcademicRepository {
  final AcademicRemoteDatasource _datasource;

  AcademicRepositoryImpl(this._datasource);

  @override
  Future<List<Class>> fetchClasses() {
    return _datasource.fetchClasses();
  }

  @override
  Future<bool> createClass(Class classData) {
    final classModel = ClassModel(
      id: classData.id,
      name: classData.name,
      description: classData.description,
      totalStrength: classData.totalStrength,
      createdDate: classData.createdDate,
    );
    return _datasource.createClass(classModel);
  }

  @override
  Future<bool> updateClass(Class classData) {
    final classModel = ClassModel(
      id: classData.id,
      name: classData.name,
      description: classData.description,
      totalStrength: classData.totalStrength,
      createdDate: classData.createdDate,
    );
    return _datasource.updateClass(classModel);
  }

  @override
  Future<bool> deleteClass(int classId) {
    return _datasource.deleteClass(classId);
  }

  @override
  Future<List<Section>> fetchSections(int classId) {
    return _datasource.fetchSections(classId);
  }

  @override
  Future<bool> createSection(Section sectionData) {
    return _datasource.createSection(
      SectionModel(
        id: sectionData.id,
        classId: sectionData.classId,
        sectionName: sectionData.sectionName,
        strength: sectionData.strength,
        classTeacherId: sectionData.classTeacherId,
        classTeacherName: sectionData.classTeacherName,
      ),
    );
  }

  @override
  Future<bool> assignClassTeacher(int sectionId, int teacherId) {
    return _datasource.assignClassTeacher(sectionId, teacherId);
  }

  @override
  Future<List<Subject>> fetchSubjects(int classId) {
    return _datasource.fetchSubjects(classId);
  }

  @override
  Future<bool> createSubject(Subject subjectData) {
    return _datasource.createSubject(
      SubjectModel(
        id: subjectData.id,
        code: subjectData.code,
        name: subjectData.name,
        description: subjectData.description,
        credits: subjectData.credits,
        classId: subjectData.classId,
      ),
    );
  }

  @override
  Future<List<Timetable>> fetchWeeklyTimetable(int sectionId) {
    return _datasource.fetchWeeklyTimetable(sectionId);
  }

  @override
  Future<List<Timetable>> fetchTeacherTimetable(int teacherId) {
    return _datasource.fetchTeacherTimetable(teacherId);
  }

  @override
  Future<List<Exam>> fetchExams() {
    return _datasource.fetchExams();
  }

  @override
  Future<bool> createExam(Exam examData) {
    final examModel = ExamModel(
      id: examData.id,
      examName: examData.examName,
      examType: examData.examType,
      startDate: examData.startDate,
      endDate: examData.endDate,
      totalMarks: examData.totalMarks,
      passingMarks: examData.passingMarks,
    );
    return _datasource.createExam(examModel);
  }

  @override
  Future<List<Marks>> fetchMarks(int examId, int sectionId) {
    return _datasource.fetchMarks(examId, sectionId);
  }

  @override
  Future<bool> submitMarks(Marks marksData) {
    final marksModel = MarksModel(
      id: marksData.id,
      studentId: marksData.studentId,
      studentName: marksData.studentName,
      examId: marksData.examId,
      subjectId: marksData.subjectId,
      subjectName: marksData.subjectName,
      obtainedMarks: marksData.obtainedMarks,
      totalMarks: marksData.totalMarks,
      percentage: marksData.percentage,
      grade: marksData.grade,
    );
    return _datasource.submitMarks(marksModel);
  }

  @override
  Future<ReportCard> fetchReportCard(int studentId, int classId) {
    return _datasource.fetchReportCard(studentId, classId);
  }

  @override
  Future<bool> generateReportCard(int classId) {
    return _datasource.generateReportCard(classId);
  }
}
