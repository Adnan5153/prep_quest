import '../../domain/enums/leaderboard_enums.dart';
import '../models/leaderboard_category_model.dart';
import '../models/leaderboard_entry_model.dart';

/// In-memory source of truth for the leaderboard feature.
///
/// Five scopes (friends / university / national / weekly / seasonal)
/// are seeded with deterministic entries so the UI can render
/// meaningfully without a backend. The current user is injected at
/// rank 7 of every list so the "current user card" has a real
/// highlight to operate on.
class LeaderboardLocalDataSource {
  LeaderboardLocalDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Map<LeaderboardScope, LeaderboardCategoryModel> _byScope =
      <LeaderboardScope, LeaderboardCategoryModel>{};
  bool _seeded = false;

  LeaderboardCategoryModel read(LeaderboardScope scope) {
    _ensureSeeded();
    return _byScope[scope]!;
  }

  void write(LeaderboardScope scope, LeaderboardCategoryModel model) {
    _ensureSeeded();
    _byScope[scope] = model;
  }

  List<LeaderboardCategoryModel> readAll() {
    _ensureSeeded();
    return List<LeaderboardCategoryModel>.unmodifiable(_byScope.values);
  }

  void reset() {
    _byScope.clear();
    _seeded = false;
  }

  // ---------------------------------------------------------------------------
  // Seed
  // ---------------------------------------------------------------------------

  void _ensureSeeded() {
    if (_seeded) return;
    _seeded = true;
    final DateTime now = _clock();
    final String iso = now.toIso8601String();
    for (final LeaderboardScope scope in LeaderboardScope.values) {
      _byScope[scope] = _buildCategory(scope, iso);
    }
  }

  LeaderboardCategoryModel _buildCategory(LeaderboardScope scope, String iso) {
    final _CategoryBlueprint blueprint = _blueprintFor(scope);
    final List<LeaderboardEntryModel> entries = <LeaderboardEntryModel>[];
    for (int i = 0; i < blueprint.rows.length; i++) {
      final _RowBlueprint row = blueprint.rows[i];
      entries.add(
        LeaderboardEntryModel(
          userId: row.userId,
          rank: i + 1,
          previousRank: i + 1 + row.rankShift,
          username: row.username,
          university: row.university,
          avatarUrl: '',
          level: row.level,
          xp: row.xp,
          coins: row.coins,
          streakDays: row.streak,
          badges: row.badges,
          isCurrentUser: row.isCurrentUser,
          isPremium: row.isPremium,
        ),
      );
    }
    return LeaderboardCategoryModel(
      scopeId: scope.name,
      title: blueprint.title,
      subtitle: blueprint.subtitle,
      entries: List<LeaderboardEntryModel>.unmodifiable(entries),
      totalParticipants: blueprint.participants,
      lastUpdatedIso: iso,
    );
  }

  _CategoryBlueprint _blueprintFor(LeaderboardScope scope) {
    switch (scope) {
      case LeaderboardScope.friends:
        return _CategoryBlueprint(
          title: 'Friends',
          subtitle: 'Compare with the people you study with.',
          participants: 124,
          rows: _friendsRows,
        );
      case LeaderboardScope.university:
        return _CategoryBlueprint(
          title: 'University',
          subtitle: 'Top performers in your university.',
          participants: 984,
          rows: _universityRows,
        );
      case LeaderboardScope.national:
        return _CategoryBlueprint(
          title: 'National',
          subtitle: 'The best learners across the country.',
          participants: 24853,
          rows: _nationalRows,
        );
      case LeaderboardScope.weekly:
        return _CategoryBlueprint(
          title: 'Weekly',
          subtitle: 'Who banked the most XP this week?',
          participants: 12480,
          rows: _weeklyRows,
        );
      case LeaderboardScope.seasonal:
        return _CategoryBlueprint(
          title: 'Seasonal',
          subtitle: 'The current competitive season’s leaders.',
          participants: 62140,
          rows: _seasonalRows,
        );
    }
  }
}

class _CategoryBlueprint {
  const _CategoryBlueprint({
    required this.title,
    required this.subtitle,
    required this.participants,
    required this.rows,
  });

  final String title;
  final String subtitle;
  final int participants;
  final List<_RowBlueprint> rows;
}

class _RowBlueprint {
  const _RowBlueprint({
    required this.userId,
    required this.username,
    required this.university,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streak,
    required this.badges,
    this.isCurrentUser = false,
    this.isPremium = false,
    this.rankShift = 0,
  });

  final String userId;
  final String username;
  final String university;
  final int level;
  final int xp;
  final int coins;
  final int streak;
  final List<String> badges;
  final bool isCurrentUser;
  final bool isPremium;
  final int rankShift;
}

const List<String> _allBadges = <String>[
  'quiz_master',
  'streak_legend',
  'monthly_champion',
  'mission_master',
];

const List<_RowBlueprint> _friendsRows = <_RowBlueprint>[
  _RowBlueprint(
    userId: 'u_friend_1',
    username: 'Tahmid Ahmed',
    university: 'Dhaka University',
    level: 24,
    xp: 18450,
    coins: 9820,
    streak: 32,
    badges: _allBadges,
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_friend_2',
    username: 'Nazia Haque',
    university: 'BUET',
    level: 21,
    xp: 16220,
    coins: 8400,
    streak: 18,
    badges: <String>['quiz_master'],
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_friend_3',
    username: 'Sabbir Rahman',
    university: 'Chittagong University',
    level: 19,
    xp: 14310,
    coins: 7710,
    streak: 12,
    badges: <String>['streak_legend'],
    isPremium: true,
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_friend_4',
    username: 'Mim Akter',
    university: 'Rajshahi University',
    level: 18,
    xp: 12680,
    coins: 6240,
    streak: 9,
    badges: <String>['mission_master'],
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_friend_5',
    username: 'Riyad Hossain',
    university: 'Khulna University',
    level: 16,
    xp: 11420,
    coins: 5870,
    streak: 7,
    badges: <String>[],
    rankShift: 2,
  ),
  _RowBlueprint(
    userId: 'u_friend_6',
    username: 'Sumaiya Khan',
    university: 'Jahangirnagar University',
    level: 14,
    xp: 9800,
    coins: 4210,
    streak: 5,
    badges: <String>['quiz_master'],
    rankShift: -2,
  ),
  _RowBlueprint(
    userId: 'u_current_user',
    username: 'You',
    university: 'Dhaka University',
    level: 13,
    xp: 8640,
    coins: 3810,
    streak: 4,
    badges: <String>['streak_legend'],
    isCurrentUser: true,
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_friend_7',
    username: 'Arif Mahbub',
    university: 'National University',
    level: 12,
    xp: 7820,
    coins: 3290,
    streak: 3,
    badges: <String>[],
    rankShift: -1,
  ),
];

const List<_RowBlueprint> _universityRows = <_RowBlueprint>[
  _RowBlueprint(
    userId: 'u_uni_1',
    username: 'Tahmid Ahmed',
    university: 'Dhaka University',
    level: 24,
    xp: 18450,
    coins: 9820,
    streak: 32,
    badges: _allBadges,
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_uni_2',
    username: 'Mehedi Hasan',
    university: 'Dhaka University',
    level: 22,
    xp: 16100,
    coins: 8760,
    streak: 22,
    badges: <String>['quiz_master'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_uni_3',
    username: 'Nazia Haque',
    university: 'BUET',
    level: 21,
    xp: 14820,
    coins: 7400,
    streak: 17,
    badges: <String>['mission_master'],
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_uni_4',
    username: 'Imran Hossain',
    university: 'Dhaka University',
    level: 20,
    xp: 13980,
    coins: 6940,
    streak: 14,
    badges: <String>['streak_legend'],
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_uni_5',
    username: 'Mim Akter',
    university: 'Rajshahi University',
    level: 19,
    xp: 12670,
    coins: 5810,
    streak: 11,
    badges: <String>['quiz_master'],
    rankShift: 2,
  ),
  _RowBlueprint(
    userId: 'u_uni_6',
    username: 'Sabbir Rahman',
    university: 'Chittagong University',
    level: 18,
    xp: 11430,
    coins: 5290,
    streak: 9,
    badges: <String>[],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_current_user',
    username: 'You',
    university: 'Dhaka University',
    level: 13,
    xp: 8640,
    coins: 3810,
    streak: 4,
    badges: <String>['streak_legend'],
    isCurrentUser: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_uni_7',
    username: 'Riyad Hossain',
    university: 'Khulna University',
    level: 11,
    xp: 7240,
    coins: 3120,
    streak: 6,
    badges: <String>[],
    rankShift: 1,
  ),
];

const List<_RowBlueprint> _nationalRows = <_RowBlueprint>[
  _RowBlueprint(
    userId: 'u_nat_1',
    username: 'Tahmid Ahmed',
    university: 'Dhaka University',
    level: 24,
    xp: 18450,
    coins: 9820,
    streak: 32,
    badges: _allBadges,
    isPremium: true,
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_nat_2',
    username: 'Nazia Haque',
    university: 'BUET',
    level: 21,
    xp: 16220,
    coins: 8400,
    streak: 18,
    badges: <String>['quiz_master'],
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_nat_3',
    username: 'Sabbir Rahman',
    university: 'Chittagong University',
    level: 19,
    xp: 14310,
    coins: 7710,
    streak: 12,
    badges: <String>['streak_legend'],
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_nat_4',
    username: 'Mim Akter',
    university: 'Rajshahi University',
    level: 18,
    xp: 12680,
    coins: 6240,
    streak: 9,
    badges: <String>['mission_master'],
    rankShift: 2,
  ),
  _RowBlueprint(
    userId: 'u_nat_5',
    username: 'Riyad Hossain',
    university: 'Khulna University',
    level: 16,
    xp: 11420,
    coins: 5870,
    streak: 7,
    badges: <String>[],
    rankShift: -2,
  ),
  _RowBlueprint(
    userId: 'u_nat_6',
    username: 'Sumaiya Khan',
    university: 'Jahangirnagar University',
    level: 14,
    xp: 9800,
    coins: 4210,
    streak: 5,
    badges: <String>['quiz_master'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_current_user',
    username: 'You',
    university: 'Dhaka University',
    level: 13,
    xp: 8640,
    coins: 3810,
    streak: 4,
    badges: <String>['streak_legend'],
    isCurrentUser: true,
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_nat_7',
    username: 'Arif Mahbub',
    university: 'National University',
    level: 12,
    xp: 7820,
    coins: 3290,
    streak: 3,
    badges: <String>[],
    rankShift: -1,
  ),
];

const List<_RowBlueprint> _weeklyRows = <_RowBlueprint>[
  _RowBlueprint(
    userId: 'u_weekly_1',
    username: 'Tahmid Ahmed',
    university: 'Dhaka University',
    level: 24,
    xp: 2140,
    coins: 1180,
    streak: 7,
    badges: <String>['quiz_master'],
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_weekly_2',
    username: 'Nazia Haque',
    university: 'BUET',
    level: 21,
    xp: 1980,
    coins: 980,
    streak: 7,
    badges: <String>['mission_master'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_weekly_3',
    username: 'Mim Akter',
    university: 'Rajshahi University',
    level: 18,
    xp: 1820,
    coins: 870,
    streak: 5,
    badges: <String>[],
    rankShift: 2,
  ),
  _RowBlueprint(
    userId: 'u_weekly_4',
    username: 'Sabbir Rahman',
    university: 'Chittagong University',
    level: 19,
    xp: 1640,
    coins: 760,
    streak: 4,
    badges: <String>['streak_legend'],
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_weekly_5',
    username: 'Sumaiya Khan',
    university: 'Jahangirnagar University',
    level: 14,
    xp: 1490,
    coins: 670,
    streak: 4,
    badges: <String>[],
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_weekly_6',
    username: 'Imran Hossain',
    university: 'Dhaka University',
    level: 20,
    xp: 1320,
    coins: 540,
    streak: 3,
    badges: <String>['quiz_master'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_current_user',
    username: 'You',
    university: 'Dhaka University',
    level: 13,
    xp: 1180,
    coins: 480,
    streak: 4,
    badges: <String>['streak_legend'],
    isCurrentUser: true,
    rankShift: 2,
  ),
  _RowBlueprint(
    userId: 'u_weekly_7',
    username: 'Riyad Hossain',
    university: 'Khulna University',
    level: 11,
    xp: 980,
    coins: 320,
    streak: 2,
    badges: <String>[],
    rankShift: -1,
  ),
];

const List<_RowBlueprint> _seasonalRows = <_RowBlueprint>[
  _RowBlueprint(
    userId: 'u_season_1',
    username: 'Tahmid Ahmed',
    university: 'Dhaka University',
    level: 24,
    xp: 58230,
    coins: 22410,
    streak: 92,
    badges: _allBadges,
    isPremium: true,
    rankShift: -1,
  ),
  _RowBlueprint(
    userId: 'u_season_2',
    username: 'Nazia Haque',
    university: 'BUET',
    level: 21,
    xp: 51280,
    coins: 19840,
    streak: 71,
    badges: <String>['quiz_master', 'streak_legend'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_season_3',
    username: 'Sabbir Rahman',
    university: 'Chittagong University',
    level: 19,
    xp: 47640,
    coins: 17920,
    streak: 64,
    badges: <String>['mission_master'],
    isPremium: true,
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_season_4',
    username: 'Mim Akter',
    university: 'Rajshahi University',
    level: 18,
    xp: 42180,
    coins: 15410,
    streak: 48,
    badges: <String>['streak_legend'],
    rankShift: -2,
  ),
  _RowBlueprint(
    userId: 'u_season_5',
    username: 'Riyad Hossain',
    university: 'Khulna University',
    level: 16,
    xp: 38420,
    coins: 13980,
    streak: 32,
    badges: <String>[],
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_season_6',
    username: 'Sumaiya Khan',
    university: 'Jahangirnagar University',
    level: 14,
    xp: 32140,
    coins: 11880,
    streak: 21,
    badges: <String>['quiz_master'],
    rankShift: 0,
  ),
  _RowBlueprint(
    userId: 'u_current_user',
    username: 'You',
    university: 'Dhaka University',
    level: 13,
    xp: 28430,
    coins: 10210,
    streak: 18,
    badges: <String>['streak_legend'],
    isCurrentUser: true,
    rankShift: 1,
  ),
  _RowBlueprint(
    userId: 'u_season_7',
    username: 'Arif Mahbub',
    university: 'National University',
    level: 12,
    xp: 24210,
    coins: 8480,
    streak: 12,
    badges: <String>[],
    rankShift: -1,
  ),
];