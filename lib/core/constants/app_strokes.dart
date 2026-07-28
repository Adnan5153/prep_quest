/// Centralized stroke widths for painters and decorative borders.
///
/// Painter code and decoration code must reference [AppStrokes] instead of
/// raw width literals. The scale mirrors typical designer use:
/// `hairline` for fine outlines, `thick`/`heavy` for bold strokes.
class AppStrokes {
  const AppStrokes._();

  static const double hairline = 1.0;
  static const double thin = 1.5;
  static const double regular = 2.0;
  static const double medium = 2.5;
  static const double thick = 4.0;
  static const double heavy = 6.0;
}
