import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/enums/bookmark_filter.dart';
import '../../domain/enums/bookmark_sort.dart';

/// Pure-UI filter & sort state. The [BookmarkController] reads from
/// these to drive its queries against the data layer.
final bookmarkFilterProvider = StateProvider<BookmarkFilter>(
  (Ref ref) => BookmarkFilter.all,
);

final bookmarkSortProvider = StateProvider<BookmarkSort>(
  (Ref ref) => BookmarkSort.newest,
);