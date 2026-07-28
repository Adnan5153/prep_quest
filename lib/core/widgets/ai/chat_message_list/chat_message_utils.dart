import 'package:flutter/material.dart';

import '../../../constants/app_spacing.dart';
import 'chat_message_list_constants.dart';

/// Small, dependency-free utilities for the [ChatMessageList] widget
/// family. Pure functions only — no widget state.
class ChatMessageListUtils {
  const ChatMessageListUtils._();

  /// True when the [position] of the [controller] is within
  /// [ChatMessageListConstants.atBottomThreshold] of the maximum extent.
  ///
  /// Used to decide whether a newly inserted message should trigger
  /// auto-scroll.
  static bool isAtBottom(ScrollController controller) {
    if (!controller.hasClients) return false;
    final double max = controller.position.maxScrollExtent;
    final double current = controller.position.pixels;
    return max - current <= ChatMessageListConstants.atBottomThreshold;
  }

  /// Smoothly scrolls the [controller] to the bottom of the list. No-op
  /// if the controller is not attached to a scroll view.
  static void scrollToBottom(ScrollController controller) {
    if (!controller.hasClients) return;
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: ChatMessageListConstants.enterDuration,
      curve: Curves.easeOutCubic,
    );
  }

  /// Picks a responsive bubble width from the available [width]. The
  /// cap matches the chat-bubble visual language (we never let a message
  /// stretch edge-to-edge on wide screens).
  static double resolveBubbleMaxWidth(double width) {
    if (width >= ChatMessageListConstants.wideBreakpoint) {
      return ChatMessageListConstants.maxBubbleWidth;
    }
    if (width >= ChatMessageListConstants.compactBreakpoint) {
      return 600.0;
    }
    return width;
  }

  /// Picks a responsive vertical gap between two consecutive messages.
  static double resolveMessageGap(double width) {
    return width < ChatMessageListConstants.compactBreakpoint
        ? AppSpacing.sm
        : ChatMessageListConstants.messageGap;
  }

  /// Compresses a string into 1–2 letter initials for the default avatar.
  /// Returns `?` if no usable characters are found.
  static String initialsFor(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final List<String> parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((String p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  /// Whether a tap on a footer action should fire haptic feedback.
  /// Pure constant — exists so callers can override at one site.
  static const bool enableFooterHaptics = true;
}

/// Convenience constants surfaced for downstream callers.
class ChatMessageBubbleDefaults {
  const ChatMessageBubbleDefaults._();

  static const String aiTitle = 'Prep Quest AI';
  static const String userTitle = 'You';
}
