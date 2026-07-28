/// Centralized component dimensions used across the application.
///
/// Every padding, margin, icon size, or fixed component dimension must be
/// declared here. Widgets should reference [AppSizes] instead of writing raw
/// numeric literals inline.
class AppSizes {
  const AppSizes._();

  // ----- Icon sizes -----
  static const double iconXs = 16.0;
  static const double iconSm = 20.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // ----- Tap targets -----
  static const double minTapTarget = 48.0;

  // ----- App bar / nav -----
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 64.0;

  // ----- Cards / containers -----
  static const double cardMinHeight = 96.0;
  static const double cardElevation = 2.0;

  // ----- Borders -----
  static const double borderThin = 1.0;
  static const double borderThick = 2.0;

  // ----- Screen breakpoints (from SRS section 6.5) -----
  static const double mobileMaxWidth = 600.0;
  static const double tabletMaxWidth = 1024.0;
  static const double desktopMaxWidth = 1440.0;
}
