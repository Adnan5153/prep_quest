import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../lessons/data/datasources/firebase_lesson_remote_datasource.dart';
import '../../../lessons/data/datasources/lesson_remote_datasource.dart';
import '../../../lessons/data/models/lesson_model.dart';
import '../../../quiz_engine/data/datasources/firebase_quiz_remote_datasource.dart';
import '../../../quiz_engine/data/datasources/quiz_remote_datasource.dart';
import '../../../quiz_engine/data/models/quiz_model.dart';
import '../../domain/enums/search_category.dart';
import '../models/recent_search_model.dart';
import '../models/search_item_model.dart';
import '../models/trending_search_model.dart';
import 'search_remote_datasource.dart';

/// Firestore-backed [SearchRemoteDataSource] (Phase 55).
///
/// Reads the canonical catalogue from the `lessons` and `quizzes`
/// collections (via the injected [LessonRemoteDataSource] /
/// [QuizRemoteDataSource]) and persists recent searches per user under
/// `users/{uid}/search_recent/{query}`. Trending terms live in a
/// single document `search_index/trending` published by a daily
/// Cloud Function.
///
/// Schema (read):
///   search_index/trending: terms[] (label, query, rank, category)
///   lessons/{lessonId}: title, subtitle, slug, subject
///   quizzes/{quizId}: title, subject, description
///   users/{uid}/search_recent/{query}: query, queriedAtIso,
///     categoryAtTime
class FirebaseSearchRemoteDataSource implements SearchRemoteDataSource {
  FirebaseSearchRemoteDataSource({
    required String uid,
    required LessonRemoteDataSource lessonSource,
    required QuizRemoteDataSource quizSource,
    FirebaseFirestore? firestore,
  })  : _uid = uid,
        _lessonSource = lessonSource,
        _quizSource = quizSource,
        _firestore = firestore ?? FirebaseConfig.firestore;

  final String _uid;
  final LessonRemoteDataSource _lessonSource;
  final QuizRemoteDataSource _quizSource;
  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _recentRef() {
    return _firestore!
        .collection(FirestoreKeys.users)
        .doc(_uid)
        .collection(FirestoreKeys.searchRecentSubcollection);
  }

  @override
  List<SearchItemModel> readAll() {
    // Firestore search is query-driven; the synchronous contract
    // returns empty so callers fall through to the async extension
    // methods when they need live results.
    return const <SearchItemModel>[];
  }

  /// Async recent-trending + catalogue read. The caller (the
  /// repository) is responsible for awaiting this and merging the
  /// results with its local cache.
  Future<List<SearchItemModel>> readAllAsync() async {
    final List<SearchItemModel> out = <SearchItemModel>[];
    if (_lessonSource is FirebaseLessonRemoteDataSource) {
      final List<LessonModel> lessons = await _lessonSource.fetchAllLessons();
      out.addAll(
        lessons
            .take(50)
            .map((LessonModel lesson) => SearchItemModel(
                  id: 'lesson-${lesson.id}',
                  category: SearchCategory.lessons,
                  title: lesson.title,
                  subtitle: lesson.subtitle,
                  routeName: '/lessons',
                  secondaryRouteName: '/lessons/detail',
                  iconName: 'book',
                )),
      );
    }
    if (_quizSource is FirebaseQuizRemoteDataSource) {
      final List<QuizModel> quizzes = await _quizSource.fetchAllQuizzes();
      out.addAll(
        quizzes
            .take(50)
            .map((QuizModel quiz) => SearchItemModel(
                  id: 'quiz-${quiz.id}',
                  category: SearchCategory.questions,
                  title: quiz.title,
                  subtitle: (quiz.description?.isNotEmpty ?? false)
                      ? quiz.description!
                      : 'Tap to start the quiz',
                  routeName: '/quiz/overview',
                  iconName: 'note',
                )),
      );
    }
    return List<SearchItemModel>.unmodifiable(out);
  }

  /// Async query-driven search.
  Future<List<SearchItemModel>> searchItemsAsync(
    String query,
    Set<SearchCategory> categories,
  ) async {
    final Set<SearchCategory> filter = categories.isEmpty
        ? <SearchCategory>{
            SearchCategory.lessons,
            SearchCategory.questions,
            SearchCategory.topics,
            SearchCategory.books,
            SearchCategory.aiHistory,
          }
        : categories;
    final String needle = query.trim().toLowerCase();
    final List<SearchItemModel> out = <SearchItemModel>[];
    if (filter.contains(SearchCategory.lessons) &&
        _lessonSource is FirebaseLessonRemoteDataSource) {
      final List<LessonModel> lessons = await _lessonSource.fetchAllLessons();
      out.addAll(
        lessons
            .where((LessonModel lesson) =>
                lesson.title.toLowerCase().contains(needle) ||
                lesson.subtitle.toLowerCase().contains(needle))
            .map((LessonModel lesson) => SearchItemModel(
                  id: 'lesson-${lesson.id}',
                  category: SearchCategory.lessons,
                  title: lesson.title,
                  subtitle: lesson.subtitle,
                  routeName: '/lessons',
                  secondaryRouteName: '/lessons/detail',
                  iconName: 'book',
                ))
            .take(50),
      );
    }
    if (filter.contains(SearchCategory.questions) &&
        _quizSource is FirebaseQuizRemoteDataSource) {
      final List<QuizModel> quizzes = await _quizSource.fetchAllQuizzes();
      out.addAll(
        quizzes
            .where((QuizModel quiz) =>
                quiz.title.toLowerCase().contains(needle) ||
                ((quiz.description?.isNotEmpty ?? false) &&
                    quiz.description!.toLowerCase().contains(needle)))
            .map((QuizModel quiz) => SearchItemModel(
                  id: 'quiz-${quiz.id}',
                  category: SearchCategory.questions,
                  title: quiz.title,
                  subtitle: quiz.description ?? 'Tap to start the quiz',
                  routeName: '/quiz/overview',
                  iconName: 'note',
                ))
            .take(50),
      );
    }
    return List<SearchItemModel>.unmodifiable(out);
  }

  @override
  void writeRecent(List<RecentSearchModel> rows) {
    // Persistence uses [appendRecent]; see repository for the async
    // fan-out.
    return;
  }

  /// Persists a single recent query. Idempotent — overwrites the
  /// `users/{uid}/search_recent/{query}` doc with the latest
  /// timestamp.
  Future<void> appendRecent(RecentSearchModel row) async {
    if (_firestore == null) return;
    await _recentRef().doc(row.query.toLowerCase()).set(<String, dynamic>{
      'query': row.query,
      'queriedAtIso': row.queriedAtIso,
      'categoryAtTime': row.categoryAtTime?.name ?? SearchCategory.lessons.name,
    });
  }

  @override
  List<TrendingSearchModel> readTrending() {
    return const <TrendingSearchModel>[];
  }

  Future<List<RecentSearchModel>> readRecentAsync({int limit = 10}) async {
    if (_firestore == null) return const <RecentSearchModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _recentRef()
        .orderBy('queriedAtIso', descending: true)
        .limit(limit)
        .get();
    return List<RecentSearchModel>.unmodifiable(
      snap.docs.map((QueryDocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data();
        return RecentSearchModel(
          query: (data['query'] as String?) ?? doc.id,
          queriedAtIso: (data['queriedAtIso'] as String?) ?? '',
          categoryAtTime: _parseCategory(data['categoryAtTime'] as String?),
        );
      }),
    );
  }

  Future<List<TrendingSearchModel>> readTrendingAsync({int limit = 8}) async {
    if (_firestore == null) return const <TrendingSearchModel>[];
    final DocumentSnapshot<Map<String, dynamic>> doc = await _firestore!
        .collection(FirestoreKeys.searchIndexCollection)
        .doc('trending')
        .get();
    if (!doc.exists) return const <TrendingSearchModel>[];
    final Map<String, dynamic>? data = doc.data();
    final List<dynamic> rows =
        (data == null ? <dynamic>[] : data['terms'] as List<dynamic>?) ??
            <dynamic>[];
    return List<TrendingSearchModel>.unmodifiable(
      rows.take(limit).map((dynamic raw) {
        final Map<dynamic, dynamic> entry = raw as Map<dynamic, dynamic>;
        return TrendingSearchModel(
          label: (entry['label'] as String?) ?? '',
          query: (entry['query'] as String?) ?? '',
          rank: (entry['rank'] as num?)?.toInt() ?? 0,
          category: _parseCategory(entry['category'] as String?),
        );
      }),
    );
  }

  SearchCategory _parseCategory(String? raw) {
    return SearchCategory.values.firstWhere(
      (SearchCategory c) => c.name == raw,
      orElse: () => SearchCategory.lessons,
    );
  }
}