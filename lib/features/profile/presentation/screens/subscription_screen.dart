import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../../subscription/presentation/providers/subscription_provider.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isPremium = ref.watch(isPremiumProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed(AppRoutes.profile),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveBuilder.value<double>(
                  context,
                  mobile: double.infinity,
                  tablet: AppSizes.tabletMaxWidth.toDouble(),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _StatusCard(isPremium: isPremium),
                  const SizedBox(height: AppSpacing.lg),
                  const _PlanGrid(),
                  const SizedBox(height: AppSpacing.lg),
                  const _BenefitsList(),
                  const SizedBox(height: AppSpacing.lg),
                  if (!isPremium)
                    PrimaryButton(
                      text: 'Upgrade to Premium',
                      onPressed: () =>
                          context.pushNamed(AppRoutes.subscriptionPlans),
                    )
                  else
                    SecondaryButton(
                      text: 'Manage subscription',
                      onPressed: () =>
                          context.pushNamed(AppRoutes.subscriptionRestore),
                      fullWidth: false,
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gradient: isPremium
          ? const LinearGradient(
              colors: <Color>[AppColors.accent, AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                isPremium
                    ? Icons.workspace_premium_rounded
                    : Icons.lock_outline_rounded,
                color: isPremium ? Colors.white : theme.colorScheme.primary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                isPremium ? 'Prep Quest Premium' : 'Free plan',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isPremium ? Colors.white : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isPremium
                ? 'Unlimited lessons, AI tutor, mock tests, and ad-free study.'
                : 'You are on the free tier. Upgrade to unlock unlimited access.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isPremium
                  ? Colors.white.withValues(alpha: 0.85)
                  : theme.textTheme.bodyMedium?.color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanGrid extends StatelessWidget {
  const _PlanGrid();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const <Widget>[
        _PlanTile(
          title: 'Monthly',
          price: '৳ 299 / mo',
          description: 'All premium features, cancel anytime.',
        ),
        SizedBox(height: AppSpacing.sm),
        _PlanTile(
          title: 'Yearly',
          price: '৳ 2,499 / yr',
          description: 'Save 30% versus monthly.',
          highlight: true,
        ),
        SizedBox(height: AppSpacing.sm),
        _PlanTile(
          title: 'Lifetime',
          price: '৳ 6,999',
          description: 'Pay once, keep forever.',
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.title,
    required this.price,
    required this.description,
    this.highlight = false,
  });

  final String title;
  final String price;
  final String description;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      borderColor: highlight
          ? AppColors.accent.withValues(alpha: 0.6)
          : null,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (highlight) ...<Widget>[
                      const SizedBox(width: AppSpacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius:
                              BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          'Best value',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  description,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Text(
            price,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: highlight ? AppColors.accent : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  @override
  Widget build(BuildContext context) {
    final List<_Benefit> benefits = const <_Benefit>[
      _Benefit(Icons.menu_book_rounded, 'Unlimited lessons & summaries'),
      _Benefit(Icons.bolt_rounded, 'AI tutor with extended context'),
      _Benefit(Icons.quiz_rounded, 'Unlimited mock tests'),
      _Benefit(Icons.workspace_premium_rounded, 'Exclusive badges'),
      _Benefit(Icons.block_rounded, 'Ad-free experience'),
    ];
    return GlassCard(
      borderRadius: BorderRadius.circular(AppRadius.lg),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'What you get',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final _Benefit benefit in benefits)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                children: <Widget>[
                  Icon(benefit.icon,
                      color: AppColors.success, size: AppSizes.iconSm),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      benefit.label,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _Benefit {
  const _Benefit(this.icon, this.label);

  final IconData icon;
  final String label;
}