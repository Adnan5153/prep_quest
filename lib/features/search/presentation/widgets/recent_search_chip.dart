import 'package:flutter/material.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/category_chip.dart';

class RecentSearchChip extends StatelessWidget {
  const RecentSearchChip({
    super.key,
    required this.query,
    required this.onTap,
  });

  final String query;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CategoryChip(
      label: query,
      leading: const Icon(AppIcons.searchRecent, size: 16),
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
    );
  }
}