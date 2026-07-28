import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/domain/entities/quiz_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_result_entity.dart';
import '../../../quiz_engine/domain/entities/quiz_session_entity.dart';
import '../../domain/entities/quiz_performance_entity.dart';
import '../../domain/entities/rank_progress.dart';
import '../../domain/entities/star_rating.dart';
import '../../domain/entities/topic_performance_entity.dart';
import '../../domain/repositories/quiz_results_repository.dart';
import '../../presentation/utils/topic_analyzer.dart';
import '../datasources/quiz_results_remote_datasource.dart';

/// Concrete repository that assembles [QuizPerformanceEntity] from a
/// freshly graded session plus the canonical quiz definition.
class QuizResultsRepositoryImpl implements QuizResultsRepository {
  QuizResultsRepositoryImpl(this._remote);

  final QuizResultsRemoteDataSource _remote;
  final TopicAnalyzer _topicAnalyzer = const TopicAnalyzer();

  @override
  Future<Result<QuizPerformanceEntity>> getQuizPerformance({
    required String quizId,
    required QuizSessionEntity session,
  }) async {
    try {
      final QuizEntity? quiz = await _remote.fetchQuizDefinition(quizId);
      final QuizResultEntity result = await _remote.submitSession(session);
      if (quiz == null) {
        return const Result<QuizPerformanceEntity>.failure(
          _QuizMissingFailure(),
        );
      }
      final QuizPerformanceEntity performance =
          _assemble(result: result, quiz: quiz);
      performance.session = session;
      return Result<QuizPerformanceEntity>.success(performance);
    } catch (error, stackTrace) {
      return Result<QuizPerformanceEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<QuizSessionEntity>> startRetry(String quizId) async {
    try {
      final QuizSessionEntity fresh = await _remote.startRetrySession(quizId);
      return Result<QuizSessionEntity>.success(fresh);
    } catch (error, stackTrace) {
      return Result<QuizSessionEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  QuizPerformanceEntity _assemble({
    required QuizResultEntity result,
    required QuizEntity quiz,
  }) {
    final int answered = result.answeredCount;
    final int total = result.questionResults.length;
    final int completion = total == 0 ? 0 : ((answered / total) * 100).round();
    final int averageTime = total == 0
        ? 0
        : (result.timeSpentSeconds / total).round();

    final List<TopicPerformanceEntity> topics = _topicAnalyzer.compute(
      quiz: quiz,
      questionResults: result.questionResults,
    );

    final StarRating stars = StarRating.fromScore(result.scorePercent);
    final RankProgress rank = RankProgress(
      rankBefore: 'Bronze I',
      rankAfter: result.passed ? 'Bronze II' : 'Bronze I',
      progressToNextRank: (result.scorePercent / 100).clamp(0.0, 1.0),
    );

    return QuizPerformanceEntity(
      result: result,
      topicBreakdown: topics,
      averageTimePerQuestionSeconds: averageTime,
      completionPercent: completion,
      stars: stars,
      rankProgress: rank,
      motivationalMessage: _motivationalFor(result.scorePercent, result.passed),
      performanceSummary:
          '${result.correctCount}/$total correct • ${result.skippedCount} skipped',
    );
  }

  String _motivationalFor(int scorePercent, bool passed) {
    if (scorePercent >= 95) return 'Flawless victory! Every answer landed.';
    if (scorePercent >= 80) return 'Outstanding! You crushed this quiz.';
    if (scorePercent >= 60) {
      return passed
          ? 'Solid run — keep pushing forward.'
          : 'So close! A small refresh and you will pass next time.';
    }
    if (scorePercent >= 40) {
      return 'You are warming up — practice the weak topics below.';
    }
    return 'No worries. Review the explanations and try again.';
  }
}

class _QuizMissingFailure extends Failure {
  const _QuizMissingFailure()
      : super('The quiz could not be found for analytics.');
}
