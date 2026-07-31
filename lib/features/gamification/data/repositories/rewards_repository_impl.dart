import 'dart:math';

import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/badge_catalog.dart';
import '../../domain/entities/badge_entry.dart';
import '../../domain/entities/chest_entry.dart';
import '../../domain/entities/level_progress.dart';
import '../../domain/entities/reward.dart';
import '../../domain/entities/reward_event.dart';
import '../../domain/entities/reward_history_entry.dart';
import '../../domain/entities/reward_outcome.dart';
import '../../domain/entities/streak_state.dart';
import '../../domain/entities/user_rewards_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/repositories/rewards_repository.dart';
import '../../domain/repositories/streak_resolver.dart';
import '../../domain/services/reward_rule_catalog.dart';
import '../../domain/services/system_streak_resolver.dart';
import '../datasources/rewards_local_datasource.dart';
import '../models/badge_entry_model.dart';
import '../models/level_progress_model.dart';
import '../models/reward_history_entry_model.dart';
import '../models/streak_state_model.dart';
import '../models/user_rewards_state_model.dart';

/// Concrete repository — owns the reward engine, persists every grant
/// through the datasource, and never throws: failures come back as
/// `Result.failure`.
class RewardsRepositoryImpl implements RewardsRepository {
  RewardsRepositoryImpl({
    required RewardsLocalDataSource datasource,
    RewardRuleCatalog? catalog,
    RarityTable? rarityTable,
    BadgeCatalog? badgeCatalog,
    StreakResolver? streakResolver,
    Random? random,
  })  : _datasource = datasource,
        _catalog = catalog ?? const RewardRuleCatalog(),
        _rarityTable = rarityTable ?? const RarityTable(),
        _badgeCatalog = badgeCatalog ?? const BadgeCatalog(),
        _streakResolver = streakResolver ?? const SystemStreakResolver(),
        _random = random ?? Random();

  final RewardsLocalDataSource _datasource;
  final RewardRuleCatalog _catalog;
  final RarityTable _rarityTable;
  final BadgeCatalog _badgeCatalog;
  final StreakResolver _streakResolver;
  final Random _random;

  // ---------------------------------------------------------------------------
  // Catalog reads
  // ---------------------------------------------------------------------------

  @override
  Future<Result<List<DailyRewardTemplate>>> loadDailyRewardTemplate() async {
    return Result.success(_dailyRewardTemplate);
  }

  @override
  Future<Result<List<ChestTemplate>>> loadChestTemplates() async {
    return Result.success(_chestTemplates);
  }

  @override
  Future<Result<LevelProgress>> previewNextLevel(int xp) async {
    return Result.success(_catalog.levelFor(xp));
  }

  // ---------------------------------------------------------------------------
  // State load / history
  // ---------------------------------------------------------------------------

  @override
  Future<Result<UserRewardsState>> loadState() async {
    try {
      return Result.success(_datasource.read().toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<RewardHistoryEntry>>> loadHistory({int limit = 50}) async {
    try {
      final List<RewardHistoryEntry> rows = _datasource
          .read()
          .history
          .map((RewardHistoryEntryModel m) => m.toEntity())
          .toList();
      final List<RewardHistoryEntry> truncated =
          rows.take(limit).toList(growable: false);
      return Result.success(List<RewardHistoryEntry>.unmodifiable(truncated));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Reward engine — grant / open / claim
  // ---------------------------------------------------------------------------

  @override
  Future<Result<RewardOutcome>> grantFromTrigger({
    required RewardTrigger trigger,
    required RewardTriggerData data,
    required UserRewardsState currentState,
  }) async {
    try {
      final RewardRule? rule = _catalog.findByTrigger(trigger);
      if (rule == null) {
        return Result.success(_noop(currentState));
      }
      final List<Reward> grants = _computeGrants(rule: rule, data: data);
      final RewardOutcome outcome = _apply(
        currentState: currentState,
        grants: grants,
        sourceLabel: _labelForTrigger(trigger, data),
        contextKey: _contextKeyFor(trigger, data),
      );
      _persist(outcome.stateAfter);
      return Result.success(outcome);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<RewardOutcome>> openChest({
    required String chestId,
    required UserRewardsState currentState,
  }) async {
    try {
      final int chestIndex = currentState.chests
          .indexWhere((ChestEntry c) => c.id == chestId);
      if (chestIndex == -1) {
        return Result.success(_noop(currentState));
      }
      final ChestEntry chest = currentState.chests[chestIndex];
      if (chest.status == ChestStatus.opened ||
          chest.status == ChestStatus.claimed) {
        return Result.success(_noop(currentState));
      }
      final List<Reward> contents = _rollChest(chest);
      final RewardOutcome outcome = _apply(
        currentState: currentState,
        grants: contents,
        sourceLabel: 'Chest opened',
        contextKey: 'chest:$chestId',
        celebrateChest: true,
      );
      _persist(outcome.stateAfter);
      return Result.success(outcome);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<RewardOutcome>> claimDailyReward({
    required int day,
    required UserRewardsState currentState,
  }) async {
    try {
      final DateTime now = _datasource.now();
      if (_streakResolver.isToday(currentState.streak.lastClaimedAtIso,
          now: now)) {
        return Result.success(_noop(currentState));
      }
      final DailyRewardTemplate? template = _dailyRewardTemplate
          .where((DailyRewardTemplate t) => t.day == day)
          .cast<DailyRewardTemplate?>()
          .firstWhere((DailyRewardTemplate? t) => t != null, orElse: () => null);
      if (template == null) {
        return Result.success(_noop(currentState));
      }
      final List<Reward> grants = <Reward>[
        XpReward(
          id: 'daily-xp-$day-${now.millisecondsSinceEpoch}',
          title: 'Daily XP',
          rarity: RewardRarity.common,
          amount: template.xp,
        ),
        CoinReward(
          id: 'daily-coin-$day-${now.millisecondsSinceEpoch}',
          title: 'Daily coins',
          rarity: RewardRarity.common,
          amount: template.coins,
        ),
      ];
      final UserRewardsState nextState = currentState.copyWith(
        streak: StreakState(
          currentDays: (currentState.streak.currentDays + 1).clamp(1, 7),
          bestDays:
              currentState.streak.bestDays < currentState.streak.currentDays + 1
                  ? currentState.streak.currentDays + 1
                  : currentState.streak.bestDays,
          lastClaimedAtIso: now.toIso8601String(),
          shieldCharges: currentState.streak.shieldCharges,
          status: DailyRewardStatus.claimed,
        ),
      );
      final RewardOutcome outcome = _apply(
        currentState: nextState,
        grants: grants,
        sourceLabel: 'Daily reward (Day $day)',
        contextKey: 'daily:$day',
      );
      _persist(outcome.stateAfter);
      return Result.success(outcome);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<bool>> toggleBadgeFavorite(String badgeId) async {
    try {
      final UserRewardsStateModel model = _datasource.read();
      final Set<String> favorites = Set<String>.of(model.favoriteBadgeIds);
      final bool nowFav = !favorites.contains(badgeId);
      if (nowFav) {
        favorites.add(badgeId);
      } else {
        favorites.remove(badgeId);
      }
      final List<BadgeEntryModel> updatedBadges = <BadgeEntryModel>[
        for (final BadgeEntryModel b in model.badges)
          if (b.id == badgeId)
            BadgeEntryModel(
              id: b.id,
              title: b.title,
              description: b.description,
              iconKey: b.iconKey,
              rarityId: b.rarityId,
              earnedAtIso: b.earnedAtIso,
              category: b.category,
              isFavorite: nowFav,
            )
          else
            b,
      ];
      _datasource.write(UserRewardsStateModel(
        totalXP: model.totalXP,
        totalCoins: 0,
        level: model.level,
        streak: model.streak,
        badges: updatedBadges,
        chests: model.chests,
        history: model.history,
        favoriteBadgeIds: favorites,
      ));
      return Result.success(nowFav);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Reward math
  // ---------------------------------------------------------------------------

  List<Reward> _computeGrants({
    required RewardRule rule,
    required RewardTriggerData data,
  }) {
    final List<Reward> out = <Reward>[];
    double xpMultiplier = 1.0;
    int bonusXP = 0;

    if (data is QuizCompletedData) {
      xpMultiplier = rule.difficultyMultiplier[data.difficultyId] ?? 1.0;
      if (data.isPerfect) bonusXP += rule.perfectBonusXP;
      bonusXP += (data.streakDays.clamp(0, rule.streakBonusCap)) *
          rule.streakBonusPerDay;
    }

    final int xpAmount = (rule.baseXP * xpMultiplier + bonusXP).round();
    final int coinAmount = rule.baseCoins;

    if (xpAmount > 0) {
      out.add(XpReward(
        id: '${rule.id}-xp',
        title: 'Quiz XP',
        rarity: RewardRarity.common,
        amount: xpAmount,
        bonusLabel: data is QuizCompletedData && data.isPerfect
            ? 'Perfect score bonus'
            : null,
      ));
    }
    if (coinAmount > 0) {
      out.add(CoinReward(
        id: '${rule.id}-coin',
        title: 'Quiz coins',
        rarity: RewardRarity.common,
        amount: coinAmount,
      ));
    }

    for (final RewardDrop drop in rule.drops) {
      final double pick = _random.nextDouble();
      if (pick <= drop.probability) {
        final BadgeDefinition? def = _badgeCatalog.byId(drop.badgeId);
        if (def == null) continue;
        out.add(BadgeReward(
          id: '${rule.id}-${def.id}',
          title: def.title,
          rarity: def.rarity,
          iconKey: def.iconKey,
          description: def.description,
          category: def.category,
        ));
      }
    }

    return out;
  }

  List<Reward> _rollChest(ChestEntry chest) {
    final List<Reward> rolled = <Reward>[];
    for (int i = 0; i < 3; i++) {
      final RewardRarity rarity = _rarityTable.roll(_random.nextInt(100));
      rolled.add(_makeChestRoll(chest.id, i, rarity));
    }
    return rolled;
  }

  Reward _makeChestRoll(String chestId, int slot, RewardRarity rarity) {
    final int roll = _random.nextInt(100);
    if (roll < 50) {
      return CoinReward(
        id: '$chestId-roll-$slot',
        title: 'Bonus coins',
        rarity: rarity,
        amount: 10 + _random.nextInt(50),
      );
    }
    if (roll < 85) {
      return XpReward(
        id: '$chestId-roll-$slot',
        title: 'Bonus XP',
        rarity: rarity,
        amount: 25 + _random.nextInt(75),
      );
    }
    return UnlockReward(
      id: '$chestId-roll-$slot',
      title: 'Cosmetic unlock',
      rarity: rarity,
      unlockKey: 'cosmetic-$chestId-$slot',
      subtitle: 'New profile accent unlocked',
    );
  }

  // ---------------------------------------------------------------------------
  // Apply grants → new state
  // ---------------------------------------------------------------------------

  RewardOutcome _apply({
    required UserRewardsState currentState,
    required List<Reward> grants,
    required String sourceLabel,
    required String? contextKey,
    bool celebrateChest = false,
  }) {
    int xpDelta = 0;
    final List<BadgeEntry> newBadges = <BadgeEntry>[...currentState.badges];
    final Set<String> existingIds =
        currentState.badges.map((BadgeEntry b) => b.id).toSet();
    final List<ChestEntry> newChests = <ChestEntry>[...currentState.chests];
    bool leveledUp = false;
    bool showBadgeUnlock = false;
    bool showChest = celebrateChest;

    for (final Reward grant in grants) {
      switch (grant) {
        case XpReward xp:
          xpDelta += xp.amount;
        case CoinReward _:
          break;
        case BadgeReward badge:
          if (!existingIds.contains(badge.id)) {
            newBadges.add(BadgeEntry(
              id: badge.id,
              title: badge.title,
              description: badge.description,
              iconKey: badge.iconKey,
              rarity: badge.rarity,
              earnedAtIso: DateTime.now().toIso8601String(),
              category: badge.category,
            ));
            existingIds.add(badge.id);
            showBadgeUnlock = true;
          }
        case UnlockReward _:
          showBadgeUnlock = showBadgeUnlock;
        case ChestReward chest:
          final int idx = newChests.indexWhere((ChestEntry c) => c.id == chest.id);
          if (idx != -1) {
            newChests[idx] = newChests[idx].copyWith(status: ChestStatus.opened);
          }
          showChest = true;
        case DailyRewardEntry _:
          break;
      }
    }

    final int newTotalXP = currentState.totalXP + xpDelta;
    final LevelProgress nextLevel = _catalog.levelFor(newTotalXP);
    if (nextLevel.currentLevel > currentState.level.currentLevel) {
      leveledUp = true;
    }

    final RewardHistoryEntry history = RewardHistoryEntry(
      id: 'history-${DateTime.now().millisecondsSinceEpoch}',
      grantedAtIso: DateTime.now().toIso8601String(),
      sourceLabel: sourceLabel,
      contextKey: contextKey,
      grants: grants,
    );

    final UserRewardsState newState = currentState.copyWith(
      totalXP: newTotalXP,
      level: nextLevel,
      badges: newBadges,
      chests: newChests,
      history: <RewardHistoryEntry>[history, ...currentState.history],
    );

    final CelebrationSpec celebration = CelebrationSpec(
      confetti: leveledUp || grants.any((Reward r) => r is ChestReward),
      showLevelUpDialog: leveledUp,
      showBadgeUnlock: showBadgeUnlock,
      showChestOpen: showChest,
    );

    return RewardOutcome(
      grants: grants,
      stateBefore: currentState,
      stateAfter: newState,
      celebration: celebration,
    );
  }

  RewardOutcome _noop(UserRewardsState state) {
    return RewardOutcome(
      grants: const <Reward>[],
      stateBefore: state,
      stateAfter: state,
      celebration: CelebrationSpec.none,
    );
  }

  void _persist(UserRewardsState state) {
    final UserRewardsStateModel previous = _datasource.read();
    _datasource.write(UserRewardsStateModel(
      totalXP: state.totalXP,
      totalCoins: 0,
      level: LevelProgressModel(
        currentLevel: state.level.currentLevel,
        currentXP: state.level.currentXP,
        nextLevelXP: state.level.nextLevelXP,
      ),
      streak: StreakStateModel(
        currentDays: state.streak.currentDays,
        bestDays: state.streak.bestDays,
        lastClaimedAtIso: state.streak.lastClaimedAtIso,
        shieldCharges: state.streak.shieldCharges,
        statusId: state.streak.status.name,
      ),
      badges: state.badges
          .map((BadgeEntry b) => BadgeEntryModel(
                id: b.id,
                title: b.title,
                description: b.description,
                iconKey: b.iconKey,
                rarityId: b.rarity.name,
                earnedAtIso: b.earnedAtIso,
                category: b.category,
                isFavorite: b.isFavorite,
              ))
          .toList(growable: false),
      chests: previous.chests,
      history: state.history
          .take(50)
          .map((RewardHistoryEntry h) => RewardHistoryEntryModel(
                id: h.id,
                grantedAtIso: h.grantedAtIso,
                sourceLabel: h.sourceLabel,
                contextKey: h.contextKey,
                grantDump: h.grants,
              ))
          .toList(growable: false),
      favoriteBadgeIds: state.favoriteBadgeIds,
    ));
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  String _labelForTrigger(RewardTrigger trigger, RewardTriggerData data) {
    switch (trigger) {
      case RewardTrigger.quizCompleted:
        return 'Quiz completed';
      case RewardTrigger.lessonCompleted:
        return 'Lesson completed';
      case RewardTrigger.missionCompleted:
        return 'Mission completed';
      case RewardTrigger.levelCompleted:
        return 'Level completed';
      case RewardTrigger.dailyLogin:
        return 'Daily login';
      case RewardTrigger.badgeEarned:
        return 'Badge earned';
      case RewardTrigger.chestOpened:
        return 'Chest opened';
    }
  }

  String? _contextKeyFor(RewardTrigger trigger, RewardTriggerData data) {
    switch (data) {
      case QuizCompletedData q:
        return 'quiz:${q.correctAnswers}/${q.totalQuestions}';
      case LessonCompletedData l:
        return 'lesson:${l.lessonId}';
      case MissionCompletedData m:
        return 'mission:${m.missionId}';
      case LevelCompletedData l:
        return 'level:${l.levelId}';
      case DailyLoginData d:
        return 'daily:${d.day}';
      case BadgeEarnedData b:
        return 'badge:${b.badgeId}';
      case ChestOpenedData c:
        return 'chest:${c.chestId}';
    }
  }

  static const List<DailyRewardTemplate> _dailyRewardTemplate =
      <DailyRewardTemplate>[
    DailyRewardTemplate(day: 1, xp: 25, coins: 10, title: 'Day 1'),
    DailyRewardTemplate(day: 2, xp: 35, coins: 15, title: 'Day 2'),
    DailyRewardTemplate(day: 3, xp: 50, coins: 20, title: 'Day 3'),
    DailyRewardTemplate(
        day: 4, xp: 75, coins: 30, title: 'Day 4', badgeIconKey: 'streak'),
    DailyRewardTemplate(day: 5, xp: 100, coins: 40, title: 'Day 5'),
    DailyRewardTemplate(day: 6, xp: 130, coins: 55, title: 'Day 6'),
    DailyRewardTemplate(
        day: 7,
        xp: 200,
        coins: 100,
        title: 'Day 7 (jackpot)',
        badgeIconKey: 'crown'),
  ];

  static final List<ChestTemplate> _chestTemplates = <ChestTemplate>[
    ChestTemplate(
      id: 'chest-welcome-1',
      title: 'Starter chest',
      rarityId: 'common',
      previewRolls: const <Reward>[],
    ),
    ChestTemplate(
      id: 'chest-first-clear-1',
      title: 'Level-clear chest',
      rarityId: 'rare',
      previewRolls: const <Reward>[],
    ),
  ];
}