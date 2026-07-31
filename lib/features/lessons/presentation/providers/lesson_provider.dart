import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../data/datasources/firebase_lesson_remote_datasource.dart';
import '../../data/datasources/lesson_remote_datasource.dart';
import '../../data/datasources/mock_lesson_remote_datasource.dart';
import '../../data/repositories/lesson_repository_impl.dart';
import '../../domain/entities/lesson_entity.dart';
import '../../domain/repositories/lesson_repository.dart';
import '../../domain/usecases/get_all_lessons.dart';
import '../../domain/usecases/get_lesson_by_id.dart';
import '../../domain/usecases/get_lessons_for_node.dart';

/// Lessons remote data source.
///
/// Production reads from `lessons/{lessonId}` via
/// [FirebaseLessonRemoteDataSource] (sections/examples/summary are
/// nested fields on the document). The mock remains as the offline
/// fallback for tests / unconfigured dev.
final lessonRemoteDataSourceProvider = Provider<LessonRemoteDataSource>((ref) {
  if (FirebaseConfig.isPlatformConfigured) {
    return FirebaseLessonRemoteDataSource();
  }
  return MockLessonRemoteDataSource();
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepositoryImpl(ref.watch(lessonRemoteDataSourceProvider));
});

final getAllLessonsProvider = Provider<GetAllLessons>((ref) {
  return GetAllLessons(ref.watch(lessonRepositoryProvider));
});

final getLessonByIdProvider = Provider<GetLessonById>((ref) {
  return GetLessonById(ref.watch(lessonRepositoryProvider));
});

final getLessonsForNodeProvider = Provider<GetLessonsForNode>((ref) {
  return GetLessonsForNode(ref.watch(lessonRepositoryProvider));
});

enum LessonStatus { initial, loading, ready, error }

@immutable
class LessonListState {
  const LessonListState({
    required this.status,
    required this.lessons,
    this.errorMessage,
  });

  final LessonStatus status;
  final List<LessonEntity> lessons;
  final String? errorMessage;

  LessonListState copyWith({
    LessonStatus? status,
    List<LessonEntity>? lessons,
    String? errorMessage,
  }) {
    return LessonListState(
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
      errorMessage: errorMessage,
    );
  }

  static const LessonListState initial = LessonListState(
    status: LessonStatus.initial,
    lessons: <LessonEntity>[],
  );
}

class LessonListController extends StateNotifier<LessonListState> {
  LessonListController(this._useCase) : super(LessonListState.initial);

  final GetAllLessons _useCase;

  Future<void> load() async {
    if (state.status == LessonStatus.loading) return;
    state = state.copyWith(status: LessonStatus.loading);
    final result = await _useCase();
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (lessons) {
        state = LessonListState(
          status: LessonStatus.ready,
          lessons: lessons,
        );
      },
    );
  }
}

final lessonListControllerProvider =
    StateNotifierProvider<LessonListController, LessonListState>((ref) {
      return LessonListController(ref.watch(getAllLessonsProvider));
    });

@immutable
class LessonNodeState {
  const LessonNodeState({
    required this.nodeId,
    required this.status,
    required this.lessons,
    this.errorMessage,
  });

  final String nodeId;
  final LessonStatus status;
  final List<LessonEntity> lessons;
  final String? errorMessage;

  LessonNodeState copyWith({
    LessonStatus? status,
    List<LessonEntity>? lessons,
    String? errorMessage,
  }) {
    return LessonNodeState(
      nodeId: nodeId,
      status: status ?? this.status,
      lessons: lessons ?? this.lessons,
      errorMessage: errorMessage,
    );
  }

  static LessonNodeState initialFor(String nodeId) {
    return LessonNodeState(
      nodeId: nodeId,
      status: LessonStatus.initial,
      lessons: const <LessonEntity>[],
    );
  }
}

class LessonNodeController extends StateNotifier<LessonNodeState> {
  LessonNodeController(this._useCase, String nodeId)
    : super(LessonNodeState.initialFor(nodeId));

  final GetLessonsForNode _useCase;

  Future<void> load(String nodeId) async {
    if (state.status == LessonStatus.loading) return;
    state = LessonNodeState.initialFor(nodeId).copyWith(
      status: LessonStatus.loading,
    );
    final result = await _useCase(nodeId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (lessons) {
        state = LessonNodeState(
          nodeId: nodeId,
          status: LessonStatus.ready,
          lessons: lessons,
        );
      },
    );
  }
}

final lessonNodeControllerProvider = StateNotifierProvider.family<
  LessonNodeController,
  LessonNodeState,
  String
>((ref, nodeId) {
  return LessonNodeController(ref.watch(getLessonsForNodeProvider), nodeId);
});

@immutable
class LessonDetailState {
  const LessonDetailState({
    required this.lessonId,
    required this.status,
    this.lesson,
    this.errorMessage,
  });

  final String lessonId;
  final LessonStatus status;
  final LessonEntity? lesson;
  final String? errorMessage;

  LessonDetailState copyWith({
    LessonStatus? status,
    LessonEntity? lesson,
    String? errorMessage,
  }) {
    return LessonDetailState(
      lessonId: lessonId,
      status: status ?? this.status,
      lesson: lesson ?? this.lesson,
      errorMessage: errorMessage,
    );
  }
}

class LessonDetailController extends StateNotifier<LessonDetailState> {
  LessonDetailController(this._useCase, String lessonId)
    : super(LessonDetailState(
        lessonId: lessonId,
        status: LessonStatus.initial,
      ));

  final GetLessonById _useCase;

  Future<void> load(String lessonId) async {
    if (state.status == LessonStatus.loading) return;
    state = LessonDetailState(
      lessonId: lessonId,
      status: LessonStatus.loading,
    );
    final result = await _useCase(lessonId);
    result.fold(
      onFailure: (failure) {
        state = state.copyWith(
          status: LessonStatus.error,
          errorMessage: failure.message,
        );
      },
      onSuccess: (lesson) {
        state = LessonDetailState(
          lessonId: lessonId,
          status: LessonStatus.ready,
          lesson: lesson,
        );
      },
    );
  }
}

final lessonDetailControllerProvider = StateNotifierProvider.family<
  LessonDetailController,
  LessonDetailState,
  String
>((ref, lessonId) {
  return LessonDetailController(ref.watch(getLessonByIdProvider), lessonId);
});

@immutable
class LessonProgressState {
  const LessonProgressState({
    required this.completedSectionIds,
    required this.bookmarkedLessonIds,
    required this.completedLessonIds,
  });

  final Set<String> completedSectionIds;
  final Set<String> bookmarkedLessonIds;
  final Set<String> completedLessonIds;

  LessonProgressState copyWith({
    Set<String>? completedSectionIds,
    Set<String>? bookmarkedLessonIds,
    Set<String>? completedLessonIds,
  }) {
    return LessonProgressState(
      completedSectionIds:
          completedSectionIds ?? this.completedSectionIds,
      bookmarkedLessonIds: bookmarkedLessonIds ?? this.bookmarkedLessonIds,
      completedLessonIds: completedLessonIds ?? this.completedLessonIds,
    );
  }

  static const LessonProgressState empty = LessonProgressState(
    completedSectionIds: <String>{},
    bookmarkedLessonIds: <String>{},
    completedLessonIds: <String>{},
  );

  bool isSectionCompleted(String sectionId) =>
      completedSectionIds.contains(sectionId);
  bool isLessonBookmarked(String lessonId) =>
      bookmarkedLessonIds.contains(lessonId);
  bool isLessonCompleted(String lessonId) =>
      completedLessonIds.contains(lessonId);
}

class LessonProgressController extends StateNotifier<LessonProgressState> {
  LessonProgressController() : super(LessonProgressState.empty);

  void markSectionComplete(String sectionId) {
    if (state.completedSectionIds.contains(sectionId)) return;
    state = state.copyWith(
      completedSectionIds: <String>{
        ...state.completedSectionIds,
        sectionId,
      },
    );
  }

  void markLessonComplete(String lessonId) {
    if (state.completedLessonIds.contains(lessonId)) return;
    state = state.copyWith(
      completedLessonIds: <String>{...state.completedLessonIds, lessonId},
    );
  }

  void toggleBookmark(String lessonId) {
    final next = <String>{...state.bookmarkedLessonIds};
    if (next.contains(lessonId)) {
      next.remove(lessonId);
    } else {
      next.add(lessonId);
    }
    state = state.copyWith(bookmarkedLessonIds: next);
  }

  void reset() {
    state = LessonProgressState.empty;
  }
}

final lessonProgressControllerProvider =
    StateNotifierProvider<LessonProgressController, LessonProgressState>((
      ref,
    ) {
      return LessonProgressController();
    });