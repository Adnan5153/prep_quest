import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Host-supplied callback that lets the admin shell exit back to the mobile
/// application. When the admin panel is mounted standalone (via
/// `lib/admin/admin_main.dart`), this provider returns `null` and the shell
/// hides the "Exit admin" button. When mounted from the integrated host
/// (`lib/admin_host_app.dart`), the host overrides this with its controller's
/// exit method.
final adminExitCallbackProvider = Provider<VoidCallback?>((Ref ref) => null);