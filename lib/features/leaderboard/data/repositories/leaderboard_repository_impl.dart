import '../../../../core/errors/error_handler.dart';
import '../../../../shared/typedefs/result.dart';
import '../../domain/entities/leaderboard_category_entity.dart';
import '../../domain/enums/leaderboard_enums.dart';
import '../../domain/repositories/leaderboard_repository.dart';
import '../datasources/leaderboard_local_datasource.dart';
import '../datasources/leaderboard_remote_datasource.dart';
import '../models/leaderboard_category_model.dart';

/// Concrete [LeaderboardRepository] (Phase 44).
///
/// Remote-first when Firebase is configured; falls back to the local
/// seed when the remote datasource is missing, fails, or the user is
/// unauthenticated. The local datasource continues to provide the
/// peer-preview augmentation so the podium / card tiles always
/// render even when the user has not yet generated their own row.
class LeaderboardRepositoryImpl implements LeaderboardRepository {
  LeaderboardRepositoryImpl({
    required this.local,
    this.remote,
    this.preferRemote = true,
    String Function()? uidProvider,
  }) : _uidProvider = uidProvider ?? _emptyUid;

  final LeaderboardLocalDataSource local;
  final LeaderboardRemoteDataSource? remote;
  final bool preferRemote;
  final String Function() _uidProvider;

  static String _emptyUid() => '';

  @override
  Future<Result<LeaderboardCategoryEntity>> fetch(LeaderboardScope scope) async {
    try {
      final LeaderboardCategoryModel raw = await _read(scope);
      return Result<LeaderboardCategoryEntity>.success(raw.toEntity());
    } catch (error, stackTrace) {
      return Result<LeaderboardCategoryEntity>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  @override
  Future<Result<List<LeaderboardCategoryEntity>>> fetchAll() async {
    try {
      final List<LeaderboardCategoryModel> raw = await _readAll();
      return Result<List<LeaderboardCategoryEntity>>.success(
        List<LeaderboardCategoryEntity>.unmodifiable(
          raw.map((LeaderboardCategoryModel m) => m.toEntity()),
        ),
      );
    } catch (error, stackTrace) {
      return Result<List<LeaderboardCategoryEntity>>.failure(
        ErrorHandler.map(error, stackTrace),
      );
    }
  }

  Future<LeaderboardCategoryModel> _read(LeaderboardScope scope) async {
    if (preferRemote && remote != null) {
      try {
        final LeaderboardCategoryModel model = await remote!.read(
          scope,
          uid: _uidProvider(),
        );
        if (model.entries.isNotEmpty) return model;
      } catch (_) {
        // Swallow and fall through to local seed.
      }
    }
    return local.read(scope);
  }

  Future<List<LeaderboardCategoryModel>> _readAll() async {
    final List<LeaderboardCategoryModel> out = <LeaderboardCategoryModel>[];
    for (final LeaderboardScope scope in LeaderboardScope.values) {
      out.add(await _read(scope));
    }
    return out;
  }
}