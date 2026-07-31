import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/firebase_config.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../models/leaderboard_category_model.dart';
import '../models/leaderboard_entry_model.dart';
import 'leaderboard_remote_datasource.dart';

/// Firestore-backed implementation of [LeaderboardRemoteDataSource].
///
/// Every leaderboard scope resolves to "the top-N users from the
/// `users` collection ordered by XP desc". The current authenticated
/// user is guaranteed to be present in the list even when they fall
/// outside the top-N, so the "you" row always has something to render.
class FirestoreLeaderboardRemoteDataSource
    implements LeaderboardRemoteDataSource {
  const FirestoreLeaderboardRemoteDataSource({
    required this.activeUserId,
    this.topN = 50,
  });

  /// UID of the signed-in user. Always injected into the result list.
  final String activeUserId;

  /// Maximum number of entries per scope.
  final int topN;

  CollectionReference<Map<String, dynamic>> get _users {
    final FirebaseFirestore? firestore = FirebaseConfig.firestore;
    if (firestore == null) {
      throw StateError('Firestore is not configured on this platform.');
    }
    return firestore.collection('users');
  }

  @override
  Future<LeaderboardCategoryModel> read(
    LeaderboardScope scope, {
    String uid = '',
    List<LeaderboardEntryModel> preview = const <LeaderboardEntryModel>[],
  }) async {
    final String effectiveUid = uid.isNotEmpty ? uid : activeUserId;
    return _buildCategory(scope, await _loadRows(), activeUserId: effectiveUid);
  }

  @override
  Future<void> write(LeaderboardScope scope, LeaderboardCategoryModel model) async {
    // Leaderboards are derived state — never written back to Firestore
    // from the client. XP / coins / streak update `users/{uid}` and the
    // next query reflects the change.
  }

  @override
  Future<List<LeaderboardCategoryModel>> readAll({
    String uid = '',
    List<LeaderboardEntryModel> preview = const <LeaderboardEntryModel>[],
  }) async {
    final String effectiveUid = uid.isNotEmpty ? uid : activeUserId;
    final List<_LeaderboardRow> rows = await _loadRows();
    return <LeaderboardCategoryModel>[
      for (final LeaderboardScope scope in LeaderboardScope.values)
        _buildCategory(scope, rows, activeUserId: effectiveUid),
    ];
  }

  Future<List<_LeaderboardRow>> _loadRows() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
          await _users.orderBy('xp', descending: true).limit(topN + 1).get();
      return snapshot.docs.map(_rowFromDoc).toList(growable: false);
    } catch (_) {
      return const <_LeaderboardRow>[];
    }
  }

  LeaderboardCategoryModel _buildCategory(
    LeaderboardScope scope,
    List<_LeaderboardRow> rows, {
    required String activeUserId,
  }) {
    final List<LeaderboardEntryModel> entries = _rank(
      rows,
      activeUserId: activeUserId,
    );
    return LeaderboardCategoryModel(
      scopeId: scope.name,
      title: _titleFor(scope),
      subtitle: _subtitleFor(scope),
      entries: List<LeaderboardEntryModel>.unmodifiable(entries),
      totalParticipants: rows.length,
      lastUpdatedIso: DateTime.now().toUtc().toIso8601String(),
    );
  }

  _LeaderboardRow _rowFromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> data = doc.data();
    return _LeaderboardRow(
      userId: doc.id,
      displayName: (data['displayName'] as String?) ?? 'Learner',
      avatarUrl: (data['photoURL'] as String?) ?? '',
      xp: (data['xp'] as num?)?.toInt() ?? 0,
      coins: (data['coins'] as num?)?.toInt() ?? 0,
      level: (data['level'] as num?)?.toInt() ?? 1,
      streak: (data['streak'] as num?)?.toInt() ?? 0,
      isPremium: (data['isPremium'] as bool?) ?? false,
      badges: ((data['badges'] as List<dynamic>?) ?? const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      university: (data['university'] as String?) ?? 'BCS Aspirants',
    );
  }

  List<LeaderboardEntryModel> _rank(
    List<_LeaderboardRow> rows, {
    required String activeUserId,
  }) {
    final List<_LeaderboardRow> sorted = List<_LeaderboardRow>.of(rows)
      ..sort((_LeaderboardRow a, _LeaderboardRow b) => b.xp.compareTo(a.xp));
    final List<LeaderboardEntryModel> entries = <LeaderboardEntryModel>[];
    for (int i = 0; i < sorted.length && i < topN; i++) {
      final _LeaderboardRow r = sorted[i];
      entries.add(
        LeaderboardEntryModel(
          userId: r.userId,
          rank: i + 1,
          previousRank: i + 1,
          username: r.displayName,
          university: r.university,
          avatarUrl: r.avatarUrl,
          level: r.level,
          xp: r.xp,
          coins: r.coins,
          streakDays: r.streak,
          badges: r.badges,
          isCurrentUser: r.userId == activeUserId,
          isPremium: r.isPremium,
        ),
      );
    }
    if (activeUserId.isNotEmpty &&
        !entries.any((LeaderboardEntryModel e) => e.isCurrentUser)) {
      final int idx =
          sorted.indexWhere((_LeaderboardRow r) => r.userId == activeUserId);
      if (idx >= 0) {
        final _LeaderboardRow me = sorted[idx];
        entries.add(
          LeaderboardEntryModel(
            userId: me.userId,
            rank: idx + 1,
            previousRank: idx + 1,
            username: me.displayName,
            university: me.university,
            avatarUrl: me.avatarUrl,
            level: me.level,
            xp: me.xp,
            coins: me.coins,
            streakDays: me.streak,
            badges: me.badges,
            isCurrentUser: true,
            isPremium: me.isPremium,
          ),
        );
      }
    }
    return entries;
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
        return 'Best BCS aspirants in the country.';
      case LeaderboardScope.weekly:
        return 'XP earned this week.';
      case LeaderboardScope.seasonal:
        return 'Season championship standings.';
    }
  }
}

class _LeaderboardRow {
  const _LeaderboardRow({
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.xp,
    required this.coins,
    required this.level,
    required this.streak,
    required this.isPremium,
    required this.badges,
    required this.university,
  });

  final String userId;
  final String displayName;
  final String avatarUrl;
  final int xp;
  final int coins;
  final int level;
  final int streak;
  final bool isPremium;
  final List<String> badges;
  final String university;
}