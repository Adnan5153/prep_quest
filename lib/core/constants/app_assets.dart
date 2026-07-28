/// Asset paths used across the application.
///
/// Widgets must reference these constants rather than writing raw asset
/// strings — that way a future rebrand only touches one file.
class AppAssets {
  const AppAssets._();

  // ----- Logos -----
  static const String logo = 'assets/images/logo.png';
  static const String logoMark = 'assets/images/logo_mark.png';

  // ----- Illustrations -----
  static const String onboardingIllustration1 =
      'assets/images/onboarding_1.png';
  static const String onboardingIllustration2 =
      'assets/images/onboarding_2.png';
  static const String onboardingIllustration3 =
      'assets/images/onboarding_3.png';

  // ----- Lottie -----
  static const String loaderLottie = 'assets/animations/loader.json';
  static const String celebrationLottie = 'assets/animations/celebration.json';

  // ----- Fonts -----
  static const String fontNotoSansBengaliRegular = 'NotoSansBengali-Regular';
  static const String fontNotoSansBengaliBold = 'NotoSansBengali-Bold';
}
