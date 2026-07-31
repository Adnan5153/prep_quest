import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/errors/error_handler.dart';
import '../../../../core/security/auth_precondition.dart';
import '../../../../shared/typedefs/result.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../domain/entities/review_question_entity.dart';
import '../../domain/entities/review_session_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/firebase_review_remote_datasource.dart';
import '../datasources/review_local_datasource.dart';
import '../datasources/review_remote_datasource.dart';
import '../models/review_question_model.dart';
import '../models/review_session_model.dart';

/// Concrete repository that delegates to a [ReviewRemoteDataSource]
/// and the canonical quiz data source for bookmark state. All
/// exceptions are mapped through [ErrorHandler.map] so callers see a
/// uniform [Failure] vocabulary.
///
/// Phase 51 — `toggleBookmark` enforces an authenticated precondition
/// via [AuthGuard] before delegating to the remote data source.
///
/// Phase 55 — production defaults to the Firestore-backed
/// [FirebaseReviewRemoteDataSource]; the [ReviewLocalDataSource] mock
/// only activates when Firebase is not configured (offline dev /
/// tests).
class ReviewRepositoryImpl implements ReviewRepository {
  ReviewRepositoryImpl({
    required ReviewRemoteDataSource remote,
    required QuizRemoteDataSource quizSource,
    Ref? ref,
  })  : _remote = remote,
        _quizSource = quizSource,
        _guard = ref == null ? null : AuthGuard(ref);

  /// Convenience factory that wires the canonical data sources.
  /// In production (Firebase configured) the remote is the
  /// [FirebaseReviewRemoteDataSource] backed by
  /// `users/{uid}/quiz_sessions` and joined with the canonical quiz
  /// data. Otherwise the legacy local mock satisfies the contract
  /// so the review screen can still render in offline dev / tests.
  factory ReviewRepositoryImpl.withDefaults({
    required QuizRemoteDataSource quizSource,
    String? uid,
  }) {
    if (FirebaseConfig.isPlatformConfigured && uid != null && uid.isNotEmpty) {
      return ReviewRepositoryImpl(
        remote: FirebaseReviewRemoteDataSource(
          uid: uid,
          quizSource: quizSource,
        ),
        quizSource: quizSource,
      );
    }
    return ReviewRepositoryImpl(
      remote: ReviewLocalDataSource(),
      quizSource: quizSource,
    );
  }

  final ReviewRemoteDataSource _remote;
  final QuizRemoteDataSource _quizSource;
  final AuthGuard? _guard;

  @override
  Future<Result<List<ReviewSessionEntity>>> getAllReviewSessions() async {
    try {
      final List<ReviewSessionModel> models = await _remote.fetchAllSessions();
      return Result.success(
        List<ReviewSessionEntity>.unmodifiable(
          models.map((ReviewSessionModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<ReviewSessionEntity?>> getReviewSessionById(
    String sessionId,
  ) async {
    try {
      final ReviewSessionModel? model = await _remote.fetchSessionById(sessionId);
      if (model == null) {
        return const Result<ReviewSessionEntity?>.success(null);
      }
      return Result.success(model.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getBookmarkedQuestions() async {
    try {
      final List<String> ids = await _quizSource.fetchBookmarkedQuestionIds();
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final Set<String> idSet = ids.toSet();
      final List<ReviewQuestionEntity> bookmarked = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          if (idSet.contains(q.question.id) || q.isBookmarked) {
            bookmarked.add(q.toEntity());
          }
        }
      }
      return Result.success(List<ReviewQuestionEntity>.unmodifiable(bookmarked));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getRecentQuestions({
    int limit = 20,
  }) async {
    try {
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final List<ReviewQuestionEntity> flat = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          flat.add(q.toEntity());
        }
      }
      flat.sort(
        (ReviewQuestionEntity a, ReviewQuestionEntity b) =>
            b.attemptedAt.compareTo(a.attemptedAt),
      );
      return Result.success(
        List<ReviewQuestionEntity>.unmodifiable(
          flat.take(limit).toList(growable: false),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<ReviewQuestionEntity>>> getQuestionsForFilter(
    ReviewFilter filter,
  ) async {
    try {
      final List<ReviewSessionModel> all = await _remote.fetchAllSessions();
      final List<ReviewQuestionEntity> flat = <ReviewQuestionEntity>[];
      for (final ReviewSessionModel session in all) {
        for (final ReviewQuestionModel q in session.questions) {
          final ReviewQuestionEntity entity = q.toEntity();
          switch (filter) {
            case ReviewFilter.all:
              flat.add(entity);
              break;
            case ReviewFilter.correct:
              if (entity.wasCorrect) flat.add(entity);
              break;
            case ReviewFilter.incorrect:
              if (!entity.wasCorrect && entity.hasAnswered) flat.add(entity);
              break;
            case ReviewFilter.bookmarked:
              if (entity.isBookmarked) flat.add(entity);
              break;
          }
        }
      }
      flat.sort(
        (ReviewQuestionEntity a, ReviewQuestionEntity b) =>
            b.attemptedAt.compareTo(a.attemptedAt),
      );
      return Result.success(List<ReviewQuestionEntity>.unmodifiable(flat));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<String>> getAiExplanationForQuestion(String questionId) async {
    try {
      final String explanation = await _remote.fetchAiExplanation(questionId);
      return Result.success(explanation);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> toggleBookmark(String questionId) async {
    try {
      _guard?.assertAuthenticated();
      final bool added = await _quizSource.toggleBookmark(questionId);
      return Result.success(added);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> isBookmarked(String questionId) async {
    try {
      final List<String> ids = await _quizSource.fetchBookmarkedQuestionIds();
      return Result.success(ids.contains(questionId));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }
}