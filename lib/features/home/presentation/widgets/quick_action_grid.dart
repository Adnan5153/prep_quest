import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../router.dart';

/// 4-tile quick-action grid on the home dashboard. Static layout —
/// the labels and routes stay constant so the home view is stable
/// across builds.
class QuickActionGrid extends StatelessWidget {
  const QuickActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final List<_QuickAction> actions = <_QuickAction>[
      _QuickAction(
        label: AppStrings.homeQuickActionQuiz,
        icon: Icons.quiz_outlined,
        color: AppColors.primary,
        onTap: () => context.goNamed(AppRoutes.quizOverview),
      ),
      _QuickAction(
        label: AppStrings.homeQuickActionLessons,
        icon: Icons.menu_book_outlined,
        color: AppColors.info,
        onTap: () => context.goNamed(AppRoutes.lessons),
      ),
      _QuickAction(
        label: AppStrings.homeQuickActionBookmarks,
        icon: Icons.bookmark_outline,
        color: AppColors.accent,
        onTap: () => context.goNamed(AppRoutes.bookmarks),
      ),
      _QuickAction(
        label: AppStrings.homeQuickActionNotes,
        icon: Icons.sticky_note_2_outlined,
        color: AppColors.secondary,
        onTap: () => context.goNamed(AppRoutes.notes),
      ),
    ];

    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1,
      children: actions
          .map((a) => _QuickActionTile(
                action: a,
                isDark: isDark,
              ))
          .toList(growable: false),
    );
  }
}

class _QuickAction {
  const _QuickAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action, required this.isDark});

  final _QuickAction action;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: action.onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.darkMuted.withValues(alpha: 0.4)
                  : AppColors.lightMuted.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(action.icon, color: action.color, size: 28),
              const SizedBox(height: 8),
              Text(
                action.label,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}