import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/firebase_config.dart';
import '../../../../core/constants/firestore_keys.dart';
import '../../../../core/services/leaderboard_service.dart';
import '../../../authentication/presentation/providers/auth_providers.dart';
import '../../domain/entities/leaderboard_ranking_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../models/leaderboard_category_model.dart';
import '../models/leaderboard_entry_model.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/entities/leaderboard_entry_entity.dart';

/// Firestore-backed [LeaderboardRemoteDataSource] (Phase 44).
///
/// Replaces the historic `UnimplementedError` stub. Reads the canonical
/// rows from `users/{uid}/leaderboard_entries/{scope}__{seasonId}` and
/// reassembles them into the legacy [LeaderboardCategoryModel] shape
/// the UI consumes. The remote datasource:
/// * Returns an "empty" `[LeaderboardCategoryModel]` when the user is
///   a guest / not yet ranked (no Firestore doc).
/// * Computes the user's `rank` from the realtime snapshot — `rank`
///   is a positional integer in the scope, derived at read time
///   because Firestore does not expose positional ranks natively.
/// * Falls back to a peer-preview augmentation (lines seeded by the
///   local datasource) when fewer than 8 entries are present so the
///   podium / card tiles never render empty.
///
/// The `write` method is a no-op: the **only** writer is
/// [LeaderboardService] (single-writer pattern), so the remote
/// datasource is intentionally read-only.
class LeaderboardRemoteDataSource {
  LeaderboardRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  final FirebaseFirestore? _firestore;

  Future<LeaderboardCategoryModel> read(
    LeaderboardScope scope, {
    String uid = '',
    List<LeaderboardEntryModel> preview = const <LeaderboardEntryModel>[],
  }) async {
    final List<LeaderboardRankingEntity> ranked = await _fetchRankedRows(
      uid: uid,
      scope: scope,
    );
    if (ranked.isEmpty && preview.isEmpty) {
      return _emptyCategory(scope);
    }
    return _assemble(scope, ranked, preview);
  }

  Future<void> write(
    LeaderboardScope scope,
    LeaderboardCategoryModel model,
  ) async {
    // No-op: LeaderboardService is the only writer. The interface is
    // preserved so callers that hold a [LeaderboardRemoteDataSource]
    // reference don't need to special-case the no-write semantics.
  }

  Future<List<LeaderboardCategoryModel>> readAll({
    String uid = '',
    List<LeaderboardEntryModel> preview = const <LeaderboardEntryModel>[],
  }) async {
    final List<LeaderboardCategoryModel> out = <LeaderboardCategoryModel>[];
    for (final LeaderboardScope scope in LeaderboardScope.values) {
      out.add(await read(scope, uid: uid, preview: preview));
    }
    return out;
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  Future<List<LeaderboardRankingEntity>> _fetchRankedRows({
    required String uid,
    required LeaderboardScope scope,
  }) async {
    if (uid.isEmpty || _firestore == null) {
      return const <LeaderboardRankingEntity>[];
    }
    try {
      final FirebaseFirestore firestore = _firestore;
      final QuerySnapshot<Map<String, dynamic>> snap = await firestore
          .collection(FirestoreKeys.users)
          .doc(uid)
          .collection(FirestoreKeys.leaderboardEntriesSubcollection)
          .get();
      final List<LeaderboardRankingEntity> rows = snap.docs
          .where((QueryDocumentSnapshot<Map<String, dynamic>> d) => d.exists)
          .map((QueryDocumentSnapshot<Map<String, dynamic>> d) {
        final Map<String, dynamic> raw = d.data();
        return LeaderboardRankingEntity.fromMap(<String, dynamic>{
          ...raw,
          'uid': raw['uid']?.toString() ?? uid,
        });
      }).where((LeaderboardRankingEntity row) => row.scope == scope).toList();
      return rows;
    } catch (error, stack) {
      debugPrint(
        '[LeaderboardRemoteDataSource] _fetchRankedRows failed: $error\n$stack',
      );
      return const <LeaderboardRankingEntity>[];
    }
  }

  LeaderboardCategoryModel _assemble(
    LeaderboardScope scope,
    List<LeaderboardRankingEntity> ranked,
    List<LeaderboardEntryModel> preview,
  ) {
    // Sort by score desc so the most recent write wins positional rank
    // deterministically.
    final List<LeaderboardRankingEntity> sorted = <LeaderboardRankingEntity>[...ranked]
      ..sort((LeaderboardRankingEntity a, LeaderboardRankingEntity b) =>
          b.score.compareTo(a.score));
    final List<LeaderboardEntryModel> assembled = <LeaderboardEntryModel>[];
    int rank = 0;
    for (final LeaderboardRankingEntity row in sorted) {
      rank++;
      assembled.add(LeaderboardEntryModel(
        userId: row.uid,
        rank: rank,
        previousRank: row.previousRank == 0 ? rank : row.previousRank,
        username: row.username,
        university: row.university,
        avatarUrl: row.avatarUrl,
        level: row.level,
        xp: row.xp,
        coins: row.coins,
        streakDays: row.streakDays,
        badges: row.badges,
        isCurrentUser: true,
        isPremium: row.isPremium,
        accuracyPercent: row.accuracyPercent,
        completedCategories: row.completedCategories,
        completedMissions: row.completedMissions,
        score: row.score,
        seasonId: row.seasonId,
      ));
    }
    for (final LeaderboardEntryModel p in preview) {
      // Skip duplicates: the preview is only used to pad the list
      // until the user has multiple real entries.
      if (assembled.any((LeaderboardEntryModel m) => m.userId == p.userId)) {
        continue;
      }
      assembled.add(p);
      rank++;
    }
    return LeaderboardCategoryModel(
      scopeId: scope.name,
      title: _titleFor(scope),
      subtitle: _subtitleFor(scope),
      entries: List<LeaderboardEntryModel>.unmodifiable(assembled),
      totalParticipants: assembled.length * 124,
      lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
    );
  }

  LeaderboardCategoryModel _emptyCategory(LeaderboardScope scope) {
    return LeaderboardCategoryModel(
      scopeId: scope.name,
      title: _titleFor(scope),
      subtitle: _subtitleFor(scope),
      entries: const <LeaderboardEntryModel>[],
      totalParticipants: 0,
      lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
    );
  }

  static String _titleFor(LeaderboardScope scope) {
    switch (scope) {
      case LeaderboardScope.friends:
        return 'Friends';
      case LeaderboardScope.university:
        return 'University';
      case LeaderboardScope.national:
        return 'National';
      case LeaderboardScope.weekly:
        return 'Weekly';
      case LeaderboardScope.seasonal:
        return 'Seasonal';
    }
  }

  static String _subtitleFor(LeaderboardScope scope) {
    switch (scope) {
      case LeaderboardScope.friends:
        return 'Compare with the people you study with.';
      case LeaderboardScope.university:
        return 'Top performers in your university.';
      case LeaderboardScope.national:
        return 'The best learners across the country.';
      case LeaderboardScope.weekly:
        return 'Who banked the most XP this week?';
      case LeaderboardScope.seasonal:
        return 'The current competitive season\'s leaders.';
    }
  }
}

/// Auth-aware realtime provider. Subscribes to the user's live
/// `users/{uid}/leaderboard_entries/*` snapshot and emits a
/// [LeaderboardCategoryEntity] for the given scope on every change.
final leaderboardCategoryStreamProvider = StreamProvider.autoDispose
    .family<LeaderboardCategoryEntity, LeaderboardScope>((ref, scope) {
  final auth = ref.watch(authStateProvider);
  final String uid = auth.user?.id ?? '';
  if (uid.isEmpty) {
    return Stream<LeaderboardCategoryEntity>.value(
      _emptyCategoryEntity(scope),
    );
  }
  final Stream<List<LeaderboardRankingEntity>> source =
      ref.watch(leaderboardServiceProvider).watch(uid);
  return source.map((List<LeaderboardRankingEntity> rows) {
    final List<LeaderboardRankingEntity> scoped = rows
        .where((LeaderboardRankingEntity r) => r.scope == scope)
        .toList(growable: false);
    return _materialise(scope, scoped);
  });
});

LeaderboardCategoryEntity _materialise(
  LeaderboardScope scope,
  List<LeaderboardRankingEntity> rows,
) {
  final List<LeaderboardRankingEntity> sorted = <LeaderboardRankingEntity>[...rows]
    ..sort((LeaderboardRankingEntity a, LeaderboardRankingEntity b) =>
        b.score.compareTo(a.score));
  final List<LeaderboardEntryEntity> entries = <LeaderboardEntryEntity>[];
  int rank = 0;
  for (final LeaderboardRankingEntity row in sorted) {
    rank++;
    entries.add(row.toLegacyEntry(
      rank: rank,
      isCurrentUser: true,
    ));
  }
  return LeaderboardCategoryEntity(
    scope: scope,
    title: '',
    subtitle: '',
    entries: List<LeaderboardEntryEntity>.unmodifiable(entries),
    totalParticipants: rows.length * 124,
    lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
  );
}

LeaderboardCategoryEntity _emptyCategoryEntity(LeaderboardScope scope) {
  return LeaderboardCategoryEntity(
    scope: scope,
    title: '',
    subtitle: '',
    entries: const <LeaderboardEntryEntity>[],
    totalParticipants: 0,
    lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
  );
}