import 'package:flutter/foundation.dart';

/// Set of optional actions and lifecycle state exposed by [ChatInputBar].
///
/// All callbacks default to `null`; the corresponding affordance is hidden
/// when none are supplied. State booleans drive the visual treatment of
/// the relevant buttons (e.g. [isLoading] replaces the send icon with a
/// progress indicator, [isRecording] flips the microphone icon).
@immutable
class ChatInputBarActions {
  const ChatInputBarActions({
    this.onSend,
    this.onAttachmentTap,
    this.onMicrophoneTap,
    this.onClear,
    this.onChanged,
    this.onSubmitted,
    this.isLoading = false,
    this.isRecording = false,
    this.canSend = true,
  });

  /// Send callback — receives the current input text. The caller is
  /// responsible for clearing the controller when appropriate.
  final ValueChanged<String>? onSend;

  /// Attachment button callback.
  final VoidCallback? onAttachmentTap;

  /// Microphone button callback.
  final VoidCallback? onMicrophoneTap;

  /// Clear button callback. The bar shows a clear affordance while the
  /// controller has content — tapping it fires this callback and lets
  /// the caller decide whether to clear the controller.
  final VoidCallback? onClear;

  /// Live change callback — fires on every keystroke.
  final ValueChanged<String>? onChanged;

  /// Submit callback — fires when the user taps the keyboard's "send"
  /// action. Most callers should rely on [onSend] for the primary path.
  final ValueChanged<String>? onSubmitted;

  /// When `true`, the send button renders a progress indicator instead
  /// of the icon and dispatches become no-ops.
  final bool isLoading;

  /// When `true`, the microphone button renders the active recording
  /// treatment (red glow + filled icon).
  final bool isRecording;

  /// When `false`, the send button is disabled regardless of [onSend].
  /// Typically driven by validation logic on the caller side (e.g. an
  /// empty prompt or a character-limit cap).
  final bool canSend;

  /// True when any callback is supplied.
  bool get hasAny =>
      onSend != null ||
      onAttachmentTap != null ||
      onMicrophoneTap != null ||
      onClear != null ||
      onChanged != null ||
      onSubmitted != null;

  /// True when at least one trailing action button should be rendered.
  bool get hasTrailing =>
      onSend != null || onAttachmentTap != null || onMicrophoneTap != null;

  /// Creates a copy with overridden fields.
  ChatInputBarActions copyWith({
    ValueChanged<String>? onSend,
    VoidCallback? onAttachmentTap,
    VoidCallback? onMicrophoneTap,
    VoidCallback? onClear,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    bool? isLoading,
    bool? isRecording,
    bool? canSend,
  }) {
    return ChatInputBarActions(
      onSend: onSend ?? this.onSend,
      onAttachmentTap: onAttachmentTap ?? this.onAttachmentTap,
      onMicrophoneTap: onMicrophoneTap ?? this.onMicrophoneTap,
      onClear: onClear ?? this.onClear,
      onChanged: onChanged ?? this.onChanged,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      isLoading: isLoading ?? this.isLoading,
      isRecording: isRecording ?? this.isRecording,
      canSend: canSend ?? this.canSend,
    );
  }
}

/// Soft cap applied to the optional character counter. When supplied
/// alongside [showCounter], the bar shows `currentLength / maxLength`.
@immutable
class ChatInputBarCounter {
  const ChatInputBarCounter({required this.maxLength, this.warnAt = 0.85})
    : assert(maxLength > 0, 'maxLength must be positive');

  /// Maximum allowed character count.
  final int maxLength;

  /// Fraction of [maxLength] at which the counter switches to its
  /// warning colour. Defaults to `0.85`.
  final double warnAt;
}
