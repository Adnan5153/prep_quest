import '../../domain/entities/rank_progress.dart';

/// Pure reward helper. Kept separate from the domain so it can be
/// exercised in widget previews without coupling.
class RewardCalculator {
  const RewardCalculator();

  /// Returns a [RankProgress] snapshot describing rank delta.
  RankProgress rankDelta(dynamic result) {
    final int percent = (result.scorePercent as int).clamp(0, 100);
    final bool passed = result.passed as bool;
    return RankProgress(
      rankBefore: 'Bronze I',
      rankAfter: passed ? 'Bronze II' : 'Bronze I',
      progressToNextRank: percent / 100.0,
    );
  }

  String motivationalFor({required int scorePercent, required bool passed}) {
    if (scorePercent >= 95) return 'Flawless! Every answer landed.';
    if (scorePercent >= 80) return 'Outstanding work.';
    if (scorePercent >= 60) {
      return passed
          ? 'Solid run — keep pushing forward.'
          : 'Almost there — review and try once more.';
    }
    if (scorePercent >= 40) return 'Warming up — practice the weak topics below.';
    return 'No worries. Review the explanations and try again.';
  }

  String summaryFor({
    required int correct,
    required int incorrect,
    required int skipped,
    required int total,
  }) {
    if (total == 0) return 'No questions answered.';
    return '$correct/$total correct • $incorrect wrong • $skipped skipped';
  }
}