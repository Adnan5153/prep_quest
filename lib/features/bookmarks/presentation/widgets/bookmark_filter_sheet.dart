import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/enums/bookmark_filter.dart';
import 'bookmark_filter_chip.dart';

/// Modal sheet letting the user switch the active [BookmarkFilter].
class BookmarkFilterSheet {
  BookmarkFilterSheet._();

  static Future<BookmarkFilter?> show(
    BuildContext context, {
    BookmarkFilter initial = BookmarkFilter.all,
  }) {
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 480,
      desktop: 560,
    );
    return showModalBottomSheet<BookmarkFilter>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _BookmarkFilterBody(maxWidth: maxWidth, initial: initial);
      },
    );
  }
}

class _BookmarkFilterBody extends StatefulWidget {
  const _BookmarkFilterBody({required this.maxWidth, required this.initial});

  final double maxWidth;
  final BookmarkFilter initial;

  @override
  State<_BookmarkFilterBody> createState() => _BookmarkFilterBodyState();
}

class _BookmarkFilterBodyState extends State<_BookmarkFilterBody> {
  late BookmarkFilter _selected = widget.initial;

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
                      Icon(AppIcons.searchFilter, color: theme.colorScheme.primary),
                      const SizedBox(width: AppSpacing.sm),
                      Text(AppStrings.bookmarksFilterTitle,
                          style: theme.textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final BookmarkFilter filter
                          in BookmarkFilter.values)
                        BookmarkFilterChip(
                          filter: filter,
                          selected: _selected == filter,
                          onChanged: (_) {
                            setState(() => _selected = filter);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              Navigator.of(context).pop(BookmarkFilter.all),
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
