import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/ai/loading/ai_loading_section.dart';

/// Loading state shown while the Review list fetches.
class ReviewLoadingState extends StatelessWidget {
  const ReviewLoadingState({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (BuildContext context, int index) {
        return const AiLoadingSection(
          itemCount: 1,
          showAvatar: false,
          showSubtitle: true,
          showBody: true,
          bodyLineCount: 3,
        );
      },
    );
  }
}