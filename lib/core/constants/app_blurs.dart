/// Centralized blur radii for [MaskFilter] and [BackdropFilter] usage.
///
/// Every blur radius used in painters, [BackdropFilter], and
/// shadow decorations should reference [AppBlurs] instead of an inline
/// numeric literal. Keeps blur recipes consistent and easy to retune.
class AppBlurs {
  const AppBlurs._();

  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 12.0;
  static const double xl = 18.0;
  static const double xxl = 22.0;
}
