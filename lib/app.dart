import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/authentication/presentation/providers/auth_providers.dart';
import 'router.dart';

/// Root widget for the Prep Quest application.
///
/// Responsibilities (kept deliberately small):
/// - Provide the top-level [MaterialApp.router] for the host application.
/// - Resolve theme + localization based on the active [AppConfig].
/// - Mount the [ProviderScope] so Riverpod-backed features (auth,
///   theme, language) can listen to state changes. The router is
///   produced from inside the scope so it can plug in the
///   [authRouterRefreshProvider] and keep the redirect logic in
///   sync with the auth state.
///
/// Anything that owns state, fetches data, or listens to streams lives in
/// the feature folders under `lib/features/<feature>/presentation/providers`.
class PrepQuestApp extends ConsumerWidget {
  const PrepQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppConfig config = AppConfig.instance;
    // Reading the auth refresh provider inside `build` ensures the
    // router is rebuilt whenever the auth state changes.
    final ValueNotifier<int> refreshListenable =
        ref.watch(authRouterRefreshProvider);

    return MaterialApp.router(
      onGenerateTitle: (BuildContext context) => AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: config.themeMode,
      routerConfig: createAppRouter(refreshListenable: refreshListenable),
    );
  }
}