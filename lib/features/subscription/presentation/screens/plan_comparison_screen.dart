import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/responsive_builder.dart';
import '../../../../router.dart';
import '../../domain/entities/subscription_entity.dart';
import '../constants/subscription_strings.dart';
import '../providers/subscription_provider.dart';
import '../widgets/comparison_table/comparison_table.dart';
import '../widgets/error_state/error_state.dart';
import '../widgets/loading_state/loading_state.dart';

/// Plan Comparison screen. Renders the side-by-side feature table
/// derived from the full catalogue of [SubscriptionFeatureEntity].
class PlanComparisonScreen extends ConsumerStatefulWidget {
  const PlanComparisonScreen({super.key});

  @override
  ConsumerState<PlanComparisonScreen> createState() =>
      _PlanComparisonScreenState();
}

class _PlanComparisonScreenState
    extends ConsumerState<PlanComparisonScreen> {
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

  @override
  Widget build(BuildContext context) {
    final SubscriptionState state =
        ref.watch(subscriptionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(SubscriptionStrings.compareScreenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.canPop()
              ? context.pop()
              : context.goNamed(AppRoutes.subscriptionPlans),
        ),
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
      return const SubscriptionLoadingState(
        title: 'Loading comparison…',
        subtitle: 'Crunching the feature catalog.',
      );
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
    final List<SubscriptionFeatureEntity> features =
        _uniqueFeatures(state.plans);
    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: <Widget>[
            Text(
              SubscriptionStrings.compareScreenTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              SubscriptionStrings.compareScreenSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ComparisonTable(features: features),
          ],
        ),
      ),
    );
  }

  List<SubscriptionFeatureEntity> _uniqueFeatures(
    List<SubscriptionPlanEntity> plans,
  ) {
    final Map<String, SubscriptionFeatureEntity> byId =
        <String, SubscriptionFeatureEntity>{};
    for (final SubscriptionPlanEntity plan in plans) {
      for (final SubscriptionFeatureEntity feature in plan.features) {
        byId[feature.id] = feature;
      }
    }
    return byId.values.toList(growable: false);
  }
}