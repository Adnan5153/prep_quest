import 'dart:async';

/// Abstract connectivity probe used by the connectivity service.
///
/// Concrete implementations can wrap `connectivity_plus`, the Web
/// `navigator.onLine` API, or any custom channel. The default in
/// [NetworkInfo] returns a stream that emits the current status and
/// never produces further events unless [emit] is called manually.
class NetworkInfo {
  NetworkInfo();

  final StreamController<bool> _controller =
      StreamController<bool>.broadcast();
  bool _status = true;

  /// Emits whenever connectivity flips. Replays the current value to
  /// late subscribers through [isConnected].
  Stream<bool> get onStatusChange => _controller.stream;

  /// Whether the device currently reports an active connection.
  Future<bool> isConnected() async => _status;

  /// Pushes a status update. Used by tests and the connectivity
  /// service manual-override path.
  void emit(bool value) {
    if (_status == value) return;
    _status = value;
    if (!_controller.isClosed) _controller.add(value);
  }

  void dispose() {
    _controller.close();
  }
}