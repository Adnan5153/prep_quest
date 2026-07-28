import '../../../../shared/typedefs/result.dart';
import '../entities/quiz_report_entity.dart';
import '../repositories/quiz_repository.dart';

class ReportQuestion {
  const ReportQuestion(this._repository);

  final QuizRepository _repository;

  Future<Result<QuizReportEntity>> call({
    required String questionId,
    required String quizId,
    required QuizReportReason reason,
    required String note,
  }) {
    return _repository.reportQuestion(
      questionId: questionId,
      quizId: quizId,
      reason: reason,
      note: note,
    );
  }
}
