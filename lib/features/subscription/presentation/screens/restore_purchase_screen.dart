import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/subscription_entity.dart';
import '../constants/subscription_strings.dart';
import '../providers/subscription_provider.dart';
import '../widgets/current_plan_banner/current_plan_banner.dart';
import '../widgets/loading_state/loading_state.dart';
import '../widgets/restore_button/restore_button.dart';

/// Restore Purchase screen. Walks the user through re-reading their
/// purchases from the payment gateway and refreshing the locally
/// cached entitlement. Reflects the outcome in the current-plan banner.
class RestorePurchaseScreen extends ConsumerStatefulWidget {
  const RestorePurchaseScreen({super.key});

  @override
  ConsumerState<RestorePurchaseScreen> createState() =>
      _RestorePurchaseScreenState();
}

class _RestorePurchaseScreenState extends ConsumerState<RestorePurchaseScreen> {
  bool _isRestoring = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final SubscriptionState state =
          ref.read(subscriptionControllerProvider);
      if (state.status == SubscriptionLoadStatus.initial) {
        ref.read(subscriptionControllerProvider.notifier).bootstrap();
      }
    });
  }

  Future<void> _restore() async {
    setState(() => _isRestoring = true);
    try {
      final SubscriptionEntity restored =
          await ref.read(subscriptionControllerProvider.notifier).restore();
      if (!mounted) return;
      if (restored.isPremium) {
        AppSnackBar.showSuccess(
          context,
          SubscriptionStrings.restoreSuccessBody,
        );
      } else {
        AppSnackBar.showInfo(
          context,
          SubscriptionStrings.restoreNothingBody,
        );
      }
    } on Object catch (e) {
      if (!mounted) return;
      AppSnackBar.showError(
        context,
        '${SubscriptionStrings.purchaseFailedBody} ($e)',
      );
    } finally {
      if (mounted) setState(() => _isRestoring = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubscriptionState>(subscriptionControllerProvider, (_, _) {});
    final SubscriptionState state =
        ref.watch(subscriptionControllerProvider);
    final SubscriptionEntity current =
        state.subscription ?? SubscriptionEntity.free();

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SubscriptionStrings.restoreCta),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.subscriptionPlans),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: state.status == SubscriptionLoadStatus.restoring &&
                    state.subscription == null
                ? const SubscriptionLoadingState(
                    title: SubscriptionStrings.processingTitle,
                    subtitle: SubscriptionStrings.processingBody,
                    skeletonRows: 2,
                  )
                : ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: <Widget>[
                      CurrentPlanBanner(subscription: current),
                      const SizedBox(height: AppSpacing.lg),
                      GlassCard(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              SubscriptionStrings.sectionRestore,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              SubscriptionStrings.restoreDescription,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.refresh_rounded,
                                  color: AppColors.success,
                                  size: AppSizes.iconMd,
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    current.isPremium
                                        ? SubscriptionStrings
                                            .restoreSuccessBody
                                        : SubscriptionStrings
                                            .restoreNothingBody,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.7),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            RestoreButton(
                              onPressed:
                                  _isRestoring ? null : _restore,
                              isLoading: _isRestoring,
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
}