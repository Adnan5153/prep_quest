import '../models/bookmark_model.dart';

/// Future Firestore-backed source of truth for bookmarks.
class BookmarkRemoteDataSource {
  const BookmarkRemoteDataSource();

  Future<List<BookmarkModel>> pull() async {
    throw UnimplementedError(
      'BookmarkRemoteDataSource is not yet wired to Firestore.',
    );
  }

  Future<void> push(List<BookmarkModel> items) async {
    throw UnimplementedError(
      'BookmarkRemoteDataSource is not yet wired to Firestore.',
    );
  }
}