import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router.dart';
import '../../../category_api/domain/entities/category_entity.dart';

/// "Continue learning" tile — surfaces the next incomplete category
/// from the backend so the user can resume without picking from a
/// menu. Renders nothing when no category is available.
class ContinueLearningCard extends StatelessWidget {
  const ContinueLearningCard({super.key, required this.category});

  final CategoryEntity? category;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final CategoryEntity? c = category;

    if (c == null) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.goNamed(
          AppRoutes.lessons,
          queryParameters: <String, String>{'nodeId': c.id},
        ),
        child: Ink(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary),
          ),
          child: Row(
            children: <Widget>[
              const Icon(Icons.play_circle_outline,
                  size: 36, color: AppColors.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      AppStrings.homeContinueLearningTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      c.title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkOnSurface
                            : AppColors.lightOnSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                AppStrings.homeContinueLearningCta,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}