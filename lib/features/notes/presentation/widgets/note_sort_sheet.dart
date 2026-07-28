import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/enums/note_sort.dart';

/// Modal sheet for switching the active [NoteSort].
class NoteSortSheet {
  NoteSortSheet._();

  static Future<NoteSort?> show(
    BuildContext context, {
    NoteSort initial = NoteSort.newest,
  }) {
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 480,
      desktop: 560,
    );
    return showModalBottomSheet<NoteSort>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          _NoteSortBody(maxWidth: maxWidth, initial: initial),
    );
  }
}

class _NoteSortBody extends StatefulWidget {
  const _NoteSortBody({required this.maxWidth, required this.initial});

  final double maxWidth;
  final NoteSort initial;

  @override
  State<_NoteSortBody> createState() => _NoteSortBodyState();
}

class _NoteSortBodyState extends State<_NoteSortBody> {
  late NoteSort _selected = widget.initial;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.sm,
                AppSpacing.lg,
                AppSpacing.lg,
              ),
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
                  Row(
                    children: <Widget>[
                      Icon(AppIcons.noteSort,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppStrings.notesSortTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  for (final NoteSort s in NoteSort.values)
                    ListTile(
                      title: Text(s.displayLabel),
                      trailing: Icon(
                        _selected == s
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                      ),
                      onTap: () => setState(() => _selected = s),
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                    ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(NoteSort.newest),
                          child: const Text('Reset'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              Navigator.of(context).pop(_selected),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
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
