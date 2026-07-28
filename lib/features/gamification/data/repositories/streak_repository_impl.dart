import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/streak_entity.dart';
import '../../domain/entities/streak_state.dart';
import '../../domain/enums/streak_enums.dart';
import '../../domain/repositories/streak_resolver.dart';
import '../../domain/repositories/streak_repository.dart';
import '../../domain/services/system_streak_resolver.dart';
import '../../domain/value_objects/streak_recovery_result.dart';
import '../../domain/value_objects/streak_bonus_result.dart';
import '../datasources/streak_local_datasource.dart';
import '../datasources/streak_remote_datasource.dart';
import '../models/streak_model.dart';
import '../models/streak_state_model.dart';
import '../repositories/streak_bonus_catalog.dart';

/// Concrete [StreakRepository].
///
/// Owns the date math, shield / recovery-budget tracking, and the
/// remote-first → local-cache fallback strategy. The remote datasource
/// is the planned future home for synced streaks (Firestore); until
/// then every call resolves through the local datasource.
///
/// This repository deliberately does NOT touch the rewards engine —
/// it produces a result object ([StreakRecoveryResult] or
/// [StreakBonusResult]) that the controller hands to
/// [RewardsController.grantFromEvent] for celebration UI.
class StreakRepositoryImpl implements StreakRepository {
  StreakRepositoryImpl({
    required StreakLocalDataSource local,
    StreakRemoteDataSource? remote,
    StreakResolver? resolver,
    StreakBonusCatalog? catalog,
    bool preferRemote = false,
  })  : _local = local,
        _remote = remote,
        _resolver = resolver ?? const SystemStreakResolver(),
        _catalog = catalog ?? const StreakBonusCatalog(),
        _preferRemote = preferRemote;

  final StreakLocalDataSource _local;
  final StreakRemoteDataSource? _remote;
  final StreakResolver _resolver;
  final StreakBonusCatalog _catalog;
  final bool _preferRemote;

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  @override
  Future<Result<StreakState>> load() async {
    try {
      final StreakStateModel raw = _readState();
      return Result.success(raw.toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<StreakEntity>>> loadBonusLedger() async {
    try {
      final List<StreakModel> rows = _readLedger();
      return Result.success(
        List<StreakEntity>.unmodifiable(
          rows.map((StreakModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Writes
  // ---------------------------------------------------------------------------

  @override
  Future<Result<StreakState>> updateDaily() async {
    try {
      final DateTime now = _local.now();
      final StreakStateModel raw = _readState();
      final StreakState current = raw.toEntity();
      if (_resolver.isToday(current.lastClaimedAtIso, now: now)) {
        return Result.failure(
          const ValidationFailure("Today's reward is already claimed."),
        );
      }

      final int daysSince =
          _resolver.daysSince(current.lastClaimedAtIso, now: now);
      int nextCurrent = current.currentDays;
      int nextShields = current.shieldCharges;
      int nextRecovery = current.recoveryUsedThisWeek;

      if (current.lastClaimedAtIso.isEmpty) {
        nextCurrent = 1;
      } else if (daysSince == 1) {
        nextCurrent = current.currentDays + 1;
      } else if (daysSince > 1) {
        if (current.shieldCharges > 0) {
          nextShields = current.shieldCharges - 1;
          nextCurrent = current.currentDays + 1;
        } else {
          nextCurrent = 1;
          nextRecovery = 0;
        }
      }

      final int nextBest =
          nextCurrent > current.bestDays ? nextCurrent : current.bestDays;
      final int nextMilestone = _catalog.nextMilestone(nextCurrent);

      final StreakStateModel updated = StreakStateModel(
        currentDays: nextCurrent,
        bestDays: nextBest,
        lastClaimedAtIso: now.toIso8601String(),
        shieldCharges: nextShields,
        recoveryUsedThisWeek: nextRecovery,
        nextMilestoneDays: nextMilestone,
        statusId: _todayStatusId(),
        calendarDaysIso: const <String>[],
      );
      _writeState(_local.decorateCalendar(updated));
      return Result.success(_readState().toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<StreakRecoveryResult>> recover({
    required RecoveryMethod method,
  }) async {
    try {
      final StreakStateModel raw = _readState();
      final StreakState current = raw.toEntity();
      if (current.currentDays > 0) {
        return Result.failure(
          const ValidationFailure(
            'Streak is still active — nothing to recover.',
          ),
        );
      }
      if (current.recoveryUsedThisWeek >= 2) {
        return Result.failure(
          const ValidationFailure(
            'Weekly recovery limit reached. Try again next week.',
          ),
        );
      }

      final StreakStateModel recovered = StreakStateModel(
        currentDays: 1,
        bestDays: current.bestDays,
        lastClaimedAtIso: _local.now().toIso8601String(),
        shieldCharges: method == RecoveryMethod.coins
            ? current.shieldCharges
            : (current.shieldCharges + 1),
        recoveryUsedThisWeek: current.recoveryUsedThisWeek + 1,
        nextMilestoneDays: _catalog.nextMilestone(1),
        statusId: _todayStatusId(),
        calendarDaysIso: const <String>[],
      );
      _writeState(_local.decorateCalendar(recovered));

      return Result.success(
        StreakRecoveryResult(
          state: _readState().toEntity(),
          method: method,
          coinCost: method == RecoveryMethod.coins ? 25 : 0,
          badgeId: null,
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<StreakBonusResult>> claimBonus({
    required int day,
    required StreakBonusType type,
  }) async {
    try {
      final StreakEntity? entity = _catalog.findByDayAndType(day, type);
      if (entity == null) {
        return Result.failure(
          ValidationFailure('No streak bonus for day $day ($type).'),
        );
      }
      final StreakStateModel raw = _readState();
      final StreakState current = raw.toEntity();
      if (current.currentDays < day) {
        return Result.failure(
          const ValidationFailure(
            'Streak has not yet reached the required day.',
          ),
        );
      }
      final StreakModel existing = _readLedger().firstWhere(
            (StreakModel m) => m.id == entity.id,
            orElse: () => StreakModel.fromEntity(entity),
          );
      if (existing.claimed) {
        return Result.failure(
          const ValidationFailure('Bonus already claimed.'),
        );
      }
      final StreakModel claimed = StreakModel(
        id: existing.id,
        typeId: existing.typeId,
        day: existing.day,
        xp: existing.xp,
        coins: existing.coins,
        badgeId: existing.badgeId,
        claimed: true,
      );
      _writeBonus(claimed);
      return Result.success(
        StreakBonusResult(
          bonus: entity.copyWith(claimed: true),
          day: day,
          type: type,
          xp: existing.xp,
          coins: existing.coins,
          badgeId: existing.badgeId,
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  String _todayStatusId() => 'claimed';

  StreakStateModel _readState() {
    if (_preferRemote && _remote != null) {
      try {
        return _remote.readState();
      } catch (_) {
        return _local.readState();
      }
    }
    return _local.readState();
  }

  void _writeState(StreakStateModel model) {
    if (_preferRemote && _remote != null) {
      try {
        _remote.writeState(model);
        return;
      } catch (_) {
        _local.writeState(model);
        return;
      }
    }
    _local.writeState(model);
  }

  List<StreakModel> _readLedger() {
    if (_preferRemote && _remote != null) {
      try {
        return _remote.readBonusLedger();
      } catch (_) {
        return _local.readBonusLedger();
      }
    }
    return _local.readBonusLedger();
  }

  void _writeBonus(StreakModel model) {
    if (_preferRemote && _remote != null) {
      try {
        _remote.writeBonus(model);
        return;
      } catch (_) {
        _local.writeBonus(model);
        return;
      }
    }
    _local.writeBonus(model);
  }
}