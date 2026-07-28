import 'package:flutter/material.dart';

import '../../constants/quiz_strings.dart';

class QuizBookmarkButton extends StatelessWidget {
  const QuizBookmarkButton({
    super.key,
    required this.isBookmarked,
    required this.onToggle,
  });

  final bool isBookmarked;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: isBookmarked
          ? QuizStrings.bookmarkRemove
          : QuizStrings.bookmarkAdd,
      onPressed: onToggle,
      icon: Icon(
        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
      ),
    );
  }
}