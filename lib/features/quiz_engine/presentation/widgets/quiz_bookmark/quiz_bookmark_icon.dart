import 'package:flutter/material.dart';

class QuizBookmarkIcon extends StatelessWidget {
  const QuizBookmarkIcon({
    super.key,
    required this.isBookmarked,
    this.size = 18,
  });

  final bool isBookmarked;
  final double size;

  @override
  Widget build(BuildContext context) {
    final Color color = isBookmarked
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline;
    return Icon(
      isBookmarked ? Icons.bookmark : Icons.bookmark_border,
      color: color,
      size: size,
    );
  }
}