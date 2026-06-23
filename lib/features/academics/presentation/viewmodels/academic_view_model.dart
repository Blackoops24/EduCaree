import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:educare/features/academics/domain/entities/class.dart';
import 'package:educare/features/academics/domain/entities/exam.dart';
import 'package:educare/features/academics/domain/entities/marks.dart';
import 'package:educare/features/academics/domain/entities/report_card.dart';
import 'package:educare/features/academics/domain/entities/section.dart';
import 'package:educare/features/academics/domain/entities/subject.dart';
import 'package:educare/features/academics/domain/entities/timetable.dart';
import 'package:educare/features/academics/domain/usecases/create_class_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_classes_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_exams_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_marks_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_report_card_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_sections_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_subjects_usecase.dart';
import 'package:educare/features/academics/domain/usecases/fetch_weekly_timetable_usecase.dart';

class AcademicState {
  final bool loading;
  final String? error;
  final List<Class> classes;
  final List<Section> sections;
  final List<Subject> subjects;
  final List<Timetable> timetables;
  final List<Exam> exams;
  final List<Marks> marks;
  final ReportCard? reportCard;

  const AcademicState({
    this.loading = false,
    this.error,
    this.classes = const [],
    this.sections = const [],
    this.subjects = const [],
    this.timetables = const [],
    this.exams = const [],
    this.marks = const [],
    this.reportCard,
  });

  AcademicState copyWith({
    bool? loading,
    String? error,
    List<Class>? classes,
    List<Section>? sections,
    List<Subject>? subjects,
    List<Timetable>? timetables,
    List<Exam>? exams,
    List<Marks>? marks,
    ReportCard? reportCard,
  }) {
    return AcademicState(
      loading: loading ?? this.loading,
      error: error,
      classes: classes ?? this.classes,
      sections: sections ?? this.sections,
      subjects: subjects ?? this.subjects,
      timetables: timetables ?? this.timetables,
      exams: exams ?? this.exams,
      marks: marks ?? this.marks,
      reportCard: reportCard ?? this.reportCard,
    );
  }
}

class AcademicViewModel extends StateNotifier<AcademicState> {
  final FetchClassesUseCase _fetchClassesUseCase;
  final CreateClassUseCase _createClassUseCase;
  final FetchSectionsUseCase _fetchSectionsUseCase;
  final FetchSubjectsUseCase _fetchSubjectsUseCase;
  final FetchWeeklyTimetableUseCase _fetchWeeklyTimetableUseCase;
  final FetchExamsUseCase _fetchExamsUseCase;
  final FetchMarksUseCase _fetchMarksUseCase;
  final FetchReportCardUseCase _fetchReportCardUseCase;

  AcademicViewModel(
    this._fetchClassesUseCase,
    this._createClassUseCase,
    this._fetchSectionsUseCase,
    this._fetchSubjectsUseCase,
    this._fetchWeeklyTimetableUseCase,
    this._fetchExamsUseCase,
    this._fetchMarksUseCase,
    this._fetchReportCardUseCase,
  ) : super(const AcademicState());

  Future<void> fetchClasses() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final classes = await _fetchClassesUseCase.execute();
      state = state.copyWith(classes: classes, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch classes');
    }
  }

  Future<void> createClass(Class classData) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final success = await _createClassUseCase.execute(classData);
      if (success) {
        await fetchClasses();
      } else {
        state = state.copyWith(loading: false, error: 'Failed to create class');
      }
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to create class');
    }
  }

  Future<void> fetchSections(int classId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final sections = await _fetchSectionsUseCase.execute(classId);
      state = state.copyWith(sections: sections, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch sections');
    }
  }

  Future<void> fetchSubjects(int classId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final subjects = await _fetchSubjectsUseCase.execute(classId);
      state = state.copyWith(subjects: subjects, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch subjects');
    }
  }

  Future<void> fetchWeeklyTimetable(int sectionId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final timetables = await _fetchWeeklyTimetableUseCase.execute(sectionId);
      state = state.copyWith(timetables: timetables, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch timetable');
    }
  }

  Future<void> fetchExams() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final exams = await _fetchExamsUseCase.execute();
      state = state.copyWith(exams: exams, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch exams');
    }
  }

  Future<void> fetchMarks(int examId, int sectionId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final marks = await _fetchMarksUseCase.execute(examId, sectionId);
      state = state.copyWith(marks: marks, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch marks');
    }
  }

  Future<void> fetchReportCard(int studentId, int classId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final reportCard = await _fetchReportCardUseCase.execute(studentId, classId);
      state = state.copyWith(reportCard: reportCard, loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: 'Failed to fetch report card');
    }
  }
}
