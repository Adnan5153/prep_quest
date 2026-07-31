import 'dart:async';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

import '../config/firebase_config.dart';

/// Wraps `FirebaseCrashlytics` so widgets / services can record errors
/// and tagged logs without ever importing Firebase directly.
///
/// Lifecycle:
///   * `attach()` is called once from `bootstrap()` so every Flutter
///     error, platform-dispatcher error, and uncaught async error is
///     reported automatically.
///   * `record(error, stack, fatal)` is the entry point used by
///     `ErrorHandler.report` / `ErrorHandler.reportFatal`.
///
/// When Firebase is not configured (no `google-services.json`) every
/// method silently no-ops; calls still succeed so the rest of the app
/// doesn't need to change.
class CrashlyticsService {
  CrashlyticsService._();

  static final CrashlyticsService instance = CrashlyticsService._();

  bool _attached = false;
  bool get _available => FirebaseConfig.isPlatformConfigured;

  /// Installs Flutter / Platform error hooks. Idempotent.
  void attach() {
    if (_attached) return;
    if (!_available) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] Firebase not configured — '
            'installing console-only error hooks.');
      }
      _attached = true;
      // Still wire a console logger so devs see crashes without Firebase.
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
        debugPrint('[CrashlyticsService] uncaught error: $error');
        debugPrintStack(stackTrace: stack);
        return true;
      };
      return;
    }
    _attached = true;

    final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;

    FlutterError.onError = (FlutterErrorDetails details) {
      crashlytics.recordFlutterFatalError(details);
    };
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Records a non-fatal error with optional [reason] tag.
  Future<void> recordError(
    Object error,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    if (!_attached || !_available) return;
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: reason,
        fatal: fatal,
      );
    } catch (logError) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] recordError failed: $logError');
      }
    }
  }

  /// Records a fatal error and rethrows so the host can decide whether
  /// to terminate (used by `runZonedGuarded`).
  Future<void> recordFatal(Object error, StackTrace stack) async {
    if (!_attached || !_available) {
      debugPrint('[CrashlyticsService] FATAL: $error');
      debugPrintStack(stackTrace: stack);
      return;
    }
    try {
      await FirebaseCrashlytics.instance.recordError(
        error,
        stack,
        reason: error.toString(),
        fatal: true,
      );
    } catch (logError) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] recordFatal failed: $logError');
      }
    }
  }

  /// Tags the next session with the current user id.
  Future<void> setUserIdentifier(String? identifier) async {
    if (!_attached || !_available) return;
    try {
      await FirebaseCrashlytics.instance
          .setUserIdentifier(identifier ?? 'anonymous');
    } catch (logError) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] setUserIdentifier failed: $logError');
      }
    }
  }

  Future<void> setCustomKey(String key, Object value) async {
    if (!_attached || !_available) return;
    try {
      await FirebaseCrashlytics.instance.setCustomKey(key, value);
    } catch (logError) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] setCustomKey failed: $logError');
      }
    }
  }

  Future<void> log(String message) async {
    if (!_attached || !_available) return;
    try {
      await FirebaseCrashlytics.instance.log(message);
    } catch (logError) {
      if (kDebugMode) {
        debugPrint('[CrashlyticsService] log failed: $logError');
      }
    }
  }
}