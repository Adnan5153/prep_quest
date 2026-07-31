import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import '../models/review_question_model.dart';
import '../models/review_session_model.dart';
import 'review_remote_datasource.dart';

/// Firestore-backed [ReviewRemoteDataSource] (Phase 55).
///
/// Reads completed quiz sessions from
/// `users/{uid}/quiz_sessions/{sessionId}` (populated by
/// `UserProgressService.applyQuizCompletion`) and joins each session
/// with the canonical quiz definition via the injected
/// [QuizRemoteDataSource] (a [FirebaseQuizRemoteDataSource] in
/// production). Falls back to an empty result when Firebase is not
/// configured so the rest of the app still resolves.
///
/// Schema (read):
///   users/{uid}/quiz_sessions/{sessionId}: sessionId, quizId,
///     categoryId, scorePercent, startedAt, completedAt,
///     perQuestion{} (keyed by questionId: selectedAnswerIds[],
///     status, timeSpentSeconds, isBookmarked, wasCorrect)
class FirebaseReviewRemoteDataSource implements ReviewRemoteDataSource {
  FirebaseReviewRemoteDataSource({
    required String uid,
    required QuizRemoteDataSource quizSource,
    FirebaseFirestore? firestore,
  })  : _uid = uid,
        _quizSource = quizSource,
        _firestore = firestore ?? FirebaseConfig.firestore;

  final String _uid;
  final QuizRemoteDataSource _quizSource;
  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _sessionsRef() {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(_uid)
        .collection(FirestoreKeys.quizSessionsSubcollection);
  }

  @override
  Future<List<ReviewSessionModel>> fetchAllSessions() async {
    if (_firestore == null) return const <ReviewSessionModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _sessionsRef()
        .orderBy('completedAt', descending: true)
        .limit(50)
        .get();
    final List<ReviewSessionModel> out = <ReviewSessionModel>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
      final ReviewSessionModel? session = await _hydrate(doc);
      if (session != null) out.add(session);
    }
    return List<ReviewSessionModel>.unmodifiable(out);
  }

  @override
  Future<ReviewSessionModel?> fetchSessionById(String sessionId) async {
    if (_firestore == null) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _sessionsRef().doc(sessionId).get();
    if (!doc.exists) return null;
    return _hydrate(doc);
  }

  @override
  Future<String> fetchAiExplanation(String questionId) async {
    // AI explanations are generated on-demand by Gemini in the
    // `ai_tutor` feature. The Review screen's "Get AI explanation"
    // button should route to the tutor — this method returns a
    // fallback string when called without a backing service so the
    // session code paths still resolve.
    return 'Open the AI Tutor to get a deeper explanation for this question.';
  }

  @override
  Future<void> persistSession(ReviewSessionModel session) async {
    // Persistence is owned by `UserProgressService.applyQuizCompletion`
    // which writes the canonical quiz_sessions doc atomically. This
    // method is a no-op for the Firestore implementation; callers
    // should funnel through `UserProgressService` instead.
    return;
  }

  Future<ReviewSessionModel?> _hydrate(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final String sessionId = doc.id;
    final String quizId = (data['quizId'] as String?) ?? '';
    if (quizId.isEmpty) return null;
    final QuizModel? quiz = await _quizSource.fetchQuizById(quizId);
    if (quiz == null) return null;
    final Map<String, dynamic> perQuestion =
        (data['perQuestion'] as Map<dynamic, dynamic>?)
                ?.cast<String, dynamic>() ??
            <String, dynamic>{};
    final List<ReviewQuestionModel> questions = <ReviewQuestionModel>[];
    for (int i = 0; i < quiz.questions.length; i++) {
      final dynamic q = quiz.questions[i];
      final String qid = q.id;
      final Map<String, dynamic> p =
          (perQuestion[qid] as Map<dynamic, dynamic>?)
                  ?.cast<String, dynamic>() ??
              <String, dynamic>{};
      final List<String> selected = List<String>.from(
        (p['selectedAnswerIds'] as List<dynamic>?) ?? <dynamic>[],
      );
      final String status = (p['status'] as String?) ?? 'unanswered';
      questions.add(
        ReviewQuestionModel(
          question: q,
          selectedAnswerIds: selected,
          wasCorrect: (p['wasCorrect'] as bool?) ?? false,
          attemptedAtIso:
              (data['completedAt'] as String?) ??
              DateTime.now().toUtc().toIso8601String(),
          quizTitle: quiz.title,
          quizId: quizId,
          timeSpentSeconds: (p['timeSpentSeconds'] as num?)?.toInt() ?? 0,
          isBookmarked: (p['isBookmarked'] as bool?) ?? false,
          isSkipped:
              status == 'skipped' || (selected.isEmpty && status != 'answered'),
        ),
      );
    }
    return ReviewSessionModel(
      sessionId: sessionId,
      quiz: quiz,
      questions: questions,
      startedAtIso:
          (data['startedAt'] as String?) ??
          DateTime.now().toUtc().toIso8601String(),
      completedAtIso:
          (data['completedAt'] as String?) ??
          DateTime.now().toUtc().toIso8601String(),
    );
  }
}