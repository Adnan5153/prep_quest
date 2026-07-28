import 'package:flutter/material.dart';

import '../ai_constants.dart';
import 'chat_message_avatar.dart';
import 'chat_message_list_constants.dart';
import 'chat_message_list_models.dart';

/// Skeleton placeholder rendered while a single AI message is being
/// fetched / generated.
///
/// Pairs a leading avatar with three shimmering body lines. Lives next
/// to the AI message so the visual rhythm of the conversation is
/// preserved during loading.
class ChatMessageLoading extends StatelessWidget {
  const ChatMessageLoading({
    super.key,
    this.authorName = ChatMessageListConstants.defaultAiTitle,
    this.lineCount = 3,
    this.accent,
    this.isDark = false,
    this.showAvatar = true,
  });

  /// Author name rendered into the placeholder avatar's initials.
  final String authorName;

  /// Number of shimmering body lines (1–6). Default 3.
  final int lineCount;

  /// Optional accent override. Defaults to [AiConstants.aiViolet].
  final Color? accent;

  /// Dark-mode hint used by the avatar accent resolution.
  final bool isDark;

  /// When `false`, the leading avatar is hidden (compact loader).
  final bool showAvatar;

  @override
  Widget build(BuildContext context) {
    final int safeCount = lineCount.clamp(1, 6);

    final List<Widget> bodyLines = <Widget>[
      for (int i = 0; i < safeCount; i++)
        Padding(
          padding: EdgeInsets.only(
            bottom: i == safeCount - 1 ? 0 : ChatMessageListConstants.gapSm,
          ),
          child: _SkeletonLine(
            accent: accent ?? AiConstants.aiViolet,
            widthFactor: _widthFactorFor(i, safeCount),
          ),
        ),
    ];

    final Widget bubble = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ChatMessageListConstants.gapLg,
        vertical: ChatMessageListConstants.gapMd,
      ),
      decoration: BoxDecoration(
        color: (accent ?? AiConstants.aiViolet).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ChatMessageListConstants.gapXl),
        border: Border.all(
          color: (accent ?? AiConstants.aiViolet).withValues(alpha: 0.18),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: bodyLines,
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: ChatMessageListConstants.gapXs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          if (showAvatar) ...<Widget>[
            ChatMessageAvatar(
              role: ChatMessageRole.ai,
              isAi: true,
              authorName: authorName,
              accent: accent,
            ),
            const SizedBox(width: ChatMessageListConstants.avatarGap),
          ],
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ChatMessageListConstants.maxBubbleWidth,
              ),
              child: bubble,
            ),
          ),
        ],
      ),
    );
  }

  double _widthFactorFor(int index, int total) {
    if (total == 1) return 0.6;
    if (index == total - 1) return 0.5;
    if (index == 0) return 0.92;
    return 0.78;
  }
}

class _SkeletonLine extends StatefulWidget {
  const _SkeletonLine({required this.accent, required this.widthFactor});

  final Color accent;
  final double widthFactor;

  @override
  State<_SkeletonLine> createState() => _SkeletonLineState();
}

class _SkeletonLineState extends State<_SkeletonLine>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return FractionallySizedBox(
          widthFactor: widget.widthFactor,
          alignment: Alignment.centerLeft,
          child: Container(
            height: 12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: LinearGradient(
                begin: Alignment(-1 + 2 * _controller.value, 0),
                end: Alignment(0 + 2 * _controller.value, 0),
                colors: <Color>[
                  widget.accent.withValues(alpha: 0.10),
                  widget.accent.withValues(alpha: 0.22),
                  widget.accent.withValues(alpha: 0.10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
