import 'package:flutter/widgets.dart';

import 'admin_host_app.dart';
import 'core/config/app_config.dart';
import 'src/admin_host/admin_location.dart';

/// Boots the Prep Quest application.
///
/// Responsibilities (kept narrow on purpose):
/// 1. Ensure Flutter bindings are initialized.
/// 2. Hand off to [AppConfig.bootstrap] so environment-dependent configuration
///    (api base, feature flags, asset roots) is resolved before `runApp`.
/// 3. Inspect the initial URL: if the user navigated to an `/admin...`
///    deeplink, mount [AdminHostApp] in admin mode; otherwise mount it in
///    mobile mode. [AdminHostApp] handles the atomic root swap and the
///    browser-history listener that keeps the mode in sync with popstate.
///
/// Anything heavier (Firebase init, Hive box opening, push permission
/// requests) should be wired into [AppConfig.bootstrap] or moved into a
/// dedicated service that the root provider tree awaits.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppConfig.bootstrap();

  // Both mobile and admin GoRouters default to the hash URL strategy on
  // Flutter Web, so `/admin` lives at `/#/admin` — not in
  // `Uri.base.path`. We ask the location adapter for the logical path
  // the active router would see; on non-web platforms this returns null
  // and we default to mobile mode.
  final String? logicalPath = currentLogicalPath();
  final bool initialAdminMode =
      logicalPath != null && isAdminPath(logicalPath);

  final AdminModeController controller = AdminModeController(
    initial: initialAdminMode,
  );

  runApp(AdminHostApp(controller: controller));
}