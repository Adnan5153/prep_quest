import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_handler.dart';
import '../../../../core/services/statistics_service.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/study_statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';
import '../../domain/entities/user_statistics_entity.dart';
import '../../domain/repositories/statistics_repository.dart';
import '../../domain/services/statistics_aggregator.dart';

/// Concrete repository — wraps [StatisticsService] and adapts its
/// realtime API to the [StatisticsRepository] contract. The
/// aggregator service rebuilds the existing legacy
/// [StatisticsEntity] shape from the new [UserStatisticsEntity] +
/// [CategoryStatisticsEntity] rows so every current use case /
/// controller / widget keeps compiling without modification.
class StatisticsRepositoryImpl implements StatisticsRepository {
  StatisticsRepositoryImpl({
    required StatisticsService service,
    StatisticsAggregator? aggregator,
  })  : _service = service,
        _aggregator = aggregator ?? const StatisticsAggregator();

  final StatisticsService _service;
  final StatisticsAggregator _aggregator;

  // ---------------------------------------------------------------------------
  // Legacy one-shot API — preserved verbatim so every existing use
  // case compiles unchanged. The implementation snapshots the
  // current realtime state, then rebuilds the legacy shapes.
  // ---------------------------------------------------------------------------

  @override
  Future<Result<StatisticsEntity>> getStatistics() async {
    try {
      final StatisticsSnapshot snap = await snapshot('');
      return Result<StatisticsEntity>.success(
        _aggregator.toStatisticsEntity(
          user: snap.user,
          categories: snap.categories,
        ),
      );
    } catch (error, stackTrace) {
      return Result<StatisticsEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<StudyStatisticsEntity>> getStudyStatistics() async {
    try {
      final StatisticsSnapshot snap = await snapshot('');
      return Result<StudyStatisticsEntity>.success(
        _aggregator.toStudyStatisticsEntity(snap.user),
      );
    } catch (error, stackTrace) {
      return Result<StudyStatisticsEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getAccuracyStatistics() async {
    try {
      final StatisticsSnapshot snap = await snapshot('');
      return Result<List<SubjectStatisticsEntity>>.success(
        _aggregator.toSubjectBreakdown(snap.categories),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getWeakSubjects() async {
    try {
      final StatisticsSnapshot snap = await snapshot('');
      return Result<List<SubjectStatisticsEntity>>.success(
        _aggregator.toWeakSubjects(snap.categories),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<SubjectStatisticsEntity>>> getStrongSubjects() async {
    try {
      final StatisticsSnapshot snap = await snapshot('');
      return Result<List<SubjectStatisticsEntity>>.success(
        _aggregator.toStrongSubjects(snap.categories),
      );
    } catch (error, stackTrace) {
      return Result<List<SubjectStatisticsEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Realtime API (Phase 43).
  // ---------------------------------------------------------------------------

  @override
  Stream<StatisticsSnapshot> watch(String uid) {
    if (uid.isEmpty) {
      return Stream<StatisticsSnapshot>.value(StatisticsSnapshot.empty);
    }
    final Stream<UserStatisticsEntity> userStream = _service.watch(uid);
    final Stream<List<CategoryStatisticsEntity>> categoryStream =
        _service.watchCategories(uid);
    final StreamController<StatisticsSnapshot> controller =
        StreamController<StatisticsSnapshot>.broadcast();
    UserStatisticsEntity? latestUser;
    List<CategoryStatisticsEntity>? latestCategories;
    void emit() {
      if (latestUser == null || latestCategories == null) return;
      controller.add(StatisticsSnapshot(
        user: latestUser!,
        categories: List<CategoryStatisticsEntity>.unmodifiable(latestCategories!),
      ));
    }

    final StreamSubscription<UserStatisticsEntity> userSub =
        userStream.listen((UserStatisticsEntity u) {
      latestUser = u;
      emit();
    });
    final StreamSubscription<List<CategoryStatisticsEntity>> catSub =
        categoryStream.listen((List<CategoryStatisticsEntity> rows) {
      latestCategories = rows;
      emit();
    });
    controller.onCancel = () async {
      await userSub.cancel();
      await catSub.cancel();
    };
    return controller.stream;
  }

  @override
  Future<StatisticsSnapshot> snapshot(String uid) async {
    if (uid.isEmpty) {
      return StatisticsSnapshot.empty;
    }
    final UserStatisticsEntity user = await _service.summary(uid);
    final List<CategoryStatisticsEntity> rows = await _service.watchCategories(uid).first;
    return StatisticsSnapshot(
      user: user,
      categories: rows,
    );
  }

  @override
  Future<CategoryStatisticsEntity> category({
    required String uid,
    required String categoryId,
  }) {
    return _service.category(uid: uid, categoryId: categoryId);
  }
}

// ---------------------------------------------------------------------------
// Provider (default + test override).
// ---------------------------------------------------------------------------

final statisticsRepositoryProvider = Provider<StatisticsRepository>((ref) {
  return StatisticsRepositoryImpl(
    service: ref.watch(statisticsServiceProvider),
  );
});
