import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../features/offline/data/hive/hive_adapters.dart';
import '../cache/hive_manager.dart';
import '../constants/api_endpoints.dart';

/// Single source for environment-aware application configuration.
///
/// Anything that varies per build flavor / deployment should live here:
/// api base URLs, feature flags, default locale, asset roots, etc. Feature
/// code should read values from [AppConfig.instance] rather than duplicating
/// environment checks.
class AppConfig {
  AppConfig._({
    required this.environment,
    required this.isProduction,
    required this.defaultLocale,
    required this.themeMode,
  });

  /// Fully-initialized application configuration.
  ///
  /// Should not be read before [bootstrap] has been awaited.
  static AppConfig get instance {
    final AppConfig? config = _instance;
    if (config == null) {
      throw StateError(
        'AppConfig accessed before bootstrap() completed. '
        'Await bootstrap() in your entry point.',
      );
    }
    return config;
  }

  static AppConfig? _instance;

  /// The name of the current environment (`dev`, `staging`, `prod`, ...).
  final String environment;

  /// `true` when running in production builds. Useful for hiding debug UI
  /// such as the checked-mode banner or debug overlays.
  final bool isProduction;

  /// Locale used when the user has not picked a preference yet.
  final Locale defaultLocale;

  /// Initial [ThemeMode]. The user can override this at runtime through
  /// the shared theme provider under `core/providers/theme_provider.dart`.
  final ThemeMode themeMode;

  /// Performs one-time environment detection and stores the resulting
  /// configuration so the rest of the application can read it.
  ///
  /// Heavy async work (Firebase init, Hive box opening, asset precaching)
  /// is triggered from here, **not** from `main.dart`, so that test
  /// harnesses can substitute their own [bootstrap] implementation.
  static Future<void> bootstrap() async {
    // Environment resolution order:
    //   1. Compile-time `--dart-define=APP_ENV=...` value.
    //   2. Fallback `dev` so local runs never crash.
    const String environment = String.fromEnvironment(
      'APP_ENV',
      defaultValue: 'dev',
    );

    final bool isProduction = environment == 'prod';
    final ThemeMode themeMode = isProduction
        ? ThemeMode.system
        : ThemeMode.system;

    _instance = AppConfig._(
      environment: environment,
      isProduction: isProduction,
      defaultLocale: const Locale('en'),
      themeMode: themeMode,
    );

    await HiveManager.instance.initialize(
      registrars: <AdapterRegistrar>[registerOfflineAdapters],
    );

    if (kDebugMode) {
      debugPrint(
        '[AppConfig] env=${_instance!.environment} '
        'isProduction=${_instance!.isProduction} '
        'apiBase=${ApiEndpoints.baseUrl} '
        'hive=${HiveManager.instance.isInitialized}',
      );
    }
  }
}