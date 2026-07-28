import 'package:flutter/material.dart';

import 'admin_palette.dart';
import 'admin_radius.dart';
import 'admin_spacing.dart';
import 'admin_strokes.dart';
import 'admin_typography.dart';

class AdminTheme {
  const AdminTheme._();

  static ThemeData light() {
    final ColorScheme scheme = const ColorScheme.light(
      primary: AdminPalette.accent,
      onPrimary: Colors.white,
      secondary: AdminPalette.accentMuted,
      onSecondary: Colors.white,
      surface: AdminPalette.paper,
      onSurface: AdminPalette.graphite,
      surfaceContainerHighest: AdminPalette.ivory,
      outline: AdminPalette.hairline,
      outlineVariant: AdminPalette.hairline,
      error: AdminPalette.danger,
      onError: Colors.white,
    );

    return _build(scheme, Brightness.light);
  }

  static ThemeData dark() {
    final ColorScheme scheme = const ColorScheme.dark(
      primary: AdminPalette.accentMuted,
      onPrimary: Colors.white,
      secondary: AdminPalette.accent,
      onSecondary: Colors.white,
      surface: Color(0xFF0B1220),
      onSurface: AdminPalette.ivory,
      surfaceContainerHighest: Color(0xFF111827),
      outline: Color(0xFF1F2937),
      outlineVariant: Color(0xFF1F2937),
      error: AdminPalette.danger,
      onError: Colors.white,
    );

    return _build(scheme, Brightness.dark);
  }

  static ThemeData _build(ColorScheme scheme, Brightness brightness) {
    final TextTheme textTheme = AdminTypography.toTextTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      dividerColor: scheme.outline,
      textTheme: textTheme,
      iconTheme: IconThemeData(color: scheme.onSurface, size: 18),
      primaryIconTheme: IconThemeData(color: scheme.onPrimary, size: 18),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: AdminSpacing.toolbarHeight,
        titleTextStyle: textTheme.titleMedium,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminRadius.lg),
          side: BorderSide(color: scheme.outline, width: AdminStrokes.hairline),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.md),
          ),
          textStyle: AdminTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          side: BorderSide(color: scheme.outline, width: AdminStrokes.hairline),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.md),
          ),
          textStyle: AdminTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, 32),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.sm),
          ),
          textStyle: AdminTypography.labelLarge,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(36, 36),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AdminRadius.sm),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md,
          vertical: AdminSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          borderSide: BorderSide(color: scheme.primary, width: AdminStrokes.focus),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          borderSide: BorderSide(color: scheme.error),
        ),
        labelStyle: AdminTypography.labelMedium,
        hintStyle: AdminTypography.bodyMedium.copyWith(
          color: scheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AdminPalette.graphite,
          borderRadius: BorderRadius.circular(AdminRadius.sm),
        ),
        textStyle: AdminTypography.labelSmall.copyWith(color: Colors.white),
        preferBelow: false,
        waitDuration: const Duration(milliseconds: 320),
      ),
      menuTheme: MenuThemeData(
        style: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(scheme.surface),
          surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
          elevation: const WidgetStatePropertyAll(4),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AdminRadius.md),
              side: BorderSide(color: scheme.outline),
            ),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
          side: BorderSide(color: scheme.outline),
        ),
        textStyle: AdminTypography.bodyMedium,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminRadius.lg),
        ),
        titleTextStyle: AdminTypography.titleLarge,
        contentTextStyle: AdminTypography.bodyMedium,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: AdminStrokes.hairline,
        space: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: scheme.primary,
        unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.6),
        indicatorColor: scheme.primary,
        labelStyle: AdminTypography.labelLarge,
        unselectedLabelStyle: AdminTypography.labelLarge,
        dividerColor: scheme.outline,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AdminPalette.graphite,
        contentTextStyle: AdminTypography.bodyMedium.copyWith(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminRadius.md),
        ),
        insetPadding: const EdgeInsets.all(AdminSpacing.lg),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearMinHeight: 2,
      ),
      checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: scheme.outline),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AdminRadius.xs),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return scheme.primary;
          return AdminPalette.ash;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return scheme.primary.withValues(alpha: 0.4);
          }
          return scheme.outline;
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: scheme.primary,
        inactiveTrackColor: scheme.outline,
        thumbColor: scheme.primary,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          TargetPlatform.windows: ZoomPageTransitionsBuilder(),
          TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
        },
      ),
      visualDensity: VisualDensity.compact,
      splashFactory: InkSparkle.splashFactory,
    );
  }
}
