import 'package:flutter/foundation.dart';

@immutable
class AiSummaryActions {
  const AiSummaryActions({
    this.onCopy,
    this.onShare,
    this.onBookmark,
    this.onRegenerate,
    this.onReadAloud,
    this.onLike,
    this.onDislike,
    this.onExpandToggle,
    this.isBookmarked = false,
    this.isLiked = false,
    this.isDisliked = false,
    this.isReading = false,
    this.isExpanded = false,
    this.canExpand = false,
  });

  final VoidCallback? onCopy;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final VoidCallback? onRegenerate;
  final VoidCallback? onReadAloud;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;
  final VoidCallback? onExpandToggle;
  final bool isBookmarked;
  final bool isLiked;
  final bool isDisliked;
  final bool isReading;
  final bool isExpanded;
  final bool canExpand;

  bool get hasAny =>
      onCopy != null ||
      onShare != null ||
      onBookmark != null ||
      onRegenerate != null ||
      onReadAloud != null ||
      onLike != null ||
      onDislike != null ||
      (canExpand && onExpandToggle != null);
}
