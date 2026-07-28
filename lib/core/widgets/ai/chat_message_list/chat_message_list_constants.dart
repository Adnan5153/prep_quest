import 'package:flutter/material.dart';

import '../../../constants/app_radius.dart';
import '../../../constants/app_sizes.dart';
import '../../../constants/app_spacing.dart';

/// Centralised design tokens for the [ChatMessageList] widget family.
///
/// Owns every layout / sizing token used by the message list and its
/// per-row renderers. Scrolling behaviour, max bubble widths, padding
/// gaps and the responsive breakpoints all live here so the surface
/// stays visually consistent and easy to retheme.
class ChatMessageListConstants {
  const ChatMessageListConstants._();

  // ---------------------------------------------------------------------------
  // Radii
  // ---------------------------------------------------------------------------

  /// Outer radius of the avatar disc.
  static const double avatarRadius = AppRadius.pill;

  /// Outer radius of the timestamp pill.
  static const double timestampRadius = AppRadius.pill;

  /// Outer radius of the action footer pill.
  static const double actionRadius = AppRadius.pill;

  // ---------------------------------------------------------------------------
  // Decorative sizes
  // ---------------------------------------------------------------------------

  /// Diameter of the avatar disc.
  static const double avatarSize = 36.0;

  /// Compact avatar size used in dense mode.
  static const double compactAvatarSize = 28.0;

  /// Footer action pill height.
  static const double actionHeight = 28.0;

  /// Maximum width of any single bubble. Mirrors the AI chat bubble cap
  /// (we do not let messages stretch edge-to-edge on wide screens).
  static const double maxBubbleWidth = 720.0;

  /// Compact breakpoint — switches message spacing to a tighter cadence.
  static const double compactBreakpoint = AppSizes.mobileMaxWidth;

  /// Wide breakpoint — switches message max-width to a larger cap.
  static const double wideBreakpoint = AppSizes.tabletMaxWidth;

  /// Threshold (in logical pixels) that counts as "user is at the bottom"
  /// when deciding whether to auto-scroll on a new message.
  static const double atBottomThreshold = 96.0;

  // ---------------------------------------------------------------------------
  // Spacing scale (overrides for list-internal rhythm).
  // ---------------------------------------------------------------------------

  static const double gapXxs = AppSpacing.xxs;
  static const double gapXs = AppSpacing.xs;
  static const double gapSm = AppSpacing.sm;
  static const double gapMd = AppSpacing.md;
  static const double gapLg = AppSpacing.lg;
  static const double gapXl = AppSpacing.xl;
  static const double gapXxl = AppSpacing.xxl;

  /// Horizontal padding applied to the whole list.
  static const EdgeInsets listPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.md,
  );

  /// Vertical gap between two consecutive messages.
  static const double messageGap = AppSpacing.sm;

  /// Gap between the avatar and the bubble.
  static const double avatarGap = AppSpacing.sm;

  /// Gap between the bubble and the action row.
  static const double actionsGap = AppSpacing.xs;

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  /// Timestamp text size.
  static const double timestampFontSize = 11.0;

  /// Inline status text size.
  static const double statusFontSize = 11.0;

  // ---------------------------------------------------------------------------
  // Animation
  // ---------------------------------------------------------------------------

  /// Duration of the typing-dot bounce.
  static const Duration typingDotDuration = Duration(milliseconds: 600);

  /// Interval between typing-dot bounces.
  static const Duration typingDotStagger = Duration(milliseconds: 120);

  /// Duration of the enter (fade + slide) animation applied to each
  /// newly inserted message.
  static const Duration enterDuration = Duration(milliseconds: 260);

  // ---------------------------------------------------------------------------
  // Defaults
  // ---------------------------------------------------------------------------

  /// Default author label for AI messages when the caller doesn't pass one.
  static const String defaultAiTitle = 'Prep Quest AI';

  /// Default author label for user messages.
  static const String defaultUserTitle = 'You';

  /// Default text passed to the soft keyboard's send affordance.
  static const String defaultSendLabel = 'Send';

  /// Default accessibility label for the whole list.
  static const String defaultSemanticLabel = 'Conversation';

  // ---------------------------------------------------------------------------
  // Opacity / shadow
  // ---------------------------------------------------------------------------

  /// Opacity used for the dim "muted" footer action.
  static const double mutedActionOpacity = 0.18;

  /// Opacity used for the resting footer action.
  static const double restingActionOpacity = 0.10;

  /// Opacity used for the hover footer action.
  static const double hoverActionOpacity = 0.16;

  /// Border opacity used for the resting footer action.
  static const double restingBorderOpacity = 0.25;

  /// Border opacity used for the hover footer action.
  static const double hoverBorderOpacity = 0.45;

  /// Border opacity used for the selected footer action.
  static const double selectedBorderOpacity = 0.6;

  // ---------------------------------------------------------------------------
  // Color helpers
  // ---------------------------------------------------------------------------

  /// Subtle shadow under the message list (used when [elevation] > 0).
  static List<BoxShadow> listShadow(Color tint, bool isDark) => <BoxShadow>[
    BoxShadow(
      color: tint.withValues(alpha: isDark ? 0.35 : 0.06),
      blurRadius: 18,
      spreadRadius: -6,
      offset: const Offset(0, 8),
    ),
  ];
}

/// Lifecycle / loading state of an individual message or the whole list.
///
/// Used by [ChatMessageState] and the [ChatMessageListState] enum.
enum ChatMessageDeliveryState {
  /// Message has not yet been sent (still in the input).
  pending,

  /// Message is being sent (network in flight).
  sending,

  /// Message was delivered but no AI response yet.
  delivered,

  /// AI is currently streaming a response.
  streaming,

  /// Message produced an error (network / generation failure).
  failed,
}

/// Top-level state of the conversation the list is rendering.
enum ChatMessageListState {
  /// Messages rendered normally.
  ready,

  /// Conversation is empty.
  empty,

  /// Conversation is loading (initial fetch).
  loading,

  /// Conversation failed to load.
  error,
}

/// Status flag surfaced inside a message bubble (read receipts,
/// retry, regenerate, etc.).
enum ChatMessageStatusFlag {
  /// No status to show.
  none,

  /// Message was sent.
  sent,

  /// Message was delivered.
  delivered,

  /// Message was read.
  read,

  /// Message failed and can be retried.
  failed,
}
