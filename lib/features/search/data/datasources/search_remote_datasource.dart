import '../models/recent_search_model.dart';
import '../models/search_item_model.dart';
import '../models/trending_search_model.dart';

/// Future-Firestore seam. Throws until the search index is wired.
class SearchRemoteDataSource {
  const SearchRemoteDataSource();

  List<SearchItemModel> readAll() {
    throw UnimplementedError(
      'SearchRemoteDataSource is not yet wired to Firestore.',
    );
  }

  void writeRecent(List<RecentSearchModel> rows) {
    throw UnimplementedError(
      'SearchRemoteDataSource is not yet wired to Firestore.',
    );
  }

  List<TrendingSearchModel> readTrending() {
    throw UnimplementedError(
      'SearchRemoteDataSource is not yet wired to Firestore.',
    );
  }
}