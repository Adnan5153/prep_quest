import 'package:flutter/material.dart';
import '../../../constants/app_spacing.dart';

class AiHintFooter extends StatelessWidget {
  const AiHintFooter({
    super.key,
    this.onCopy,
    this.onBookmark,
    this.onShare,
    this.isBookmarked = false,
  });

  final VoidCallback? onCopy;
  final VoidCallback? onBookmark;
  final VoidCallback? onShare;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onCopy != null)
          _FooterAction(
            icon: Icons.copy_rounded,
            onPressed: onCopy!,
            tooltip: 'Copy Hint',
          ),
        if (onShare != null)
          _FooterAction(
            icon: Icons.share_rounded,
            onPressed: onShare!,
            tooltip: 'Share Hint',
          ),
        if (onBookmark != null)
          _FooterAction(
            icon: isBookmarked
                ? Icons.bookmark_rounded
                : Icons.bookmark_outline_rounded,
            onPressed: onBookmark!,
            tooltip: isBookmarked ? 'Remove Bookmark' : 'Bookmark Hint',
            color: isBookmarked ? const Color(0xFFF5A623) : null,
          ),
      ],
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    this.color,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      color: color,
      tooltip: tooltip,
      splashRadius: 24,
      padding: const EdgeInsets.all(AppSpacing.xs),
      constraints: const BoxConstraints(),
    );
  }
}
