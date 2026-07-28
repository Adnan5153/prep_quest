import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/loading_widget.dart';

/// Feature-local loading widget used while a search round-trip is in
/// flight. Mirrors how [NotificationScreen] and [StreakScreen] build
/// their own (no central `SearchLoading` class is needed).
class SearchLoading extends StatelessWidget {
  const SearchLoading({super.key, this.query});
  final String? query;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LoadingWidget(
          loaderType: LoaderType.circular,
          title: 'Searching\u2026',
          subtitle: (query == null || query!.isEmpty) ? null : 'for "$query"',
          showProgress: false,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}