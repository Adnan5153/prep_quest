import 'package:flutter/material.dart';

import 'admin_palette.dart';

abstract class AdminTypography {
  const AdminTypography._();

  static const String fontFamily = 'Inter';

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    height: 1.2,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.4,
    color: AdminPalette.graphite,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    color: AdminPalette.graphite,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    height: 1.3,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.1,
    color: AdminPalette.graphite,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 15,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: AdminPalette.graphite,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 13,
    height: 1.35,
    fontWeight: FontWeight.w600,
    color: AdminPalette.slate,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AdminPalette.slate,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    height: 1.5,
    fontWeight: FontWeight.w400,
    color: AdminPalette.slate,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    height: 1.45,
    fontWeight: FontWeight.w400,
    color: AdminPalette.ash,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    color: AdminPalette.graphite,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    color: AdminPalette.slate,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    color: AdminPalette.ash,
  );

  static const TextStyle mono = TextStyle(
    fontFamily: 'monospace',
    fontFamilyFallback: ['Courier', 'Courier New', 'monospace'],
    fontSize: 12,
    height: 1.4,
    fontWeight: FontWeight.w500,
    color: AdminPalette.slate,
  );

  static TextTheme toTextTheme(Brightness brightness) {
    final Color onSurface = brightness == Brightness.light
        ? AdminPalette.graphite
        : AdminPalette.ivory;
    final Color onSurfaceMuted = brightness == Brightness.light
        ? AdminPalette.slate
        : const Color(0xFFCBD5E1);

    return TextTheme(
      displayLarge: displayLarge.copyWith(color: onSurface),
      displayMedium: displayMedium.copyWith(color: onSurface),
      headlineLarge: displayMedium.copyWith(color: onSurface),
      headlineMedium: titleLarge.copyWith(color: onSurface),
      titleLarge: titleLarge.copyWith(color: onSurface),
      titleMedium: titleMedium.copyWith(color: onSurface),
      titleSmall: titleSmall.copyWith(color: onSurfaceMuted),
      bodyLarge: bodyLarge.copyWith(color: onSurfaceMuted),
      bodyMedium: bodyMedium.copyWith(color: onSurfaceMuted),
      bodySmall: bodySmall.copyWith(color: onSurfaceMuted),
      labelLarge: labelLarge.copyWith(color: onSurface),
      labelMedium: labelMedium.copyWith(color: onSurfaceMuted),
      labelSmall: labelSmall.copyWith(color: onSurfaceMuted),
    );
  }
}
