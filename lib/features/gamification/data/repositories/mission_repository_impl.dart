import '../../../../core/errors/error_handler.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/mission_entity.dart';
import '../../domain/entities/mission_progress_entity.dart';
import '../../domain/entities/mission_reward_entity.dart';
import '../../domain/enums/mission_enums.dart';
import '../../domain/repositories/mission_repository.dart';
import '../../domain/services/mission_cycle_calculator.dart';
import '../datasources/mission_local_datasource.dart';
import '../datasources/mission_remote_datasource.dart';
import '../models/mission_model.dart';
import '../models/mission_reward_model.dart';

/// Concrete [MissionRepository].
///
/// Owns reset-on-load, progress clamping, claim guard rails, and the
/// remote-first → local-cache fallback strategy. The remote datasource
/// is the planned future home for synced missions (Firestore); until
/// then every call resolves through the local datasource.
class MissionRepositoryImpl implements MissionRepository {
  MissionRepositoryImpl({
    required MissionLocalDataSource local,
    MissionRemoteDataSource? remote,
    MissionCycleCalculator? calculator,
    bool preferRemote = false,
  })  : _local = local,
        _remote = remote,
        _calculator = calculator ?? const MissionCycleCalculator(),
        _preferRemote = preferRemote;

  final MissionLocalDataSource _local;
  final MissionRemoteDataSource? _remote;
  final MissionCycleCalculator _calculator;
  final bool _preferRemote;

  // ---------------------------------------------------------------------------
  // Reads
  // ---------------------------------------------------------------------------

  @override
  Future<Result<MissionBundle>> loadAll() async {
    try {
      _sweepExpired();
      final List<MissionModel> all = _readAll();
      return Result.success(_bundle(all));
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<MissionEntity>>> loadByCadence(
    MissionCadence cadence,
  ) async {
    try {
      _sweepExpired();
      final List<MissionModel> rows = _readByCadence(cadence);
      return Result.success(
        List<MissionEntity>.unmodifiable(
          rows.map((MissionModel m) => m.toEntity()),
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
  Future<Result<MissionProgressEntity>> updateProgress({
    required String missionId,
    required int delta,
  }) async {
    try {
      final MissionModel? existing = _local.readById(missionId);
      if (existing == null) {
        return Result.failure(
          const ValidationFailure('Mission not found.'),
        );
      }
      if (existing.statusId == MissionStatus.claimed.name ||
          existing.statusId == MissionStatus.expired.name) {
        return Result.failure(
          const ValidationFailure('Mission already finalized.'),
        );
      }
      final int nextProgress = (existing.progress + delta).clamp(0, existing.goal);
      final MissionStatus nextStatus = nextProgress >= existing.goal
          ? MissionStatus.completed
          : (nextProgress > 0
              ? MissionStatus.inProgress
              : MissionStatus.available);
      final DateTime now = _local.now();
      final MissionModel updated = _copyWith(
        existing,
        progress: nextProgress,
        statusId: nextStatus.name,
      );
      _write(updated);
      final MissionProgressEntity progress = MissionProgressEntity(
        missionId: missionId,
        currentValue: nextProgress,
        targetValue: existing.goal,
        updatedAtIso: now.toIso8601String(),
      );
      return Result.success(progress);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<MissionRewardEntity>> claim({required String missionId}) async {
    try {
      final MissionModel? existing = _local.readById(missionId);
      if (existing == null) {
        return Result.failure(
          const ValidationFailure('Mission not found.'),
        );
      }
      if (existing.statusId != MissionStatus.completed.name) {
        return Result.failure(
          const ValidationFailure('Mission is not ready to claim.'),
        );
      }
      final MissionModel claimed = _copyWith(
        existing,
        statusId: MissionStatus.claimed.name,
      );
      _write(claimed);
      return Result.success(
        MissionRewardModel(
          xp: existing.rewardXp,
          coins: existing.rewardCoins,
          energy: existing.rewardEnergy,
          badgeId: existing.rewardBadgeId,
          chestId: existing.rewardChestId,
          specialKey: existing.specialKey,
        ).toEntity(),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<int>> resetExpired() async {
    try {
      final int count = _sweepExpired();
      return Result.success(count);
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  int _sweepExpired() {
    final DateTime now = _local.now();
    int swept = 0;
    for (final MissionModel model in _local.readAll()) {
      if (!_calculator.hasExpired(model.expiresAtIso, now: now)) continue;
      if (model.statusId == MissionStatus.claimed.name) continue;
      final MissionModel fresh = _copyWith(
        model,
        progress: 0,
        statusId: MissionStatus.available.name,
        expiresAtIso: _calculator
            .nextResetAfter(_cadenceFromId(model.cadenceId), from: now)
            .toIso8601String(),
      );
      _write(fresh);
      swept += 1;
    }
    return swept;
  }

  List<MissionModel> _readAll() {
    if (_preferRemote && _remote != null) {
      try {
        return _remote.readAll();
      } catch (_) {
        // Remote not implemented yet — fall through to the local cache.
        return _local.readAll();
      }
    }
    return _local.readAll();
  }

  List<MissionModel> _readByCadence(MissionCadence cadence) {
    if (_preferRemote && _remote != null) {
      try {
        return _remote.readByCadence(cadence);
      } catch (_) {
        return _local.readByCadence(cadence);
      }
    }
    return _local.readByCadence(cadence);
  }

  void _write(MissionModel model) {
    if (_preferRemote && _remote != null) {
      try {
        _remote.write(model);
        return;
      } catch (_) {
        // fall through to local persistence
      }
    }
    _local.write(model);
  }

  MissionBundle _bundle(List<MissionModel> all) {
    final DateTime now = _local.now();
    return MissionBundle(
      daily: all
          .where((MissionModel m) => m.cadenceId == MissionCadence.daily.name)
          .map((MissionModel m) => m.toEntity())
          .toList(growable: false),
      weekly: all
          .where((MissionModel m) => m.cadenceId == MissionCadence.weekly.name)
          .map((MissionModel m) => m.toEntity())
          .toList(growable: false),
      monthly: all
          .where((MissionModel m) =>
              m.cadenceId == MissionCadence.monthly.name)
          .map((MissionModel m) => m.toEntity())
          .toList(growable: false),
      nextDailyReset:
          _calculator.nextResetAfter(MissionCadence.daily, from: now),
      nextWeeklyReset:
          _calculator.nextResetAfter(MissionCadence.weekly, from: now),
      nextMonthlyReset:
          _calculator.nextResetAfter(MissionCadence.monthly, from: now),
    );
  }

  MissionCadence _cadenceFromId(String id) {
    for (final MissionCadence c in MissionCadence.values) {
      if (c.name == id) return c;
    }
    return MissionCadence.daily;
  }

  MissionModel _copyWith(
    MissionModel model, {
    int? progress,
    String? statusId,
    String? expiresAtIso,
  }) {
    return MissionModel(
      id: model.id,
      title: model.title,
      description: model.description,
      categoryId: model.categoryId,
      cadenceId: model.cadenceId,
      statusId: statusId ?? model.statusId,
      progress: progress ?? model.progress,
      goal: model.goal,
      rewardXp: model.rewardXp,
      rewardCoins: model.rewardCoins,
      rewardEnergy: model.rewardEnergy,
      expiresAtIso: expiresAtIso ?? model.expiresAtIso,
      rewardBadgeId: model.rewardBadgeId,
      rewardChestId: model.rewardChestId,
      specialKey: model.specialKey,
    );
  }
}