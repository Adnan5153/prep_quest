import 'dart:async';

class Debouncer {
  Debouncer({this.duration = const Duration(milliseconds: 320)});

  final Duration duration;
  Timer? _timer;

  void call(void Function() action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}

class Throttler {
  Throttler({this.duration = const Duration(milliseconds: 120)});

  final Duration duration;
  Timer? _timer;
  bool _running = false;

  void call(void Function() action) {
    if (_running) return;
    _running = true;
    action();
    _timer = Timer(duration, () {
      _running = false;
    });
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
    _running = false;
  }
}
