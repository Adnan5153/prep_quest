import '../../../../shared/typedefs/result.dart';
import '../repositories/bookmark_repository.dart';

/// Triggers a pull-and-push round-trip against the (eventually
/// Firestore-backed) remote datasource.
class SyncBookmarks {
  const SyncBookmarks(this._repository);
  final BookmarkRepository _repository;
  Future<Result<void>> call() => _repository.sync();
}