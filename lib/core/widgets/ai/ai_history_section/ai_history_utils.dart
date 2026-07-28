import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';
import '../../../constants/app_icons.dart';
import '../ai_constants.dart';
import 'ai_history_enums.dart';
import 'ai_history_models.dart';

/// Pure utility functions used across the AI History component.
class AiHistoryUtils {
  const AiHistoryUtils._();

  /// Returns a copy of [source] sorted pinned-first then alphabetically.
  static List<AiHistoryItem> sortByPinThenTitle(List<AiHistoryItem> source) {
    final List<AiHistoryItem> copy = List<AiHistoryItem>.of(source);
    copy.sort((AiHistoryItem a, AiHistoryItem b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }
      return a.title.compareTo(b.title);
    });
    return copy;
  }

  /// Resolves the accent color used for a given [AiHistoryEntryType].
  static Color accentFor(AiHistoryEntryType type) {
    switch (type) {
      case AiHistoryEntryType.tutor:
        return AiConstants.aiViolet;
      case AiHistoryEntryType.prompt:
        return AiConstants.aiCyan;
      case AiHistoryEntryType.exam:
        return AppColors.warning;
      case AiHistoryEntryType.summary:
        return AiConstants.aiPurple;
    }
  }

  /// Resolves the default leading icon used for a given [AiHistoryEntryType].
  static IconData defaultIconFor(AiHistoryEntryType type) {
    switch (type) {
      case AiHistoryEntryType.tutor:
        return AppIcons.profile;
      case AiHistoryEntryType.prompt:
        return Icons.auto_awesome_rounded;
      case AiHistoryEntryType.exam:
        return AppIcons.trophy;
      case AiHistoryEntryType.summary:
        return Icons.summarize_rounded;
    }
  }

  /// Computes the two-letter initials used when no [AiHistoryItem.avatarLabel]
  /// is supplied.
  static String initials(String value) {
    final String trimmed = value.trim();
    if (trimmed.isEmpty) return 'AI';
    final List<String> parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      final String first = parts.first;
      return first.runes.length >= 2 ? first.substring(0, 2) : first;
    }
    return parts.take(2).map((String p) => p.characters.first).join();
  }
}
