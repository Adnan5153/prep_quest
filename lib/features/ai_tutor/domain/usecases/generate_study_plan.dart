import '../../../../shared/typedefs/result.dart';
import '../entities/study_plan.dart';
import '../repositories/ai_tutor_repository.dart';

/// Builds a multi-day study plan for a subject with a daily time budget.
class GenerateStudyPlan {
  const GenerateStudyPlan(this._repository);

  final AiTutorRepository _repository;

  Future<Result<StudyPlan>> call({
    required String subject,
    int daysAhead = 7,
    int minutesPerDay = 45,
  }) {
    return _repository.generateStudyPlan(
      subject: subject,
      daysAhead: daysAhead,
      minutesPerDay: minutesPerDay,
    );
  }
}