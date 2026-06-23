import 'package:educare/features/academics/domain/entities/class.dart';
import 'package:educare/features/academics/domain/entities/exam.dart';
import 'package:educare/features/academics/domain/entities/marks.dart';
import 'package:educare/features/academics/domain/entities/report_card.dart';
import 'package:educare/features/academics/domain/entities/section.dart';
import 'package:educare/features/academics/domain/entities/subject.dart';
import 'package:educare/features/academics/domain/entities/timetable.dart';

abstract class AcademicRepository {
  Future<List<Class>> fetchClasses();
  Future<bool> createClass(Class classData);
  Future<bool> updateClass(Class classData);
  Future<bool> deleteClass(int classId);

  Future<List<Section>> fetchSections(int classId);
  Future<bool> createSection(Section sectionData);
  Future<bool> assignClassTeacher(int sectionId, int teacherId);

  Future<List<Subject>> fetchSubjects(int classId);
  Future<bool> createSubject(Subject subjectData);

  Future<List<Timetable>> fetchWeeklyTimetable(int sectionId);
  Future<List<Timetable>> fetchTeacherTimetable(int teacherId);

  Future<List<Exam>> fetchExams();
  Future<bool> createExam(Exam examData);

  Future<List<Marks>> fetchMarks(int examId, int sectionId);
  Future<bool> submitMarks(Marks marksData);

  Future<ReportCard> fetchReportCard(int studentId, int classId);
  Future<bool> generateReportCard(int classId);
}
