import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_item_type.dart';
import 'bookmark_provider.dart';

/// Argument bag passed to the [isBookmarkedProvider] family.
@immutable
class BookmarkLookupArgs {
  const BookmarkLookupArgs({required this.type, required this.itemId});
  final BookmarkItemType type;
  final String itemId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookmarkLookupArgs &&
          type == other.type &&
          itemId == other.itemId;

  @override
  int get hashCode => Object.hash(type, itemId);
}

/// Synchronously-derived lookup set used by `BookmarkActionButton`.
final bookmarkIdsProvider = Provider<Set<String>>((Ref ref) {
  final Iterable<BookmarkLookupArgs> lookups =
      ref.watch(bookmarkControllerProvider).items.map(
            (BookmarkEntity b) => BookmarkLookupArgs(
              type: b.itemType,
              itemId: b.itemId,
            ),
          );
  return lookups
      .map((BookmarkLookupArgs l) => '${l.type.name}:${l.itemId}')
      .toSet();
});

/// Convenience: resolve a `(type, itemId)` pair into a `type:item` key.
String bookmarkLookupKey(BookmarkItemType type, String itemId) =>
    '${type.name}:$itemId';

/// FutureProvider variant for surfaces that need a Future-based flow.
final isBookmarkedProvider =
    FutureProvider.family<bool, BookmarkLookupArgs>((Ref ref, BookmarkLookupArgs args) async {
  return ref.watch(bookmarkControllerProvider.notifier).isBookmarkedSync(
        type: args.type,
        itemId: args.itemId,
      );
});