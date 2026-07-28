import 'package:flutter/material.dart';

import '../../../../../core/constants/app_radius.dart';
import 'quiz_option_utils.dart';

/// Visual-only tile used by [QuizOption]. The widget is the
/// background and border; the parent supplies the inner content.
class QuizOptionTile extends StatelessWidget {
  const QuizOptionTile({
    super.key,
    required this.kind,
    required this.palette,
    required this.letter,
    required this.isMultiSelect,
    required this.isSelected,
    required this.isLocked,
    required this.onTap,
    required this.child,
  });

  final QuizOptionVisualKind kind;
  final QuizOptionPalette palette;
  final String letter;
  final bool isMultiSelect;
  final bool isSelected;
  final bool isLocked;
  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(AppRadius.md);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: radius,
        border: Border.all(
          color: palette.border,
          width: palette.borderWidth,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: radius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          borderRadius: radius,
          child: child,
        ),
      ),
    );
  }
}