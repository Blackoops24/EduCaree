import 'package:educare/features/academics/domain/entities/timetable.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchWeeklyTimetableUseCase {
  final AcademicRepository _repository;

  FetchWeeklyTimetableUseCase(this._repository);

  Future<List<Timetable>> execute(int sectionId) {
    return _repository.fetchWeeklyTimetable(sectionId);
  }
}
