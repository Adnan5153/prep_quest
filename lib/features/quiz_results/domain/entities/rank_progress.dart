import 'package:flutter/foundation.dart';

/// Snapshot of rank progression earned from a single quiz completion.
@immutable
class RankProgress {
  const RankProgress({
    required this.rankBefore,
    required this.rankAfter,
    required this.progressToNextRank,
  });

  /// Human-readable rank label before applying the new XP (e.g.
  /// "Gold II"). Application-specific codes are accepted in the
  /// `user_profile` package; we keep this generic on purpose.
  final String rankBefore;
  final String rankAfter;

  /// Progress toward the next rank in `[0.0, 1.0]`.
  final double progressToNextRank;

  bool get isLevelUp => rankAfter != rankBefore;
}
