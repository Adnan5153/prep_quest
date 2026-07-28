import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import '../widgets/benefits_card/benefits_card.dart';
import '../widgets/billing_cycle_selector/billing_cycle_selector.dart';
import '../widgets/current_plan_banner/current_plan_banner.dart';
import '../widgets/empty_state/empty_state.dart';
import '../widgets/error_state/error_state.dart';
import '../widgets/loading_state/loading_state.dart';
import '../widgets/plan_card/plan_card.dart';
import '../widgets/premium_banner/premium_banner.dart';
import '../widgets/restore_button/restore_button.dart';

/// Primary Subscription Plans screen — the hub that the Profile
/// menu's "Subscription" entry, the Profile → Subscription tab, and
/// every premium upsell CTA in the app all route to.
class SubscriptionPlansScreen extends ConsumerStatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  ConsumerState<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState
    extends ConsumerState<SubscriptionPlansScreen> {
  BillingCycle _cycle = BillingCycle.yearly;

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

  Future<void> _onPlanChosen(SubscriptionPlanEntity plan) async {
    if (plan.tier == SubscriptionTier.free) {
      AppSnackBar.showInfo(context, 'You are already on the Free plan.');
      return;
    }
    final String providerCode = plan.paymentProviderCodes.isNotEmpty
        ? plan.paymentProviderCodes.first
        : 'play:billing:unknown';
    await context.pushNamed<void>(
      AppRoutes.subscriptionPurchase,
      extra: <String, String>{
        'planId': plan.id,
        'providerCode': providerCode,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SubscriptionState>(subscriptionControllerProvider, (_, _) {});
    final SubscriptionState state =
        ref.watch(subscriptionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SubscriptionStrings.screenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.profile),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.compare_arrows_rounded),
            tooltip: SubscriptionStrings.compareLink,
            onPressed: () =>
                context.pushNamed(AppRoutes.subscriptionComparison),
          ),
        ],
      ),
      body: SafeArea(
        child: _buildBody(context, state),
      ),
    );
  }

  Widget _buildBody(BuildContext context, SubscriptionState state) {
    if (state.status == SubscriptionLoadStatus.initial ||
        (state.status == SubscriptionLoadStatus.loading &&
            state.plans.isEmpty)) {
      return const SubscriptionLoadingState();
    }
    if (state.status == SubscriptionLoadStatus.error &&
        state.plans.isEmpty) {
      return SubscriptionErrorState(
        title: SubscriptionStrings.loadErrorTitle,
        message: state.errorMessage ?? SubscriptionStrings.loadErrorBody,
        onRetry: () =>
            ref.read(subscriptionControllerProvider.notifier).bootstrap(),
      );
    }
    if (state.plans.isEmpty) {
      return SubscriptionEmptyState(
        title: SubscriptionStrings.emptyTitle,
        subtitle: SubscriptionStrings.emptyBody,
      );
    }

    final SubscriptionEntity current =
        state.subscription ?? SubscriptionEntity.free();
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(subscriptionControllerProvider.notifier).refreshPlans(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: <Widget>[
              CurrentPlanBanner(
                subscription: current,
                onManage: () =>
                    context.pushNamed(AppRoutes.subscriptionRestore),
              ),
              const SizedBox(height: AppSpacing.lg),
              if (!current.isPremium)
                PremiumBanner(
                  onTap: () => _showPickHint(),
                ),
              const SizedBox(height: AppSpacing.lg),
              BillingCycleSelector(
                selected: _cycle,
                onChanged: (BillingCycle c) => setState(() => _cycle = c),
              ),
              const SizedBox(height: AppSpacing.md),
              ..._buildPlanCards(state, current),
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
                    RestoreButton(
                      onPressed: () =>
                          context.pushNamed(AppRoutes.subscriptionRestore),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              SubscriptionBenefitsCard(
                benefits: _topBenefits(state.plans),
              ),
              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPlanCards(
    SubscriptionState state,
    SubscriptionEntity current,
  ) {
    final List<SubscriptionPlanEntity> plans = state.plans
        .where((SubscriptionPlanEntity plan) =>
            _cycleFor(plan) == _cycle || plan.tier == SubscriptionTier.free)
        .toList(growable: false);
    if (plans.isEmpty) {
      return const <Widget>[];
    }
    return plans.map((SubscriptionPlanEntity plan) {
      final bool isCurrent = current.tier == plan.tier;
      final bool isProcessing =
          state.status == SubscriptionLoadStatus.purchasing &&
              current.tier != plan.tier;
      return Padding(
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: PlanCard(
          plan: plan,
          cycle: _cycle,
          onCycleChanged: (BillingCycle _) {},
          isCurrent: isCurrent,
          isProcessing: isProcessing,
          onChoose: () => _onPlanChosen(plan),
        ),
      );
    }).toList(growable: false);
  }

  List<SubscriptionFeatureEntity> _topBenefits(
    List<SubscriptionPlanEntity> plans,
  ) {
    if (plans.isEmpty) return const <SubscriptionFeatureEntity>[];
    final List<SubscriptionFeatureEntity> features = plans
        .firstWhere(
          (SubscriptionPlanEntity p) => p.tier == SubscriptionTier.yearly,
          orElse: () => plans.first,
        )
        .features;
    return features.take(6).toList(growable: false);
  }

  void _showPickHint() {
    AppSnackBar.showInfo(
      context,
      'Pick the plan that fits your prep rhythm.',
    );
  }
}

BillingCycle _cycleFor(SubscriptionPlanEntity plan) {
  switch (plan.tier) {
    case SubscriptionTier.monthly:
      return BillingCycle.monthly;
    case SubscriptionTier.quarterly:
      return BillingCycle.quarterly;
    case SubscriptionTier.yearly:
      return BillingCycle.yearly;
    case SubscriptionTier.free:
      return BillingCycle.monthly;
  }
}