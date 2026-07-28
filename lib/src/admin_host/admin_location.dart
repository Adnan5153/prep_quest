// Conditional-import facade for browser history operations.
//
// On web (where this app primarily runs) we use `dart:html` to read the
// current path and listen for `popstate` events. On non-web platforms we
// fall back to a no-op implementation that simply defaults to mobile mode.

export 'admin_location_stub.dart'
    if (dart.library.html) 'admin_location_web.dart';