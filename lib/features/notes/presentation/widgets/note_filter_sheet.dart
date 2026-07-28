import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/enums/note_filter.dart';
import 'note_filter_chip.dart';

/// Modal sheet for switching the active [NoteFilter].
class NoteFilterSheet {
  NoteFilterSheet._();

  static Future<NoteFilter?> show(
    BuildContext context, {
    NoteFilter initial = NoteFilter.all,
  }) {
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 480,
      desktop: 560,
    );
    return showModalBottomSheet<NoteFilter>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) =>
          _NoteFilterBody(maxWidth: maxWidth, initial: initial),
    );
  }
}

class _NoteFilterBody extends StatefulWidget {
  const _NoteFilterBody({required this.maxWidth, required this.initial});

  final double maxWidth;
  final NoteFilter initial;

  @override
  State<_NoteFilterBody> createState() => _NoteFilterBodyState();
}

class _NoteFilterBodyState extends State<_NoteFilterBody> {
  late NoteFilter _selected = widget.initial;

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
                      Icon(AppIcons.noteFilter,
                          color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppStrings.notesFilterTitle,
                        style: theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final NoteFilter filter in NoteFilter.values)
                        NoteFilterChip(
                          filter: filter,
                          selected: _selected == filter,
                          onChanged: (NoteFilter f) =>
                              setState(() => _selected = f),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context)
                              .pop(NoteFilter.all),
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
