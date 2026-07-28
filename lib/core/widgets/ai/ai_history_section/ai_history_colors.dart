import 'package:flutter/material.dart';

/// Resolved palette for a single history card row.
///
/// The card resolves surface, border, text and accent colors lazily
/// from [BuildContext] and [AiHistoryItem] so they always match the
/// current theme without the widget itself caring about it.
class AiHistoryCardColors {
  const AiHistoryCardColors({
    required this.background,
    required this.border,
    required this.title,
    required this.body,
    required this.muted,
    required this.accent,
  });

  final Color background;
  final Color border;
  final Color title;
  final Color body;
  final Color muted;
  final Color accent;
}
