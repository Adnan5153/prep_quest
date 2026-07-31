import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../models/category_model.dart';

/// Contract every category remote data source must satisfy.
///
/// Two implementations exist:
/// * [FirestoreCategoryRemoteDataSource] — production Firestore-backed
///   source reading from the `categories` collection.
/// * [MockCategoryRemoteDataSource] — in-memory replacement used
///   during development and tests.
abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> listCategories();

  Future<CategoryModel?> getCategory(String id);

  Stream<List<CategoryModel>> watchCategories();
}

/// Firestore-backed implementation.
///
/// Each document in the `categories` collection becomes a single
/// playground node. The `order` field controls the world-map layout
/// (lower = earlier in the path). `kind` maps to [CategoryNodeKind]
/// (`lesson`, `mockTest`, `bossGate`, `reward`, `milestone`).
class FirestoreCategoryRemoteDataSource implements CategoryRemoteDataSource {
  const FirestoreCategoryRemoteDataSource();

  CollectionReference<Map<String, dynamic>> get _collection {
    final firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      throw StateError('Firestore is not configured on this platform.');
    }
    return firestore.collection(FirestoreKeys.categories);
  }

  @override
  Future<List<CategoryModel>> listCategories() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _collection.orderBy('order').get();
    return snapshot.docs
        .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
            CategoryModel.fromMap(doc.id, doc.data()))
        .toList(growable: false);
  }

  @override
  Future<CategoryModel?> getCategory(String id) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _collection.doc(id).get();
    if (!snapshot.exists) return null;
    return CategoryModel.fromMap(snapshot.id, snapshot.data() ?? const {});
  }

  @override
  Stream<List<CategoryModel>> watchCategories() {
    return _collection
        .orderBy('order')
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
            .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                CategoryModel.fromMap(doc.id, doc.data()))
            .toList(growable: false));
  }
}

/// In-memory replacement that returns a deterministic BCS-style
/// curriculum so the playground boots without any backend.
class MockCategoryRemoteDataSource implements CategoryRemoteDataSource {
  MockCategoryRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 240);

  final Duration _latency;
  final List<CategoryModel> _seed = _seedCategories();

  @override
  Future<List<CategoryModel>> listCategories() async {
    await Future<void>.delayed(_latency);
    return List<CategoryModel>.unmodifiable(_seed);
  }

  @override
  Future<CategoryModel?> getCategory(String id) async {
    await Future<void>.delayed(_latency);
    for (final CategoryModel c in _seed) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Stream<List<CategoryModel>> watchCategories() async* {
    yield List<CategoryModel>.unmodifiable(_seed);
    await Future<void>.delayed(const Duration(seconds: 1));
    yield List<CategoryModel>.unmodifiable(_seed);
  }

  static List<CategoryModel> _seedCategories() {
    return const <CategoryModel>[
      CategoryModel(
        id: 'cat-bangladesh-basics',
        title: 'Bangladesh Affairs',
        subtitle: 'History, geography, civics',
        kind: 'lesson',
        order: 0,
        xpReward: 30,
        coinReward: 12,
        subject: 'Bangladesh Affairs',
      ),
      CategoryModel(
        id: 'cat-grammar',
        title: 'English Grammar',
        subtitle: 'Tenses, articles, prepositions',
        kind: 'lesson',
        order: 1,
        xpReward: 40,
        coinReward: 15,
        subject: 'English',
      ),
      CategoryModel(
        id: 'cat-mathematics',
        title: 'Mathematics',
        subtitle: 'Arithmetic + algebra',
        kind: 'lesson',
        order: 2,
        xpReward: 50,
        coinReward: 20,
        subject: 'Mathematics',
      ),
      CategoryModel(
        id: 'cat-library',
        title: 'Library',
        subtitle: 'Reference materials',
        kind: 'milestone',
        order: 3,
        xpReward: 0,
        coinReward: 0,
      ),
      CategoryModel(
        id: 'cat-daily-reward',
        title: 'Daily Reward',
        subtitle: 'Open every day',
        kind: 'reward',
        order: 4,
        xpReward: 15,
        coinReward: 5,
      ),
      CategoryModel(
        id: 'cat-mock-test',
        title: 'Mock Test',
        subtitle: 'Full-length BCS-style test',
        kind: 'mockTest',
        order: 5,
        xpReward: 100,
        coinReward: 50,
      ),
      CategoryModel(
        id: 'cat-boss',
        title: 'BCS Boss',
        subtitle: 'Final boss gate',
        kind: 'bossGate',
        order: 6,
        xpReward: 150,
        coinReward: 75,
      ),
    ];
  }
}