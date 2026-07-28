import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/enums/note_color.dart';

extension NoteColorX on NoteColor {
  Color resolve(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case NoteColor.defaultColor:
        return isDark
            ? AppColors.darkSurface
            : Theme.of(context).colorScheme.surfaceContainerHighest;
      case NoteColor.yellow:
        return const Color(0xFFFFF6C8);
      case NoteColor.green:
        return const Color(0xFFD9F4DA);
      case NoteColor.blue:
        return const Color(0xFFD7E8FB);
      case NoteColor.pink:
        return const Color(0xFFFBDCE4);
      case NoteColor.purple:
        return const Color(0xFFE5DAFB);
    }
  }

  Color resolveAccent(BuildContext context) {
    switch (this) {
      case NoteColor.defaultColor:
        return Theme.of(context).colorScheme.primary;
      case NoteColor.yellow:
        return const Color(0xFFC7A80B);
      case NoteColor.green:
        return const Color(0xFF2F8F3A);
      case NoteColor.blue:
        return const Color(0xFF1E6BC6);
      case NoteColor.pink:
        return returnPink;
      case NoteColor.purple:
        return const Color(0xFF6F4DC9);
    }
  }

  static const Color returnPink = Color(0xFFC84C76);
}
