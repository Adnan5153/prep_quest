import '../../domain/enums/leaderboard_enums.dart';
import '../models/leaderboard_category_model.dart';

/// Future Firestore-backed source of truth.
///
/// Intentionally left unimplemented: the production app currently has
/// no backend for the leaderboard. The repository implements a
/// remote-first / local-cache fallback so swapping this stub in is a
/// non-event for consumers — and tests can flip a switch to verify
/// the fallback path.
class LeaderboardRemoteDataSource {
  const LeaderboardRemoteDataSource();

  LeaderboardCategoryModel read(LeaderboardScope scope) {
    throw UnimplementedError(
      'LeaderboardRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void write(LeaderboardScope scope, LeaderboardCategoryModel model) {
    throw UnimplementedError(
      'LeaderboardRemoteDataSource is not yet wired to Firestore.',
    );
  }

  List<LeaderboardCategoryModel> readAll() {
    throw UnimplementedError(
      'LeaderboardRemoteDataSource is not yet wired to Firestore.',
    );
  }
}
