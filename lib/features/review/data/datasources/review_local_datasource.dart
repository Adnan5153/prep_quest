import '../../../quiz_engine/data/datasources/mock_quiz_remote_datasource.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/question_model.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import '../models/review_question_model.dart';
import '../models/review_session_model.dart';
import 'review_remote_datasource.dart';

/// In-memory implementation of [ReviewRemoteDataSource].
///
/// Seeds three past review sessions derived from the live mock quiz
/// data so the Review screen has realistic content immediately.
/// Bookmark state is read from the shared mock quiz DS to keep the
/// feature consistent with the Quiz Engine.
class ReviewLocalDataSource implements ReviewRemoteDataSource {
  ReviewLocalDataSource({QuizRemoteDataSource? quizSource})
      : _quizSource = quizSource ?? MockQuizRemoteDataSource();

  final QuizRemoteDataSource _quizSource;
  final List<ReviewSessionModel> _sessions = <ReviewSessionModel>[];
  final Map<String, String> _aiExplanations = <String, String>{};
  bool _seeded = false;

  @override
  Future<List<ReviewSessionModel>> fetchAllSessions() async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final List<ReviewSessionModel> ordered = List<ReviewSessionModel>.of(_sessions)
      ..sort((ReviewSessionModel a, ReviewSessionModel b) =>
          b.completedAtIso.compareTo(a.completedAtIso));
    return List<ReviewSessionModel>.unmodifiable(ordered);
  }

  @override
  Future<ReviewSessionModel?> fetchSessionById(String sessionId) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 120));
    for (final ReviewSessionModel s in _sessions) {
      if (s.sessionId == sessionId) return s;
    }
    return null;
  }

  @override
  Future<String> fetchAiExplanation(String questionId) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return _aiExplanations[questionId] ??
        'We could not generate a deeper explanation for this question right now. '
            'Review the answer options above to refresh the concept.';
  }

  @override
  Future<void> persistSession(ReviewSessionModel session) async {
    await _ensureSeeded();
    await Future<void>.delayed(const Duration(milliseconds: 80));
    _sessions.add(session);
  }

  Future<void> _ensureSeeded() async {
    if (_seeded) return;
    final List<QuizModel> quizzes = await _quizSource.fetchAllQuizzes();
    _sessions.addAll(_buildSeedSessions(quizzes));
    for (final ReviewSessionModel s in _sessions) {
      for (final ReviewQuestionModel q in s.questions) {
        final String? base = q.question.explanation;
        if (base != null && base.isNotEmpty) {
          _aiExplanations[q.question.id] = _enrichExplanation(base);
        }
      }
    }
    _seeded = true;
  }

  String _enrichExplanation(String base) {
    return '$base\n\nThink of it this way: connect the idea to one real-world '
        'example, then write the rule in your own words. Active recall is the '
        'fastest way to lock the concept in for the BCS exam.';
  }

  List<ReviewSessionModel> _buildSeedSessions(List<QuizModel> quizzes) {
    if (quizzes.isEmpty) return <ReviewSessionModel>[];
    final DateTime now = DateTime.now();
    final List<ReviewSessionModel> out = <ReviewSessionModel>[];

    out.add(_buildSession(
      quiz: quizzes.first,
      offset: const Duration(days: 1, hours: 5),
      baseline: now,
      correctRate: 0.66,
    ));
    if (quizzes.length > 1) {
      out.add(_buildSession(
        quiz: quizzes[1],
        offset: const Duration(days: 7, hours: 2),
        baseline: now,
        correctRate: 0.5,
      ));
    }
    if (quizzes.length > 2) {
      out.add(_buildSession(
        quiz: quizzes[2],
        offset: const Duration(days: 14, hours: 4),
        baseline: now,
        correctRate: 0.34,
      ));
    }
    return out;
  }

  ReviewSessionModel _buildSession({
    required QuizModel quiz,
    required Duration offset,
    required DateTime baseline,
    required double correctRate,
  }) {
    final DateTime completedAt = baseline.subtract(offset);
    final DateTime startedAt =
        completedAt.subtract(const Duration(minutes: 12));

    final List<QuestionModel> all = quiz.questions;
    final int targetCorrect = (all.length * correctRate).round();
    final List<ReviewQuestionModel> attempts = <ReviewQuestionModel>[];
    int correctSoFar = 0;
    int incorrectSoFar = 0;

    for (int i = 0; i < all.length; i++) {
      final QuestionModel q = all[i];
      final List<String> correctIds =
          List<String>.of(q.correctAnswerIds);

      final bool makeCorrect = correctSoFar < targetCorrect;
      final bool canBeIncorrect = incorrectSoFar < (all.length - targetCorrect);
      final List<String> selected;
      final bool wasCorrect;

      if (makeCorrect) {
        selected = correctIds;
        wasCorrect = true;
        correctSoFar += 1;
      } else if (canBeIncorrect) {
        final String wrongId = q.answers
            .firstWhere(
              (AnswerModel a) =>
                  a.id != (correctIds.isNotEmpty ? correctIds.first : ''),
              orElse: () => const AnswerModel(id: '', text: ''),
            )
            .id;
        if (wrongId.isEmpty) {
          selected = <String>[];
          wasCorrect = false;
        } else {
          selected = <String>[wrongId];
          wasCorrect = false;
          incorrectSoFar += 1;
        }
      } else {
        selected = <String>[];
        wasCorrect = false;
      }

      attempts.add(ReviewQuestionModel(
        question: q,
        selectedAnswerIds: selected,
        wasCorrect: wasCorrect,
        attemptedAtIso: completedAt.toIso8601String(),
        quizTitle: quiz.title,
        quizId: quiz.id,
        timeSpentSeconds: 28 + (i * 6),
        isBookmarked: (i == 0 || i == all.length - 1) && !wasCorrect,
        isSkipped: selected.isEmpty,
      ));
    }

    return ReviewSessionModel(
      sessionId: 'session-${quiz.id}-${offset.inHours}',
      quiz: quiz,
      questions: attempts,
      startedAtIso: startedAt.toIso8601String(),
      completedAtIso: completedAt.toIso8601String(),
    );
  }
}