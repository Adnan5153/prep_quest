import '../../domain/entities/streak_day.dart';
import '../../domain/repositories/streak_resolver.dart';
import '../../domain/services/system_streak_resolver.dart';
import '../models/streak_model.dart';
import '../models/streak_state_model.dart';
import '../repositories/streak_bonus_catalog.dart';

/// In-memory source of truth for the user's login streak.
///
/// The production app has no backend for gamification, so every
/// repository call resolves through this deterministic seeded store.
/// A future network-backed datasource will implement the same surface;
/// no consumer code needs to change.
class StreakLocalDataSource {
  StreakLocalDataSource({
    StreakResolver? resolver,
    StreakBonusCatalog? catalog,
  })  : _resolver = resolver ?? const SystemStreakResolver(),
        _catalog = catalog ?? const StreakBonusCatalog();

  final StreakResolver _resolver;
  final StreakBonusCatalog _catalog;

  final Map<String, StreakModel> _bonusLedger = <String, StreakModel>{};
  StreakStateModel _state = const StreakStateModel(
    currentDays: 0,
    bestDays: 0,
    lastClaimedAtIso: '',
    shieldCharges: 2,
    recoveryUsedThisWeek: 0,
    nextMilestoneDays: 7,
    statusId: 'future',
  );

  bool _seeded = false;

  StreakStateModel readState() {
    _ensureSeeded();
    return _state;
  }

  void writeState(StreakStateModel model) {
    _ensureSeeded();
    _state = model;
  }

  List<StreakModel> readBonusLedger() {
    _ensureSeeded();
    return List<StreakModel>.unmodifiable(_bonusLedger.values);
  }

  void writeBonus(StreakModel model) {
    _ensureSeeded();
    _bonusLedger[model.id] = model;
  }

  DateTime now() => DateTime.now();

  int nextMilestoneDays(int currentDays) {
    return _catalog.nextMilestone(currentDays);
  }

  /// Resets the seed — used by tests and the repository's reload hook.
  void reset() {
    _bonusLedger.clear();
    _state = const StreakStateModel(
      currentDays: 0,
      bestDays: 0,
      lastClaimedAtIso: '',
      shieldCharges: 2,
      recoveryUsedThisWeek: 0,
      nextMilestoneDays: 7,
      statusId: 'future',
    );
    _seeded = false;
  }

  void _ensureSeeded() {
    if (_seeded) return;
    _seeded = true;
    for (final StreakModel m in _catalog.seed()) {
      _bonusLedger[m.id] = m;
    }
    _state = _decorateCalendar(_state);
  }

  /// Re-seeds the calendar grid for the supplied [model].
  StreakStateModel decorateCalendar(StreakStateModel model) {
    return _decorateCalendar(model);
  }

  StreakStateModel _decorateCalendar(StreakStateModel model) {
    final List<StreakDay> days =
        _resolver.buildLast30Days(model.toEntity());
    return StreakStateModel(
      currentDays: model.currentDays,
      bestDays: model.bestDays,
      lastClaimedAtIso: model.lastClaimedAtIso,
      shieldCharges: model.shieldCharges,
      recoveryUsedThisWeek: model.recoveryUsedThisWeek,
      nextMilestoneDays: model.nextMilestoneDays,
      statusId: model.statusId,
      calendarDaysIso: days
          .map((StreakDay d) => d.date.toIso8601String())
          .toList(growable: false),
    );
  }
}