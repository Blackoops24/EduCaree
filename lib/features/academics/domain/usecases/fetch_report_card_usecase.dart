import 'package:educare/features/academics/domain/entities/report_card.dart';
import 'package:educare/features/academics/domain/repositories/academic_repository.dart';

class FetchReportCardUseCase {
  final AcademicRepository _repository;

  FetchReportCardUseCase(this._repository);

  Future<ReportCard> execute(int studentId, int classId) {
    return _repository.fetchReportCard(studentId, classId);
  }
}
