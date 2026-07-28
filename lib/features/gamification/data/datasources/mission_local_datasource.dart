import '../../domain/enums/mission_enums.dart';
import '../../domain/services/mission_clock.dart';
import '../../domain/services/mission_cycle_calculator.dart';
import '../models/mission_model.dart';

/// In-memory source of truth for daily / weekly / monthly missions.
///
/// The current production app has no backend for gamification, so
/// every repository call resolves through a deterministic seeded set.
/// A future network-backed datasource will implement the same surface;
/// no consumer code needs to change.
class MissionLocalDataSource {
  MissionLocalDataSource({
    MissionClock? clock,
    MissionCycleCalculator? calculator,
  })  : _clock = clock ?? const SystemMissionClock(),
        _calculator = calculator ?? const MissionCycleCalculator();

  final MissionClock _clock;
  final MissionCycleCalculator _calculator;

  final Map<String, MissionModel> _missions = <String, MissionModel>{};

  bool _seeded = false;

  List<MissionModel> readAll() {
    _ensureSeeded();
    return List<MissionModel>.unmodifiable(_missions.values);
  }

  List<MissionModel> readByCadence(MissionCadence cadence) {
    return readAll()
        .where((MissionModel m) => m.cadenceId == cadence.name)
        .toList(growable: false);
  }

  MissionModel? readById(String id) {
    _ensureSeeded();
    return _missions[id];
  }

  void write(MissionModel model) {
    _missions[model.id] = model;
  }

  DateTime now() => _clock.now();

  DateTime nextResetAfter(MissionCadence cadence) {
    return _calculator.nextResetAfter(cadence, from: _clock.now());
  }

  void reset() {
    _missions.clear();
    _seeded = false;
  }

  // ---------------------------------------------------------------------------
  // Seed
  // ---------------------------------------------------------------------------

  void _ensureSeeded() {
    if (_seeded) return;
    _seeded = true;
    final DateTime now = _clock.now();
    for (final MissionModel m in _seed(now)) {
      _missions[m.id] = m;
    }
  }

  List<MissionModel> _seed(DateTime now) {
    final DateTime dailyEnd = _calculator.nextResetAfter(
      MissionCadence.daily,
      from: now,
    );
    final DateTime weeklyEnd = _calculator.nextResetAfter(
      MissionCadence.weekly,
      from: now,
    );
    final DateTime monthlyEnd = _calculator.nextResetAfter(
      MissionCadence.monthly,
      from: now,
    );

    final String dailyIso = dailyEnd.toIso8601String();
    final String weeklyIso = weeklyEnd.toIso8601String();
    final String monthlyIso = monthlyEnd.toIso8601String();

    return <MissionModel>[
      // Daily ----------------------------------------------------------------
      const MissionModel(
        id: 'daily-quiz-1',
        title: 'Answer 1 quiz',
        description: 'Finish any single quiz end-to-end.',
        categoryId: 'quiz',
        cadenceId: 'daily',
        statusId: 'available',
        progress: 0,
        goal: 1,
        rewardXp: 20,
        rewardCoins: 8,
        rewardEnergy: 0,
        expiresAtIso: '__daily__',
      ).withExpiry(dailyIso),
      const MissionModel(
        id: 'daily-xp-50',
        title: 'Earn 50 XP',
        description: 'Reach a cumulative 50 XP from any activity.',
        categoryId: 'lesson',
        cadenceId: 'daily',
        statusId: 'available',
        progress: 0,
        goal: 50,
        rewardXp: 15,
        rewardCoins: 5,
        rewardEnergy: 0,
        expiresAtIso: '__daily__',
      ).withExpiry(dailyIso),
      const MissionModel(
        id: 'daily-streak-1',
        title: 'Win 1 streak',
        description: 'Hit a streak on any quiz round.',
        categoryId: 'streak',
        cadenceId: 'daily',
        statusId: 'available',
        progress: 0,
        goal: 1,
        rewardXp: 10,
        rewardCoins: 6,
        rewardEnergy: 1,
        expiresAtIso: '__daily__',
      ).withExpiry(dailyIso),

      // Weekly ---------------------------------------------------------------
      const MissionModel(
        id: 'weekly-quiz-7',
        title: 'Complete 7 quizzes',
        description: 'Finish seven quizzes this week.',
        categoryId: 'quiz',
        cadenceId: 'weekly',
        statusId: 'available',
        progress: 0,
        goal: 7,
        rewardXp: 80,
        rewardCoins: 30,
        rewardEnergy: 0,
        expiresAtIso: '__weekly__',
      ).withExpiry(weeklyIso),
      const MissionModel(
        id: 'weekly-xp-500',
        title: 'Earn 500 XP',
        description: 'Bank 500 XP over the week.',
        categoryId: 'lesson',
        cadenceId: 'weekly',
        statusId: 'available',
        progress: 0,
        goal: 500,
        rewardXp: 60,
        rewardCoins: 25,
        rewardEnergy: 0,
        expiresAtIso: '__weekly__',
        rewardBadgeId: 'mission_master',
      ).withExpiry(weeklyIso),
      const MissionModel(
        id: 'weekly-streak-5',
        title: 'Maintain a 5-day streak',
        description: 'Log in five days in a row.',
        categoryId: 'streak',
        cadenceId: 'weekly',
        statusId: 'available',
        progress: 0,
        goal: 5,
        rewardXp: 70,
        rewardCoins: 20,
        rewardEnergy: 2,
        expiresAtIso: '__weekly__',
      ).withExpiry(weeklyIso),

      // Monthly --------------------------------------------------------------
      const MissionModel(
        id: 'monthly-quiz-20',
        title: 'Complete 20 quizzes',
        description: 'Tackle twenty quizzes this month.',
        categoryId: 'quiz',
        cadenceId: 'monthly',
        statusId: 'available',
        progress: 0,
        goal: 20,
        rewardXp: 200,
        rewardCoins: 90,
        rewardEnergy: 5,
        expiresAtIso: '__monthly__',
        rewardChestId: 'chest-first-clear-1',
      ).withExpiry(monthlyIso),
      const MissionModel(
        id: 'monthly-xp-2000',
        title: 'Earn 2000 XP',
        description: 'Bank 2000 XP across the month.',
        categoryId: 'lesson',
        cadenceId: 'monthly',
        statusId: 'available',
        progress: 0,
        goal: 2000,
        rewardXp: 250,
        rewardCoins: 120,
        rewardEnergy: 5,
        expiresAtIso: '__monthly__',
        specialKey: 'monthly_master',
      ).withExpiry(monthlyIso),
    ];
  }
}

extension _MissionModelSeed on MissionModel {
  MissionModel withExpiry(String iso) {
    return MissionModel(
      id: id,
      title: title,
      description: description,
      categoryId: categoryId,
      cadenceId: cadenceId,
      statusId: statusId,
      progress: progress,
      goal: goal,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      rewardEnergy: rewardEnergy,
      expiresAtIso: iso,
      rewardBadgeId: rewardBadgeId,
      rewardChestId: rewardChestId,
      specialKey: specialKey,
    );
  }
}