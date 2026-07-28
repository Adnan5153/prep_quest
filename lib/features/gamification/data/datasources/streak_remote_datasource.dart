import '../models/streak_model.dart';
import '../models/streak_state_model.dart';

/// Future Firestore-backed source of truth.
///
/// Intentionally left unimplemented: the production app currently has
/// no backend for gamification. The repository implements a
/// remote-first / local-cache fallback so swapping this stub in is a
/// non-event for consumers — and tests can flip a switch to verify
/// the fallback path.
class StreakRemoteDataSource {
  const StreakRemoteDataSource();

  StreakStateModel readState() {
    throw UnimplementedError(
      'StreakRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void writeState(StreakStateModel model) {
    throw UnimplementedError(
      'StreakRemoteDataSource is not yet wired to Firestore.',
    );
  }

  List<StreakModel> readBonusLedger() {
    throw UnimplementedError(
      'StreakRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void writeBonus(StreakModel model) {
    throw UnimplementedError(
      'StreakRemoteDataSource is not yet wired to Firestore.',
    );
  }

  DateTime now() {
    throw UnimplementedError(
      'StreakRemoteDataSource is not yet wired to Firestore.',
    );
  }
}