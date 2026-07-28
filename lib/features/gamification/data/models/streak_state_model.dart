import '../../domain/entities/streak_day.dart';
import '../../domain/entities/streak_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../domain/enums/streak_enums.dart';

/// JSON-ready persistence shape for [StreakState].
///
/// Stored by [StreakLocalDataSource]; the entity is the only object
/// exposed to the rest of the app so domain and presentation stay free
/// of data-layer concerns.
class StreakStateModel {
  const StreakStateModel({
    required this.currentDays,
    required this.bestDays,
    required this.lastClaimedAtIso,
    this.shieldCharges = 0,
    this.recoveryUsedThisWeek = 0,
    this.nextMilestoneDays = 7,
    this.statusId = 'future',
    this.calendarDaysIso = const <String>[],
  });

  final int currentDays;
  final int bestDays;
  final String lastClaimedAtIso;
  final int shieldCharges;
  final int recoveryUsedThisWeek;
  final int nextMilestoneDays;
  final String statusId;
  final List<String> calendarDaysIso;

  factory StreakStateModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rawDays =
        (json['calendarDaysIso'] as List<dynamic>?) ?? <dynamic>[];
    return StreakStateModel(
      currentDays: (json['currentDays'] as num?)?.toInt() ?? 0,
      bestDays: (json['bestDays'] as num?)?.toInt() ?? 0,
      lastClaimedAtIso: (json['lastClaimedAtIso'] as String?) ?? '',
      shieldCharges: (json['shieldCharges'] as num?)?.toInt() ?? 0,
      recoveryUsedThisWeek:
          (json['recoveryUsedThisWeek'] as num?)?.toInt() ?? 0,
      nextMilestoneDays:
          (json['nextMilestoneDays'] as num?)?.toInt() ?? 7,
      statusId: (json['statusId'] as String?) ?? 'future',
      calendarDaysIso:
          rawDays.map((dynamic e) => e.toString()).toList(growable: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'currentDays': currentDays,
      'bestDays': bestDays,
      'lastClaimedAtIso': lastClaimedAtIso,
      'shieldCharges': shieldCharges,
      'recoveryUsedThisWeek': recoveryUsedThisWeek,
      'nextMilestoneDays': nextMilestoneDays,
      'statusId': statusId,
      'calendarDaysIso': calendarDaysIso,
    };
  }

  StreakState toEntity() {
    return StreakState(
      currentDays: currentDays,
      bestDays: bestDays,
      lastClaimedAtIso: lastClaimedAtIso,
      shieldCharges: shieldCharges,
      recoveryUsedThisWeek: recoveryUsedThisWeek,
      nextMilestoneDays: nextMilestoneDays,
      calendarDays: _parseCalendar(),
      status: _statusFromId(statusId),
    );
  }

  static StreakStateModel fromEntity(StreakState entity) {
    return StreakStateModel(
      currentDays: entity.currentDays,
      bestDays: entity.bestDays,
      lastClaimedAtIso: entity.lastClaimedAtIso,
      shieldCharges: entity.shieldCharges,
      recoveryUsedThisWeek: entity.recoveryUsedThisWeek,
      nextMilestoneDays: entity.nextMilestoneDays,
      statusId: entity.status.name,
      calendarDaysIso: entity.calendarDays
          .map((StreakDay d) => d.date.toIso8601String())
          .toList(growable: false),
    );
  }

  List<StreakDay> _parseCalendar() {
    return List<StreakDay>.unmodifiable(calendarDaysIso
        .map((String iso) {
      final DateTime? parsed = DateTime.tryParse(iso);
      if (parsed == null) return null;
      return StreakDay(date: parsed, status: StreakDayStatus.completed);
    }).whereType<StreakDay>());
  }

  static DailyRewardStatus _statusFromId(String id) {
    for (final DailyRewardStatus s in DailyRewardStatus.values) {
      if (s.name == id) return s;
    }
    return DailyRewardStatus.future;
  }
}