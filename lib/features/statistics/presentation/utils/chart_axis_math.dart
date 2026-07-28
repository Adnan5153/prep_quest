class ChartAxisMath {
  const ChartAxisMath._();

  static double niceCeiling(double value) {
    if (value <= 1) return 1;
    int p = 1;
    while ((value / p) >= 10) {
      p *= 10;
    }
    while ((value / p) < 1 && p > 1) {
      p = (p / 10).round();
    }
    final double normalized = value / p;
    final double rounded;
    if (normalized <= 1) {
      rounded = 1;
    } else if (normalized <= 2) {
      rounded = 2;
    } else if (normalized <= 5) {
      rounded = 5;
    } else {
      rounded = 10;
    }
    return rounded * p;
  }
}