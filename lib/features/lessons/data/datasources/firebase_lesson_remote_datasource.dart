import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../models/lesson_model.dart';
import 'lesson_remote_datasource.dart';

/// Firestore-backed [LessonRemoteDataSource] (Phase 55).
///
/// Reads from `lessons/{lessonId}` with the lesson content embedded
/// (sections/examples/summary live as nested fields on the document).
/// Returns an empty list when Firebase is not configured so the rest
/// of the app still resolves.
///
/// Schema (read):
///   lessons/{lessonId}: slug, subject, title, subtitle, summary,
///                       estimatedReadingMinutes, difficulty, tags[],
///                       rewardXp, rewardCoins, requiresLevel,
///                       isPremium, prerequisiteLessonIds[], nodeIds[],
///                       sections[], examples[], summarySection{}
class FirebaseLessonRemoteDataSource implements LessonRemoteDataSource {
  FirebaseLessonRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  CollectionReference<Map<String, dynamic>> _lessonsRef() {
    return _firestore!.collection(FirestoreKeys.lessonsCollection);
  }

  @override
  Future<List<LessonModel>> fetchAllLessons() async {
    if (_firestore == null) return const <LessonModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap =
        await _lessonsRef().limit(200).get();
    return List<LessonModel>.unmodifiable(
      snap.docs.map(_hydrate),
    );
  }

  @override
  Future<List<LessonModel>> fetchLessonsForNode(String nodeId) async {
    if (_firestore == null) return const <LessonModel>[];
    final QuerySnapshot<Map<String, dynamic>> snap = await _lessonsRef()
        .where('nodeIds', arrayContains: nodeId)
        .limit(50)
        .get();
    return List<LessonModel>.unmodifiable(
      snap.docs.map(_hydrate),
    );
  }

  @override
  Future<LessonModel?> fetchLessonById(String id) async {
    if (_firestore == null) return null;
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _lessonsRef().doc(id).get();
    if (!doc.exists) return null;
    return _hydrate(doc);
  }

  @override
  Future<LessonModel?> fetchLessonBySlug(String slug) async {
    if (_firestore == null) return null;
    final QuerySnapshot<Map<String, dynamic>> snap = await _lessonsRef()
        .where('slug', isEqualTo: slug)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return _hydrate(snap.docs.first);
  }

  LessonModel _hydrate(DocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data() ?? <String, dynamic>{};
    final String id = doc.id;
    final List<LessonSectionModel> sections = (data['sections'] as List<dynamic>?)
            ?.map((dynamic s) => LessonSectionModel(
                  id: (s as Map<dynamic, dynamic>)['id']?.toString() ?? '',
                  title: s['title']?.toString() ?? '',
                  body: s['body']?.toString() ?? '',
                  kind: s['kind']?.toString() ?? 'concept',
                  bullets: List<String>.from(
                    (s['bullets'] as List<dynamic>?) ?? <dynamic>[],
                  ),
                  callout: s['callout'] as String?,
                  estimatedMinutes:
                      (s['estimatedMinutes'] as num?)?.toInt() ?? 2,
                ))
            .toList(growable: false) ??
        const <LessonSectionModel>[];
    final List<LessonExampleModel> examples =
        (data['examples'] as List<dynamic>?)
                ?.map((dynamic e) => LessonExampleModel(
                      id: (e as Map<dynamic, dynamic>)['id']?.toString() ?? '',
                      title: e['title']?.toString() ?? '',
                      prompt: e['prompt']?.toString() ?? '',
                      steps: List<String>.from(
                        (e['steps'] as List<dynamic>?) ?? <dynamic>[],
                      ),
                      answer: e['answer']?.toString() ?? '',
                      explanation: e['explanation'] as String?,
                    ))
                .toList(growable: false) ??
            const <LessonExampleModel>[];
    final Map<String, dynamic> summary = (data['summarySection']
            as Map<dynamic, dynamic>?)?.map(
          (dynamic k, dynamic v) =>
              MapEntry<String, dynamic>(k.toString(), v),
        ) ??
        <String, dynamic>{};
    return LessonModel(
      id: id,
      slug: (data['slug'] as String?) ?? id,
      subject: (data['subject'] as String?) ?? '',
      title: (data['title'] as String?) ?? '',
      subtitle: (data['subtitle'] as String?) ?? '',
      summary: (data['summary'] as String?) ?? '',
      sections: sections,
      examples: examples,
      summarySection: LessonSummaryModel(
        keyTakeaways: List<String>.from(
          (summary['keyTakeaways'] as List<dynamic>?) ?? <dynamic>[],
        ),
        nextSteps: List<String>.from(
          (summary['nextSteps'] as List<dynamic>?) ?? <dynamic>[],
        ),
        recommendedChallengeId: summary['recommendedChallengeId'] as String?,
      ),
      estimatedReadingMinutes:
          (data['estimatedReadingMinutes'] as num?)?.toInt() ?? 5,
      difficulty: (data['difficulty'] as String?) ?? 'easy',
      tags: List<String>.from((data['tags'] as List<dynamic>?) ?? <dynamic>[]),
      rewardXp: (data['rewardXp'] as num?)?.toInt() ?? 0,
      rewardCoins: (data['rewardCoins'] as num?)?.toInt() ?? 0,
      nodeIds: List<String>.from(
        (data['nodeIds'] as List<dynamic>?) ?? <dynamic>[],
      ),
      requiresLevel: (data['requiresLevel'] as num?)?.toInt() ?? 1,
      isPremium: (data['isPremium'] as bool?) ?? false,
      prerequisiteLessonIds: List<String>.from(
        (data['prerequisiteLessonIds'] as List<dynamic>?) ?? <dynamic>[],
      ),
    );
  }
}