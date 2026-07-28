import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/entities/note_entity.dart';

/// Bottom sheet offering share + copy actions for a [NoteEntity].
class NoteShareSheet {
  NoteShareSheet._();

  static Future<void> show(BuildContext context, NoteEntity note) {
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 480,
      desktop: 560,
    );
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) => _NoteShareBody(
        maxWidth: maxWidth,
        note: note,
      ),
    );
  }
}

class _NoteShareBody extends StatelessWidget {
  const _NoteShareBody({required this.maxWidth, required this.note});

  final double maxWidth;
  final NoteEntity note;

  String get _exportText {
    return '${AppStrings.notesShareMessagePrefix}\n\n${note.title}\n\n${note.content}';
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(AppStrings.notesSharedTitle,
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  ListTile(
                    leading: const Icon(AppIcons.noteContent),
                    title: const Text(AppStrings.notesShareCta),
                    subtitle: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _exportText));
                      Navigator.of(context).pop();
                      AppSnackBar.showInfo(context, AppStrings.notesLinkCopied);
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.copy_rounded,
                      color: theme.colorScheme.primary,
                    ),
                    title: const Text('Copy to clipboard'),
                    subtitle: const Text('Copies the title and content as text'),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _exportText));
                      Navigator.of(context).pop();
                      AppSnackBar.showInfo(context, AppStrings.notesLinkCopied);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
