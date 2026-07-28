import 'dart:async';

import '../network/network_info.dart';

/// Network connectivity state surfaced to the rest of the app.
///
/// The [NetworkInfo] layer hides platform specifics; this service adds
/// the stream contract and a small caching layer so widgets can listen
/// to connectivity changes without polling.
class ConnectivityService {
  ConnectivityService({NetworkInfo? networkInfo})
      : _networkInfo = networkInfo ?? NetworkInfo();

  final NetworkInfo _networkInfo;
  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();
  bool _last = true;
  bool _disposed = false;

  /// Last known online status. Defaults to `true` until proven otherwise.
  bool get isOnline => _last;

  /// Broadcast stream of online/offline changes.
  Stream<bool> get changes => _controller.stream;

  /// Initialises the service and starts listening for platform changes.
  Future<void> initialize() async {
    final bool initial = await _networkInfo.isConnected();
    _emit(initial);
    _networkInfo.onStatusChange.listen(_emit);
  }

  /// Manual override used by tests and the offline debug menu.
  void setOnline(bool value) => _emit(value);

  void _emit(bool value) {
    if (_disposed) return;
    if (value == _last) return;
    _last = value;
    if (!_controller.isClosed) _controller.add(value);
  }

  void dispose() {
    _disposed = true;
    _controller.close();
  }
}