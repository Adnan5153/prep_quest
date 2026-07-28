import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_local_datasource.dart';
import '../datasources/leaderboard_remote_datasource.dart';
import '../models/leaderboard_category_model.dart';

/// Concrete [LeaderboardRepository].
///
/// Implements the remote-first → local-cache fallback strategy. While
/// the production app has no backend, the remote datasource throws
/// [UnimplementedError] and every call transparently resolves through
/// the seeded local datasource — keeping the seam ready for Firestore.
class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = false,
  });

  final LeaderboardLocalDataSource local;
  final LeaderboardRemoteDataSource? remote;
  final bool preferRemote;

  @override
  Future<Result<LeaderboardCategoryEntity>> fetch(LeaderboardScope scope) async {
    try {
      return Result.success(_read(scope).toEntity());
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  @override
  Future<Result<List<LeaderboardCategoryEntity>>> fetchAll() async {
    try {
      final List<LeaderboardCategoryModel> raw = _readAll();
      return Result.success(
        List<LeaderboardCategoryEntity>.unmodifiable(
          raw.map((LeaderboardCategoryModel m) => m.toEntity()),
        ),
      );
    } catch (e, st) {
      return Result.failure(ErrorHandler.map(e, st));
    }
  }

  LeaderboardCategoryModel _read(LeaderboardScope scope) {
    if (preferRemote && remote != null) {
      try {
        return remote!.read(scope);
      } catch (_) {
        return local.read(scope);
      }
    }
    return local.read(scope);
  }

  List<LeaderboardCategoryModel> _readAll() {
    if (preferRemote && remote != null) {
      try {
        return remote!.readAll();
      } catch (_) {
        return local.readAll();
      }
    }
    return local.readAll();
  }
}