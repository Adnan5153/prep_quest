// Stub implementation for non-web platforms.
//
// The mobile app on Android/iOS doesn't expose a `/admin` URL the same way
// the web does, so we just default to mobile mode and never emit any
// history events.

bool isAdminPath(String path) => false;

String? currentLogicalPath() => null;

void Function() subscribeToPopstate(void Function(String path) onChange) {
  return () {};
}

void replacePath(String path) {}