import 'package:flutter/foundation.dart';

import 'ai_response_constants.dart';

/// Which action is currently being processed by [AiResponseCard]. Drives
/// the footer button that shows a loading indicator instead of an icon.
enum AiResponsePendingAction {
  copy,
  share,
  regenerate,
  favorite,
  like,
  dislike,
  expand,
}

/// Set of optional footer actions surfaced by [AiResponseCard].
///
/// All callbacks default to `null`; the footer is collapsed (renders a
/// [SizedBox.shrink]) when none are supplied. State booleans drive the
/// visual treatment of individual tiles (e.g. [isFavorite] switches the
/// bookmark icon between outlined / filled).
@immutable
class AiResponseActions {
  const AiResponseActions({
    this.onCopy,
    this.onShare,
    this.onRegenerate,
    this.onFavorite,
    this.onLike,
    this.onDislike,
    this.onExpandToggle,
    this.isFavorite = false,
    this.isLiked = false,
    this.isDisliked = false,
    this.isExpanded = false,
    this.canExpand = false,
    this.pending,
  });

  /// Tap handler for "Copy response".
  final VoidCallback? onCopy;

  /// Tap handler for "Share response".
  final VoidCallback? onShare;

  /// Tap handler for "Regenerate response".
  final VoidCallback? onRegenerate;

  /// Tap handler for "Save / favorite response".
  final VoidCallback? onFavorite;

  /// Tap handler for "Like response".
  final VoidCallback? onLike;

  /// Tap handler for "Dislike response".
  final VoidCallback? onDislike;

  /// Tap handler for "Expand / collapse" toggle.
  final VoidCallback? onExpandToggle;

  /// True when the response is currently saved.
  final bool isFavorite;

  /// True when the response is currently liked.
  final bool isLiked;

  /// True when the response is currently disliked.
  final bool isDisliked;

  /// True when the card body is expanded.
  final bool isExpanded;

  /// True when the card is allowed to expand (shows the toggle).
  final bool canExpand;

  /// The action that is currently in flight (e.g. generating). The
  /// corresponding tile renders a spinner instead of the icon.
  final AiResponsePendingAction? pending;

  /// True when any callback is supplied.
  bool get hasAny =>
      onCopy != null ||
      onShare != null ||
      onRegenerate != null ||
      onFavorite != null ||
      onLike != null ||
      onDislike != null ||
      (canExpand && onExpandToggle != null);

  /// Creates a copy with overridden fields.
  AiResponseActions copyWith({
    VoidCallback? onCopy,
    VoidCallback? onShare,
    VoidCallback? onRegenerate,
    VoidCallback? onFavorite,
    VoidCallback? onLike,
    VoidCallback? onDislike,
    VoidCallback? onExpandToggle,
    bool? isFavorite,
    bool? isLiked,
    bool? isDisliked,
    bool? isExpanded,
    bool? canExpand,
    AiResponsePendingAction? pending,
  }) {
    return AiResponseActions(
      onCopy: onCopy ?? this.onCopy,
      onShare: onShare ?? this.onShare,
      onRegenerate: onRegenerate ?? this.onRegenerate,
      onFavorite: onFavorite ?? this.onFavorite,
      onLike: onLike ?? this.onLike,
      onDislike: onDislike ?? this.onDislike,
      onExpandToggle: onExpandToggle ?? this.onExpandToggle,
      isFavorite: isFavorite ?? this.isFavorite,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isExpanded: isExpanded ?? this.isExpanded,
      canExpand: canExpand ?? this.canExpand,
      pending: pending ?? this.pending,
    );
  }
}

/// Inline metadata displayed beneath the header title.
///
/// Every field is optional — callers can show only the data they have.
/// [model] is rendered as `Model • name`, [timestamp] as `clock icon
/// • value`, [category] as `tag icon • value`. [confidence] and
/// [status] render as coloured pills when supplied.
@immutable
class AiResponseMetadata {
  const AiResponseMetadata({
    this.model,
    this.timestamp,
    this.category,
    this.confidence,
    this.status,
    this.extra,
  });

  /// AI model name (e.g. "GPT-4", "Claude Sonnet").
  final String? model;

  /// Human-readable timestamp (e.g. "2m ago", "Today 14:23").
  final String? timestamp;

  /// Topical category (e.g. "Mathematics", "Cardiology").
  final String? category;

  /// Confidence indicator — rendered as a small pill.
  final AiResponseConfidence? confidence;

  /// Delivery status — rendered as a small pill.
  final AiResponseStatus? status;

  /// Caller-defined trailing text (e.g. "token count", "session id").
  /// Rendered as plain label text after the structured pills.
  final String? extra;

  /// True when any metadata field is supplied.
  bool get hasAny =>
      model != null ||
      timestamp != null ||
      category != null ||
      confidence != null ||
      status != null ||
      (extra != null && extra!.isNotEmpty);
}
