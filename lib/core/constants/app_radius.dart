/// Border-radius scale used across the application.
///
/// Widget code must reference [AppRadius] instead of writing raw radius
/// literals. The values match the rounded-card language in
/// `Plans/design.md` section 2.
class AppRadius {
  const AppRadius._();

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double pill = 999.0;
}
