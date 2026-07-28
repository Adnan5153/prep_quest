import 'package:flutter/material.dart';

import '../ai_constants.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';
import 'chat_message_utils.dart';

/// Small avatar disc rendered next to each message in
/// [ChatMessageList]. Renders a caller-supplied [Widget] when supplied,
/// otherwise renders a gradient pill with the author's initials.
///
/// All visual tokens come from [ChatMessageListConstants] and
/// [AiConstants] — no inline literals.
class ChatMessageAvatar extends StatelessWidget {
  const ChatMessageAvatar({
    super.key,
    required this.role,
    required this.isAi,
    this.authorName,
    this.size,
    this.overrideWidget,
    this.accent,
  });

  /// Conversation role — used to pick the default accent colour when
  /// [accent] is `null`.
  final ChatMessageRole role;

  /// Convenience flag — when `true`, the avatar is rendered with the AI
  /// accent regardless of [role]. Defaults to `role == ChatMessageRole.ai`.
  final bool isAi;

  /// Optional author name used for the default initials avatar.
  final String? authorName;

  /// Optional diameter override. Defaults to
  /// [ChatMessageListConstants.avatarSize].
  final double? size;

  /// Optional caller-supplied widget (e.g. an image / lottie player).
  /// When non-null, no default gradient avatar is rendered.
  final Widget? overrideWidget;

  /// Optional accent override. Defaults to
  /// [AiConstants.aiViolet] / [AiConstants.userGradient].
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    if (overrideWidget != null) {
      return SizedBox(
        width: size ?? ChatMessageListConstants.avatarSize,
        height: size ?? ChatMessageListConstants.avatarSize,
        child: overrideWidget,
      );
    }

    final double effectiveSize = size ?? ChatMessageListConstants.avatarSize;
    final Color resolvedAccent =
        accent ?? (isAi ? AiConstants.aiViolet : AiConstants.aiIndigo);
    final String initials = ChatMessageListUtils.initialsFor(authorName);

    final IconData icon = isAi
        ? Icons.auto_awesome_rounded
        : Icons.person_rounded;

    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            resolvedAccent.withValues(alpha: 0.95),
            (isAi ? AiConstants.aiIndigo : AiConstants.aiViolet).withValues(
              alpha: 0.95,
            ),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: resolvedAccent.withValues(alpha: 0.45),
            blurRadius: 12,
            spreadRadius: -2,
          ),
        ],
      ),
      child: Center(
        child: initials == '?'
            ? Icon(icon, size: effectiveSize * 0.5, color: Colors.white)
            : Text(
                initials,
                style: TextStyle(
                  fontSize: effectiveSize * 0.42,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.4,
                ),
              ),
      ),
    );
  }
}
