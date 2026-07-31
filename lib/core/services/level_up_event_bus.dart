import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/profile/domain/entities/user_profile.dart';

/// One-shot event published by [UserProgressService] when a quiz
/// completion crosses at least one level boundary.
///
/// The event is consumed by the root listener in `main.dart`, which
/// pops the canonical `LevelRewardDialog`. The bus clears itself when
/// the dialog's primary action fires.
class LevelUpEvent {
  const LevelUpEvent({
    required this.fromLevel,
    required this.toLevel,
    required this.totalXp,
    required this.reward,
  });

  final int fromLevel;
  final int toLevel;
  final int totalXp;
  final PendingLevelReward reward;
}

class LevelUpEventBus extends StateNotifier<LevelUpEvent?> {
  LevelUpEventBus() : super(null);

  void publish(LevelUpEvent event) {
    state = event;
  }

  void clear() {
    state = null;
  }
}

final levelUpEventBusProvider =
    StateNotifierProvider<LevelUpEventBus, LevelUpEvent?>(
  (Ref ref) => LevelUpEventBus(),
);