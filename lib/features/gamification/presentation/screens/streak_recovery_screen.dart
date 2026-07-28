import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../router.dart';
import '../../domain/enums/streak_enums.dart';
import '../constants/streak_strings.dart';
import '../providers/streak_provider.dart';
import '../widgets/streak_flame.dart';

/// Full-page streak-recovery flow with the two payment options.
class StreakRecoveryScreen extends ConsumerStatefulWidget {
  const StreakRecoveryScreen({super.key});

  @override
  ConsumerState<StreakRecoveryScreen> createState() =>
      _StreakRecoveryScreenState();
}

class _StreakRecoveryScreenState
    extends ConsumerState<StreakRecoveryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(streakControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final StreakViewState state = ref.watch(streakControllerProvider);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color surface =
        isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final Color foreground =
        isDark ? AppColors.darkOnSurface : AppColors.lightOnSurface;
    return Scaffold(
      appBar: AppBar(
        title: const Text(StreakStrings.recoveryTitle),
        leading: IconButton(
          icon: const Icon(AppIcons.close),
          onPressed: () => context.goNamed(AppRoutes.streak),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Row(
                  children: <Widget>[
                    const StreakFlame(isAlive: false),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            StreakStrings.recoveryTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: foreground,
                                ),
                          ),
                          Text(
                            StreakStrings.recoverySubtitle,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _MethodCard(
                title: StreakStrings.recoveryCoinsTitle,
                subtitle: StreakStrings.recoveryCoinsSubtitle,
                icon: AppIcons.coinIcon,
                color: AppColors.warning,
                isDark: isDark,
                onTap: state.isReady
                    ? () => _confirmRecovery(RecoveryMethod.coins)
                    : null,
              ),
              const SizedBox(height: AppSpacing.md),
              _MethodCard(
                title: StreakStrings.recoveryPremiumTitle,
                subtitle: StreakStrings.recoveryPremiumSubtitle,
                icon: AppIcons.crown,
                color: AppColors.accent,
                isDark: isDark,
                onTap: state.isReady
                    ? () => _confirmRecovery(RecoveryMethod.premium)
                    : null,
              ),
              const SizedBox(height: AppSpacing.lg),
              if (state.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(
                    state.errorMessage!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                ),
              const Spacer(),
              SecondaryButton(
                text: StreakStrings.recoveryCancel,
                onPressed: () => context.goNamed(AppRoutes.streak),
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmRecovery(RecoveryMethod method) {
    ref
        .read(streakControllerProvider.notifier)
        .recover(method: method)
        .then((dynamic _) {
      if (!mounted) return;
      context.goNamed(AppRoutes.streak);
    });
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isDark;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: color.withValues(alpha: 0.4),
              width: 1.0,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(icon, size: AppSizes.iconLg, color: color),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                AppIcons.chevronRight,
                size: AppSizes.iconMd,
                color: AppColors.lightMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}