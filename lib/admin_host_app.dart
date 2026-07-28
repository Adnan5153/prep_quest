import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin/admin_app.dart';
import 'admin/shared/providers/admin_host_providers.dart';
import 'app.dart';
import 'src/admin_host/admin_location.dart';

/// Controller that decides whether the host renders the mobile application
/// or the admin panel. The host (`AdminHostApp`) owns this and threads it
/// through the tree. Mutations come from:
///   * initial bootstrap URL inspection
///   * browser `popstate` (web only)
///   * the admin shell's "Exit admin" callback
class AdminModeController extends ValueNotifier<bool> {
  AdminModeController({required bool initial}) : super(initial);

  void enter() => value = true;
  void exit() => value = false;
}

/// `InheritedNotifier` exposing the [AdminModeController] above both root
/// branches so future host-aware widgets can read it without prop drilling.
class AdminModeScope extends InheritedNotifier<AdminModeController> {
  const AdminModeScope({
    required AdminModeController notifier,
    required super.child,
    super.key,
  }) : super(notifier: notifier);

  static AdminModeController of(BuildContext context) {
    final AdminModeScope? scope =
        context.dependOnInheritedWidgetOfExactType<AdminModeScope>();
    assert(scope != null, 'AdminModeScope missing above this widget.');
    return scope!.notifier!;
  }
}

/// Top-level widget that decides whether to show the mobile app or the admin
/// panel based on the current mode. Exactly one [MaterialApp.router] is
/// mounted at a time; the swap is atomic (no two routers coexist).
///
/// Mobile mode: [PrepQuestApp] (no ProviderScope — mobile does not use
/// Riverpod at the entry layer).
///
/// Admin mode: a fresh [ProviderScope] containing [AdminApp] with an override
/// wiring the controller's [AdminModeController.exit] callback into the
/// admin shell so the user can navigate back to the mobile app.
class AdminHostApp extends StatefulWidget {
  const AdminHostApp({required this.controller, super.key});

  final AdminModeController controller;

  @override
  State<AdminHostApp> createState() => _AdminHostAppState();
}

class _AdminHostAppState extends State<AdminHostApp> {
  void Function()? _unsubscribePopstate;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _unsubscribePopstate = subscribeToPopstate((String path) {
        if (!mounted) return;
        if (isAdminPath(path)) {
          widget.controller.enter();
        } else {
          widget.controller.exit();
        }
      });
    }
  }

  @override
  void dispose() {
    _unsubscribePopstate?.call();
    super.dispose();
  }

  void _exitAdmin() {
    // Swap to mobile mode first so the admin `MaterialApp.router` and its
    // hashchange listener are unmounted before we touch the URL. Then
    // rewrite the address bar to a mobile path so the freshly-mounted
    // mobile router can pick it up.
    widget.controller.exit();
    if (kIsWeb) {
      replacePath('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminModeScope(
      notifier: widget.controller,
      child: ValueListenableBuilder<bool>(
        valueListenable: widget.controller,
        builder: (BuildContext context, bool isAdmin, Widget? _) {
          if (isAdmin) {
            return ProviderScope(
              key: const ValueKey('admin-root'),
              overrides: <Override>[
                adminExitCallbackProvider.overrideWithValue(_exitAdmin),
              ],
              child: const AdminApp(),
            );
          }
          return ProviderScope(
            key: const ValueKey('mobile-root'),
            child: const PrepQuestApp(),
          );
        },
      ),
    );
  }
}