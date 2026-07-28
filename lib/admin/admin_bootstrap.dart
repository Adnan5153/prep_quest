import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_app.dart';

/// Standalone admin panel entry point.
///
/// Mirrors the responsibilities of the mobile `bootstrap` (`lib/bootstrap.dart`)
/// but starts the admin panel as the root:
/// 1. Ensure Flutter bindings are initialized.
/// 2. Mount a fresh [ProviderScope] so admin-owned Riverpod providers (auth,
///    repositories, controllers) have a container to live in. Without this,
///    `AdminApp` throws `ProviderScopeNotFoundException` because it reads
///    `adminRouterProvider`.
/// 3. Launch [AdminApp].
///
/// Run with: `flutter run -t lib/admin/admin_main.dart`
Future<void> bootstrapAdmin() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: AdminApp(),
    ),
  );
}