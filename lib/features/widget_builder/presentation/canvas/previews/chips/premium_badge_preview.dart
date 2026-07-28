import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/premium_badge.dart';
import '../../../providers/widget_builder_provider.dart';

class PremiumBadgePreview extends StatelessWidget {
  const PremiumBadgePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        color: theme.colorScheme.primaryContainer,
                        child: const Icon(
                          Icons.menu_book_rounded,
                          size: 64,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Positioned(
                      top: AppSpacing.md,
                      right: AppSpacing.md,
                      child: PremiumBadge(
                        label: provider.badgeLabel,
                        showIcon: provider.showBadgeIcon,
                        animate: provider.enableBadgeAnimation,
                        style: _mapBadgeStyle(provider.badgeStyle),
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Premium Guidebook',
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      const Text(
                        'Unlock exclusive BCS preparation materials and expert tips.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PremiumBadgeStyle _mapBadgeStyle(String style) {
    switch (style) {
      case 'gold':
        return PremiumBadgeStyle.gold;
      case 'amber':
        return PremiumBadgeStyle.amber;
      case 'gradient':
        return PremiumBadgeStyle.gradient;
      case 'outlined':
        return PremiumBadgeStyle.outlined;
      case 'filled':
        return PremiumBadgeStyle.filled;
      case 'glass':
        return PremiumBadgeStyle.glass;
      case 'pill':
        return PremiumBadgeStyle.pill;
      case 'compact':
        return PremiumBadgeStyle.compact;
      default:
        return PremiumBadgeStyle.gradient;
    }
  }
}
