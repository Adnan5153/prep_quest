/// Typography tokens used across the application.
///
/// Widgets must reference these constants instead of writing raw
/// [TextStyle] values inline. Concrete text styles are wired in `app_theme.dart`.
class AppFonts {
  const AppFonts._();

  // ----- Font families -----
  /// Bangla-first display font (see `Plans/design.md` section 6.2).
  static const String bangla = 'NotoSansBengali';

  /// Latin / numerals font paired with Bangla for mixed UI.
  static const String latin = 'Inter';

  // ----- Type scale (per `Plans/widgetdesign.md` section 12) -----
  static const double displaySize = 32.0;
  static const double headlineSize = 24.0;
  static const double titleSize = 18.0;
  static const double bodySize = 14.0;
  static const double captionSize = 12.0;
}
