import 'package:flutter/material.dart';

import '../../domain/entities/note_entity.dart';
import 'note_card.dart';

/// Full-bleed grid item for the desktop view.
class NoteGridItem extends StatelessWidget {
  const NoteGridItem({
    super.key,
    required this.note,
    required this.onTap,
    required this.onTogglePin,
    required this.onToggleFavorite,
    required this.onShare,
  });

  final NoteEntity note;
  final VoidCallback onTap;
  final VoidCallback onTogglePin;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: NoteCard(
        note: note,
        onTap: onTap,
        onTogglePin: onTogglePin,
        onToggleFavorite: onToggleFavorite,
        onShare: onShare,
      ),
    );
  }
}
