import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/quiz_constants.dart';

enum QuizTimerState { idle, running, paused, expired }

@immutable
class QuizTimerSnapshot {
  const QuizTimerSnapshot({
    required this.state,
    required this.totalSeconds,
    required this.remainingSeconds,
  });

  final QuizTimerState state;
  final int totalSeconds;
  final int remainingSeconds;

  int get elapsedSeconds => totalSeconds - remainingSeconds;
  double get ratio {
    if (totalSeconds == 0) return 0;
    return (remainingSeconds / totalSeconds).clamp(0.0, 1.0);
  }

  bool get isWarning =>
      remainingSeconds <= QuizLimits.timerWarningThresholdSeconds &&
      remainingSeconds > QuizLimits.timerDangerThresholdSeconds;

  bool get isDanger =>
      remainingSeconds <= QuizLimits.timerDangerThresholdSeconds &&
      remainingSeconds > 0;

  bool get isExpired => state == QuizTimerState.expired;

  String get formatted {
    final int s = remainingSeconds < 0 ? 0 : remainingSeconds;
    final int minutes = s ~/ 60;
    final int seconds = s % 60;
    final String mm = minutes.toString().padLeft(2, '0');
    final String ss = seconds.toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class QuizTimerController extends StateNotifier<QuizTimerSnapshot> {
  QuizTimerController({required int totalSeconds})
    : super(
        QuizTimerSnapshot(
          state: QuizTimerState.idle,
          totalSeconds: totalSeconds,
          remainingSeconds: totalSeconds,
        ),
      );

  Timer? _ticker;

  void start() {
    if (state.state == QuizTimerState.running) return;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), _onTick);
    state = QuizTimerSnapshot(
      state: QuizTimerState.running,
      totalSeconds: state.totalSeconds,
      remainingSeconds: state.remainingSeconds,
    );
  }

  void pause() {
    if (state.state != QuizTimerState.running) return;
    _ticker?.cancel();
    _ticker = null;
    state = QuizTimerSnapshot(
      state: QuizTimerState.paused,
      totalSeconds: state.totalSeconds,
      remainingSeconds: state.remainingSeconds,
    );
  }

  void resume() {
    if (state.state != QuizTimerState.paused) return;
    start();
  }

  void reset({int? totalSeconds}) {
    _ticker?.cancel();
    _ticker = null;
    final int t = totalSeconds ?? state.totalSeconds;
    state = QuizTimerSnapshot(
      state: QuizTimerState.idle,
      totalSeconds: t,
      remainingSeconds: t,
    );
  }

  void expire() {
    _ticker?.cancel();
    _ticker = null;
    state = QuizTimerSnapshot(
      state: QuizTimerState.expired,
      totalSeconds: state.totalSeconds,
      remainingSeconds: 0,
    );
  }

  void _onTick(Timer _) {
    if (state.state != QuizTimerState.running) return;
    final int next = state.remainingSeconds - 1;
    if (next <= 0) {
      expire();
      return;
    }
    state = QuizTimerSnapshot(
      state: QuizTimerState.running,
      totalSeconds: state.totalSeconds,
      remainingSeconds: next,
    );
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _ticker = null;
    super.dispose();
  }
}

/// Family timer provider keyed by the quiz id. Auto-disposes when the
/// quiz screen is removed from the tree.
final quizTimerControllerProvider = StateNotifierProvider.autoDispose
    .family<QuizTimerController, QuizTimerSnapshot, QuizTimerKey>(
      (ref, key) {
        final QuizTimerController controller = QuizTimerController(
          totalSeconds: key.totalSeconds,
        );
        return controller;
      },
    );

@immutable
class QuizTimerKey {
  const QuizTimerKey({required this.quizId, required this.totalSeconds});

  final String quizId;
  final int totalSeconds;

  @override
  bool operator ==(Object other) {
    return other is QuizTimerKey &&
        other.quizId == quizId &&
        other.totalSeconds == totalSeconds;
  }

  @override
  int get hashCode => Object.hash(quizId, totalSeconds);
}