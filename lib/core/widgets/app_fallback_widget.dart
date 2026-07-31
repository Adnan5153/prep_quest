import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Static fallback widget rendered by `ErrorWidget.builder` whenever a
/// widget throws during build. In debug builds we render a clearly
/// bordered widget that names the failure (so devs spot the problem
/// even without Flutter's red error screen), in release builds we
/// show a tiny non-technical placeholder so production users never
/// see the dreaded "red screen of death".
class AppFallbackWidget extends StatelessWidget {
  const AppFallbackWidget({
    super.key,
    required this.error,
    this.stackTrace,
  });

  final Object error;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      // Render a debug-friendly widget with a red border and the error
      // summary so the developer can still spot the problem without
      // Flutter's default red-screen renderer. The full diagnostic
      // details are also dumped to the console above the render.
      return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          color: const Color(0xFFE53935),
          alignment: Alignment.center,
          child: Text(
            'Widget build failed:\n$error',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
      );
    }
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.bug_report_outlined,
                size: 32,
                color: isDark
                    ? AppColors.darkMuted
                    : AppColors.lightMuted,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Something went wrong',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.darkMuted
                      : AppColors.lightMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Installs the global [AppFallbackWidget] as the render for any
/// uncaught widget build failure. Idempotent.
void installAppFallback() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    // Forward the diagnostic to the Flutter console so devs see the
    // full stack trace even when our custom render is in place.
    FlutterError.dumpErrorToConsole(details);
    return AppFallbackWidget(
      error: details.exception,
      stackTrace: details.stack,
    );
  };
}