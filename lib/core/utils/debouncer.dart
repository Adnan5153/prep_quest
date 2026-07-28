import 'dart:async';

/// Delays invocation of [action] until [duration] of quiet have passed.
///
/// Calls to [call] reset the timer — useful for debouncing text-input
/// onChanged handlers so expensive work (network calls, repo searches)
/// only fires once the user stops typing for [duration].
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