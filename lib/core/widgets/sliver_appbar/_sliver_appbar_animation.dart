/// Helper class for SliverAppBar animation calculations.
class SliverAppBarAnimation {
  /// Calculates the collapse percentage (0.0 to 1.0).
  static double calculateCollapsePercentage(
    double currentHeight,
    double expandedHeight,
    double toolbarTotalHeight,
  ) {
    final double collapseRange = expandedHeight - toolbarTotalHeight;
    if (collapseRange <= 0) return 1.0;

    return ((expandedHeight - currentHeight) / collapseRange).clamp(0.0, 1.0);
  }

  /// Calculates opacity for expanded elements.
  static double calculateExpandedOpacity(double t) => 1.0 - t;

  /// Calculates opacity for collapsed elements.
  static double calculateCollapsedOpacity(double t) => t;

  /// Calculates vertical translation for the title.
  static double calculateTitleTranslation(double t, {double distance = 20.0}) {
    return distance * t;
  }
}
