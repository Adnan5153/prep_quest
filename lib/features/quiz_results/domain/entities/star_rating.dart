/// Star rating earned for completing a quiz.
///
/// Derived from `scorePercent` thresholds: 0–19 = 0 stars,
/// 20–39 = 1, 40–59 = 2, 60–79 = 3, 80–94 = 4, 95–100 = 5.
enum StarRating {
  zero,
  one,
  two,
  three,
  four,
  five;

  static StarRating fromScore(int scorePercent) {
    final int clamped = scorePercent.clamp(0, 100);
    if (clamped >= 95) return StarRating.five;
    if (clamped >= 80) return StarRating.four;
    if (clamped >= 60) return StarRating.three;
    if (clamped >= 40) return StarRating.two;
    if (clamped >= 20) return StarRating.one;
    return StarRating.zero;
  }

  int get value {
    switch (this) {
      case StarRating.zero:
        return 0;
      case StarRating.one:
        return 1;
      case StarRating.two:
        return 2;
      case StarRating.three:
        return 3;
      case StarRating.four:
        return 4;
      case StarRating.five:
        return 5;
    }
  }
}
