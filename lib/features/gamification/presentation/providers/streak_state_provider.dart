import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/streak_state.dart';
import '../../domain/enums/reward_enums.dart';
import '../../../profile/presentation/providers/profile_providers.dart';
import '../../../profile/presentation/states/profile_state.dart';

/// Riverpod owner for the local [StreakState] mirror.
///
/// Reads the current profile (when ready) to bootstrap the streak
/// counters and exposes a single `replaceLocal` mutation so the
/// [UserProgressService] can credit completed quiz runs.
final streakStateProvider =
    StateNotifierProvider<StreakStateNotifier, StreakState>((ref) {
  final initial = _bootstrapFromProfile(ref);
  return StreakStateNotifier(initial, ref);
});

StreakState _bootstrapFromProfile(Ref ref) {
  final profileState = ref.watch(profileControllerProvider);
  final profile = profileState.profile;
  if (profile == null) {
    return const StreakState(
      currentDays: 0,
      bestDays: 0,
      lastClaimedAtIso: '',
      status: DailyRewardStatus.future,
    );
  }
  return StreakState(
    currentDays: profile.progression.streakDays,
    bestDays: profile.studyStats.longestStreakDays,
    lastClaimedAtIso: profile.studyStats.lastActiveAt.toUtc().toIso8601String(),
    status: DailyRewardStatus.future,
  );
}

class StreakStateNotifier extends StateNotifier<StreakState> {
  StreakStateNotifier(super.initial, Ref ref) {
    // Profile is the canonical source of truth (Phase 40 contract) —
    // re-sync the local streak mirror whenever the profile changes so
    // cross-device updates surface in the streak UI without waiting for
    // a quiz completion.
    ref.listen<ProfileState>(
      profileControllerProvider,
      (_, ProfileState next) {
        final profile = next.profile;
        if (profile == null) return;
        state = StreakState(
          currentDays: profile.progression.streakDays,
          bestDays: profile.studyStats.longestStreakDays,
          lastClaimedAtIso: profile.studyStats.lastActiveAt
              .toUtc()
              .toIso8601String(),
          status: state.status,
        );
      },
    );
  }

  Future<void> replaceLocal(StreakState next) async {
    state = next;
  }
}
