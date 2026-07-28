import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../domain/enums/search_category.dart';
import 'search_category_tabs.dart';

/// Modal sheet listing every concrete [SearchCategory] (excluding `all`)
/// so the user can toggle multi-select filters on narrow viewports.
class SearchFilterSheet {
  SearchFilterSheet._();

  static Future<Set<SearchCategory>?> show(
    BuildContext context, {
    Set<SearchCategory> initial = const <SearchCategory>{},
  }) {
    final ThemeData theme = Theme.of(context);
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: 480,
      desktop: 560,
    );
    return showModalBottomSheet<Set<SearchCategory>>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _SearchFilterBody(
          maxWidth: maxWidth,
          initial: initial,
          theme: theme,
        );
      },
    );
  }
}

class _SearchFilterBody extends StatefulWidget {
  const _SearchFilterBody({
    required this.maxWidth,
    required this.initial,
    required this.theme,
  });

  final double maxWidth;
  final Set<SearchCategory> initial;
  final ThemeData theme;

  @override
  State<_SearchFilterBody> createState() => _SearchFilterBodyState();
}

class _SearchFilterBodyState extends State<_SearchFilterBody> {
  late Set<SearchCategory> _selected =
      Set<SearchCategory>.from(widget.initial);

  void _toggle(SearchCategory category) {
    setState(() {
      if (_selected.contains(category)) {
        _selected.remove(category);
      } else {
        _selected.add(category);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: widget.maxWidth),
        child: Material(
          color: widget.theme.colorScheme.surface,
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
                        color: widget.theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Icon(
                        AppIcons.searchFilter,
                        color: widget.theme.colorScheme.primary,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        AppStrings.searchFilterTitle,
                        style: widget.theme.textTheme.titleMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      for (final SearchCategory category
                          in const <SearchCategory>[
                        SearchCategory.lessons,
                        SearchCategory.questions,
                        SearchCategory.topics,
                        SearchCategory.books,
                        SearchCategory.aiHistory,
                      ])
                        FilterChip(
                          label: Text(category.displayLabel),
                          selected: _selected.contains(category),
                          onSelected: (_) => _toggle(category),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context)
                              .pop(<SearchCategory>{}),
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