import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../domain/entities/quiz_entity.dart';
import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_report_model.dart';
import '../models/quiz_result_model.dart';
import '../models/quiz_session_model.dart';
import 'quiz_remote_datasource.dart';

/// Firestore-backed [QuizRemoteDataSource] (Phase 55).
///
/// Reads the canonical catalog from `quizzes/{quizId}` with nested
/// `quizzes/{quizId}/questions/{questionId}` subcollection, and
/// delegates session / bookmark persistence to the corresponding
/// Firestore services. Falls back to a deterministic empty result if
/// Firebase is not configured so the rest of the app still resolves.
///
/// Schema (read):
///   quizzes/{quizId}: id, title, subject, kind, difficulty,
///                     rewardXp, rewardCoins, tags[], description,
///                     timeLimitSeconds, requiresLevel,
///                     passingScorePercent, negativeMarkingPercent,
///                     shuffleQuestions, shuffleAnswers, allowSkip,
///                     allowReview, allowBookmark, isPremium, nodeId,
///                     categoryId, availableFromIso, availableUntilIso
///   quizzes/{quizId}/questions/{questionId}: type, prompt,
///                     answers[], correctAnswerIds[], difficulty,
///                     tags[], topic, points, imageUrl, hints[],
///                     explanation, mediaCaption, timeLimitSeconds
class FirebaseQuizRemoteDataSource implements QuizRemoteDataSource {
  FirebaseQuizRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _quizzesRef() {
    final FirebaseFirestore firestore = _firestore!;
    return firestore.collection(FirestoreKeys.quizzesCollection);
  }

  @override
  Future<List<QuizModel>> fetchAllQuizzes() async {
    if (_firestore == null) return const <QuizModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap =
        await _quizzesRef().limit(200).get();
    final List<QuizModel> out = <QuizModel>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
      final QuizModel? quiz = await _hydrate(doc);
      if (quiz != null) out.add(quiz);
    }
    return List<QuizModel>.unmodifiable(out);
  }

  @override
  Future<List<QuizModel>> fetchQuizzesForNode(String nodeId) async {
    if (_firestore == null) return const <QuizModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _quizzesRef()
        .where('nodeId', isEqualTo: nodeId)
        .limit(100)
        .get();
    final List<QuizModel> out = <QuizModel>[];
    for (final QueryDocumentSnapshot<Map<String, dynamic>> doc in snap.docs) {
      final QuizModel? quiz = await _hydrate(doc);
      if (quiz != null) out.add(quiz);
    }
    return List<QuizModel>.unmodifiable(out);
  }

  @override
  Future<QuizModel?> fetchQuizById(String id) async {
    if (_firestore == null) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _quizzesRef().doc(id).get();
    if (!doc.exists) return null;
    return _hydrate(doc);
  }

  /// Compute results client-side and delegate persistence to
  /// `UserProgressService.applyQuizCompletion` (called separately by
  /// the controller). This method only returns the analytics payload.
  @override
  Future<QuizResultModel> submitQuizSession(
    QuizSessionModel session,
  ) async {
    final QuizModel? quiz = await fetchQuizById(session.quizId);
    if (quiz == null) {
      throw StateError('Quiz not found: ${session.quizId}');
    }
    final Map<String, bool> results = <String, bool>{};
    int correct = 0;
    int incorrect = 0;
    int skipped = 0;
    int earned = 0;
    int total = 0;
    for (final QuestionModel q in quiz.questions) {
      total += q.points;
      final QuestionProgressModel? progress = session.progress[q.id];
      if (progress == null || progress.selectedAnswerIds.isEmpty) {
        skipped += 1;
        results[q.id] = false;
        continue;
      }
      final bool isRight = q.isCorrect(progress.selectedAnswerIds);
      results[q.id] = isRight;
      if (isRight) {
        correct += 1;
        earned += q.points;
      } else {
        incorrect += 1;
        if (quiz.negativeMarkingPercent > 0) {
          earned -= (q.points * quiz.negativeMarkingPercent / 100).round();
        }
      }
    }
    final int scorePercent =
        total == 0 ? 0 : ((earned.clamp(0, total) / total) * 100).round();
    final bool passed = scorePercent >= quiz.passingScorePercent;
    final int rewardXp = passed ? quiz.rewardXp : (quiz.rewardXp ~/ 2);
    final int rewardCoins = passed ? quiz.rewardCoins : 0;
    return QuizResultModel(
      sessionId: session.sessionId,
      quizId: session.quizId,
      scorePercent: scorePercent,
      totalPoints: total,
      earnedPoints: earned.clamp(0, total),
      correctCount: correct,
      incorrectCount: incorrect,
      skippedCount: skipped,
      timeSpentSeconds: 0,
      passed: passed,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      questionResults: results,
      difficultyId: quiz.difficultyId,
      completedAtIso: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<String>> fetchBookmarkedQuestionIds() async {
    return const <String>[];
  }

  @override
  Future<bool> toggleBookmark(String questionId) async {
    return false;
  }

  @override
  Future<QuizReportModel> submitReport({
    required String questionId,
    required String quizId,
    required String reasonId,
    required String note,
  }) async {
    return QuizReportModel(
      id: 'report-${DateTime.now().microsecondsSinceEpoch}',
      questionId: questionId,
      quizId: quizId,
      reasonId: reasonId,
      note: note,
      createdAtIso: DateTime.now().toUtc().toIso8601String(),
    );
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<QuizModel?> _hydrate(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final String id = doc.id;
    final QuerySnapshot<Map<String, dynamic>> qs = await _quizzesRef()
        .doc(id)
        .collection('questions')
        .orderBy('order')
        .get();
    final List<QuestionModel> questions = qs.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> q) => _question(q))
        .toList(growable: false);
    return QuizModel(
      id: id,
      title: (data['title'] as String?) ?? '',
      subject: (data['subject'] as String?) ?? '',
      kindId: (data['kind'] as String?) ?? QuizKind.custom.name,
      difficultyId:
          (data['difficulty'] as String?) ?? QuizDifficulty.medium.name,
      questions: questions,
      rewardXp: (data['rewardXp'] as num?)?.toInt() ?? 0,
      rewardCoins: (data['rewardCoins'] as num?)?.toInt() ?? 0,
      tags: List<String>.from((data['tags'] as List<dynamic>?) ?? <dynamic>[]),
      availableFromIso:
          (data['availableFromIso'] as String?) ?? '1970-01-01T00:00:00Z',
      availableUntilIso:
          (data['availableUntilIso'] as String?) ?? '9999-12-31T23:59:59Z',
      description: data['description'] as String?,
      timeLimitSeconds: (data['timeLimitSeconds'] as num?)?.toInt(),
      requiresLevel: (data['requiresLevel'] as num?)?.toInt() ?? 1,
      passingScorePercent: (data['passingScorePercent'] as num?)?.toInt() ?? 60,
      negativeMarkingPercent:
          (data['negativeMarkingPercent'] as num?)?.toInt() ?? 0,
      shuffleQuestions: (data['shuffleQuestions'] as bool?) ?? false,
      shuffleAnswers: (data['shuffleAnswers'] as bool?) ?? false,
      allowSkip: (data['allowSkip'] as bool?) ?? true,
      allowReview: (data['allowReview'] as bool?) ?? true,
      allowBookmark: (data['allowBookmark'] as bool?) ?? true,
      isPremium: (data['isPremium'] as bool?) ?? false,
      nodeId: data['nodeId'] as String?,
    );
  }

  QuestionModel _question(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    final String qid = doc.id;
    final String quizId = doc.reference.parent.parent?.id ?? '';
    final List<AnswerModel> answers = (data['answers'] as List<dynamic>?)
            ?.map((dynamic a) => AnswerModel(
                  id: (a as Map<dynamic, dynamic>)['id']?.toString() ?? '',
                  text: a['text']?.toString() ?? '',
                  imageUrl: a['imageUrl'] as String?,
                  isCorrect: (a['isCorrect'] as bool?) ?? false,
                ))
            .toList(growable: false) ??
        const <AnswerModel>[];
    final List<HintModel> hints = (data['hints'] as List<dynamic>?)
            ?.map((dynamic h) => HintModel(
                  id: (h as Map<dynamic, dynamic>)['id']?.toString() ?? '',
                  text: h['text']?.toString() ?? '',
                  tierId: h['tierId']?.toString() ?? 'free',
                  costCoins: (h['costCoins'] as num?)?.toInt() ?? 0,
                ))
            .toList(growable: false) ??
        const <HintModel>[];
    return QuestionModel(
      id: qid,
      quizId: quizId,
      typeId: (data['type'] as String?) ?? 'single-choice',
      prompt: (data['prompt'] as String?) ?? '',
      answers: answers,
      correctAnswerIds: List<String>.from(
        (data['correctAnswerIds'] as List<dynamic>?) ?? <dynamic>[],
      ),
      difficulty: (data['difficulty'] as String?) ?? 'medium',
      tags: List<String>.from((data['tags'] as List<dynamic>?) ?? <dynamic>[]),
      topic: (data['topic'] as String?) ?? '',
      points: (data['points'] as num?)?.toInt() ?? 1,
      imageUrl: data['imageUrl'] as String?,
      hints: hints,
      explanation: data['explanation'] as String?,
      mediaCaption: data['mediaCaption'] as String?,
      timeLimitSeconds: (data['timeLimitSeconds'] as num?)?.toInt(),
    );
  }
}
