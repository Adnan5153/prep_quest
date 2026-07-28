import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

/// Confirmation dialog used before deleting a note.
class DeleteNoteDialog extends StatelessWidget {
  const DeleteNoteDialog({super.key});

  static Future<bool> show(BuildContext context) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => const DeleteNoteDialog(),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AlertDialog(
      title: const Text(AppStrings.notesDeleteTitle),
      content: const Text(AppStrings.notesDeleteBody),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(AppStrings.notesDeleteCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text(AppStrings.notesDeleteConfirm),
        ),
      ],
    );
  }
}
