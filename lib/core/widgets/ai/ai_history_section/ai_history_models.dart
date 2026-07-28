import 'package:flutter/material.dart';

import 'ai_history_enums.dart';

/// Strongly typed payload for a single history row.
///
/// Consumers pass pre-built data through [AiHistorySection.items].
/// No Firebase, repository or provider references live inside this
/// model — the widget stays a pure presentation component.
class AiHistoryItem {
  const AiHistoryItem({
    required this.id,
    required this.title,
    required this.preview,
    required this.timestamp,
    this.subtitle,
    this.category,
    this.type = AiHistoryEntryType.tutor,
    this.isFavorite = false,
    this.isPinned = false,
    this.isPremium = false,
    this.isUnread = false,
    this.leadingIcon,
    this.avatarLabel,
    this.semanticLabel,
    this.onTap,
    this.onLongPress,
  });

  /// Stable identifier used to drive keyed rebuilds inside the list.
  final String id;

  /// Primary headline shown on the row.
  final String title;

  /// Short body preview rendered below the title.
  final String preview;

  /// Already-localised timestamp string ("2m ago", "Yesterday", ...).
  final String timestamp;

  /// Optional secondary metadata line shown next to the timestamp.
  final String? subtitle;

  /// Optional category chip text shown above the body.
  final String? category;

  /// Determines the avatar tint and accent treatment.
  final AiHistoryEntryType type;

  /// When `true`, renders a filled heart icon on the trailing area.
  final bool isFavorite;

  /// When `true`, renders a pin indicator and bumps the row to the top.
  final bool isPinned;

  /// When `true`, attaches a [PremiumBadge] to the row.
  final bool isPremium;

  /// When `true`, paints an unread accent dot on the avatar.
  final bool isUnread;

  /// Optional override icon shown inside the avatar.
  final IconData? leadingIcon;

  /// Optional avatar label rendered as fallback initials.
  final String? avatarLabel;

  /// Optional override for screen-reader semantics.
  final String? semanticLabel;

  /// Callback invoked when the row is tapped.
  final VoidCallback? onTap;

  /// Callback invoked when the row is long-pressed.
  final VoidCallback? onLongPress;
}
