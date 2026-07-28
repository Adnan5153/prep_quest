// Web implementation: bridges browser history to the host's mode controller.
//
// Uses `package:web` + `dart:js_interop` (the modern interop API replacing
// `dart:html`). The conditional export facade (`admin_location.dart`) only
// pulls this file in on web, so non-web builds are unaffected.
//
// Both the mobile and admin GoRouters default to the **hash URL strategy**
// on Flutter Web, so URLs look like `http://localhost:54843/#/admin`. The
// actual logical path (`/admin`) lives in `window.location.hash`, not in
// `window.location.pathname` (which is just `/`). This file normalizes
// both strategies so the host sees the same logical path in either case.

import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// Extracts the GoRouter logical path from the current URL, regardless of
/// whether the router is using hash (`#/admin/dashboard`) or path
/// (`/admin/dashboard`) strategy.
///
/// Order of preference:
///   1. If the URL has a non-empty hash (starting with `#/`), strip the
///      `#` prefix and use that as the path.
///   2. Otherwise fall back to `window.location.pathname`.
String _currentLogicalPath() {
  final String hash = web.window.location.hash;
  if (hash.startsWith('#/') && hash.length > 2) {
    return hash.substring(1);
  }
  if (hash == '#') {
    return '/';
  }
  return web.window.location.pathname;
}

/// Returns the GoRouter logical path at the moment of call, or `null` on
/// non-web platforms where the concept doesn't apply. Used by bootstrap to
/// derive the initial admin/mobile mode.
String? currentLogicalPath() => _currentLogicalPath();

bool isAdminPath(String path) {
  if (path.isEmpty) return false;
  return path == '/admin' || path.startsWith('/admin/');
}

void Function() subscribeToPopstate(void Function(String path) onChange) {
  void handler(web.Event _) {
    onChange(_currentLogicalPath());
  }

  final JSFunction wrapped = ((web.Event e) => handler(e)).toJS;
  web.window.addEventListener('popstate', wrapped);
  return () => web.window.removeEventListener('popstate', wrapped);
}

/// Rewrites the browser URL so the user-visible address bar reflects the new
/// mode. Preserves the strategy of whatever router is currently mounted:
/// since both routers use the hash strategy on web, we update the hash.
void replacePath(String path) {
  // The hash strategy puts the path after `#`. Set it directly; using
  // replaceState with a non-hash path would silently desync from the
  // active GoRouter.
  web.window.location.hash = path;
}