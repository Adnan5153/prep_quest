/// Single source of truth for the level-progression curve.
///
/// Every level-aware feature (the canonical quiz-completion funnel
/// in [UserProgressService], the gamification reward engine in
/// `RewardRuleCatalog`, the profile XP bar, the Playground HUD, and
/// any other consumer) reads through this class. Replacing the curve
/// here updates every consumer in lock-step, with no further code
/// changes.
///
/// ## Curve shape
///
/// `xpRequiredForLevel(n)` returns the XP needed to traverse level
/// `n` (i.e. the XP delta from level `n` to level `n + 1`):
///
/// ```
/// xp(1) = base
/// xp(n+1) = round(xp(n) * growth)
/// ```
///
/// With the default parameters (`base = 100`, `growth = 1.25`) the
/// progression is: 100 → 125 → 156 → 195 → 244 → 305 → 381 → 477 …
/// This is intentionally identical to the previous `_LevelTuning`
/// helper and matches the Phase 39 contract.
///
/// ## Level-up detection
///
/// `compute(totalXp)` returns a [LevelSnapshot] describing the user's
/// current position. Callers can detect a level-up by snapshotting
/// the curve at `totalXp - earnedXp` and at `totalXp` — a strictly
/// positive delta in `snapshot.level` means at least one level-up
/// occurred. The number of crossed levels equals
/// `newSnapshot.level - previousSnapshot.level`.
class LevelCurve {
  const LevelCurve({this.base = 100, this.growth = 1.25});

  /// The canonical curve used everywhere in the app.
  ///
  /// Tests may pass an alternative curve (e.g. a slower-steep
  /// growth) into the constructors that accept a curve, but the
  /// production funnel always reads [defaultCurve].
  static const LevelCurve defaultCurve = LevelCurve(base: 100, growth: 1.25);

  /// The XP cost required to traverse [level] (going from `level`
  /// to `level + 1`). Returns `base` for `level <= 1`.
  final int base;
  final double growth;

  int xpRequiredForLevel(int level) {
    if (level <= 1) return base;
    double xp = base.toDouble();
    for (int i = 1; i < level; i++) {
      xp *= growth;
    }
    return xp.round();
  }

  /// Evaluates [totalXp] against the curve.
  ///
  /// The returned [LevelSnapshot] is pure / deterministic — callers
  /// can compare two snapshots to detect a level delta.
  LevelSnapshot compute(int totalXp) {
    int level = 1;
    int xpAtLevel = 0;
    int xpForNext = xpRequiredForLevel(level);
    int previousThreshold = 0;
    int remaining = totalXp;
    while (remaining >= xpForNext) {
      previousThreshold = xpAtLevel;
      remaining -= xpForNext;
      xpAtLevel += xpForNext;
      level += 1;
      xpForNext = xpRequiredForLevel(level);
    }
    return LevelSnapshot(
      level: level,
      cumulativeXpAtLevel: xpAtLevel,
      xpForNext: xpForNext,
      previousLevelThreshold: previousThreshold,
      nextLevelThreshold: xpAtLevel + xpForNext,
      xpInLevel: remaining,
    );
  }
}

/// Immutable result of evaluating a user's current XP against a curve.
///
/// Two snapshots of the same curve at different XP values can be
/// compared to detect a level-up: `prev.level < next.level` means
/// the user crossed `next.level - prev.level` levels.
class LevelSnapshot {
  const LevelSnapshot({
    required this.level,
    required this.cumulativeXpAtLevel,
    required this.xpForNext,
    required this.previousLevelThreshold,
    required this.nextLevelThreshold,
    required this.xpInLevel,
  });

  /// The user's current level (1-indexed).
  final int level;

  /// The total XP required to reach this level (the cumulative XP
  /// at the start of this level).
  final int cumulativeXpAtLevel;

  /// The XP required to complete this level and advance to the next.
  final int xpForNext;

  /// Total XP threshold at the **start** of the user's previous level
  /// (or `0` when the user is at level 1).
  final int previousLevelThreshold;

  /// Total XP threshold at the **start** of the user's next level
  /// (i.e. the XP at which they will advance).
  final int nextLevelThreshold;

  /// XP earned within the current level — between `previousLevelThreshold`
  /// and `cumulativeXpAtLevel + xpForNext`. Stored on
  /// `UserProfile.progression.xpInLevel` for UI rendering.
  final int xpInLevel;

  /// A zero default for tests / previews that need an empty snapshot.
  static const LevelSnapshot zero = LevelSnapshot(
    level: 1,
    cumulativeXpAtLevel: 0,
    xpForNext: 100,
    previousLevelThreshold: 0,
    nextLevelThreshold: 100,
    xpInLevel: 0,
  );
}
