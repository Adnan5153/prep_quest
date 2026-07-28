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
import '../widgets/purchase_button/purchase_button.dart';
import '../widgets/purchase_success_dialog/purchase_success_dialog.dart';
import '../widgets/payment_status_indicator/payment_status_indicator.dart';

/// Purchase Flow screen. Receives `planId` + `providerCode` via
/// `GoRouterState.extra`, walks the user through the confirmation
/// screen and routes the success/failure outcome to the right dialog.
class PurchaseFlowScreen extends ConsumerStatefulWidget {
  const PurchaseFlowScreen({super.key, this.planId, this.providerCode});

  final String? planId;
  final String? providerCode;

  @override
  ConsumerState<PurchaseFlowScreen> createState() =>
      _PurchaseFlowScreenState();
}

class _PurchaseFlowScreenState extends ConsumerState<PurchaseFlowScreen> {
  PaymentStatus _status = PaymentStatus.idle;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final SubscriptionState state =
          ref.read(subscriptionControllerProvider);
      if (state.plans.isEmpty) {
        ref.read(subscriptionControllerProvider.notifier).bootstrap();
      }
    });
  }

  Future<void> _confirmPurchase(SubscriptionPlanEntity plan) async {
    setState(() => _status = PaymentStatus.processing);
    try {
      final PurchaseEntity result =
          await ref.read(subscriptionControllerProvider.notifier).purchase(
                planId: plan.id,
                providerCode: widget.providerCode ??
                    (plan.paymentProviderCodes.isNotEmpty
                        ? plan.paymentProviderCodes.first
                        : 'play:billing:unknown'),
              );
      if (!mounted) return;
      if (result.status.isSuccess) {
        setState(() => _status = PaymentStatus.success);
        await PurchaseSuccessDialog.show(
          context,
          title: SubscriptionStrings.purchaseSuccessTitle,
          body: SubscriptionStrings.purchaseSuccessBody,
          onPrimary: () => _close(),
        );
      } else {
        setState(() => _status = PaymentStatus.failure);
        AppSnackBar.showError(
          context,
          '${SubscriptionStrings.purchaseFailedTitle}: '
              '${result.status.name}',
        );
      }
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _status = PaymentStatus.failure);
      AppSnackBar.showError(
        context,
        '${SubscriptionStrings.purchaseFailedBody} ($e)',
      );
    }
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.goNamed(AppRoutes.subscriptionPlans);
    }
  }

  @override
  Widget build(BuildContext context) {
    final SubscriptionState state =
        ref.watch(subscriptionControllerProvider);
    final SubscriptionPlanEntity? plan = _resolvePlan(state);

    final double maxWidth = ResponsiveBuilder.value<double>(
      context,
      mobile: double.infinity,
      tablet: AppSizes.tabletMaxWidth.toDouble(),
      desktop: AppSizes.desktopMaxWidth.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(SubscriptionStrings.purchaseTitle),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => _close(),
        ),
      ),
      body: SafeArea(
        child: plan == null
            ? Center(
                child: Text(
                  'Plan unavailable. Please return and pick again.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              )
            : Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: <Widget>[
                      Text(
                        SubscriptionStrings.purchaseTitle,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        SubscriptionStrings.purchaseSubtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      GlassCard(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        gradient: const LinearGradient(
                          colors: <Color>[
                            AppColors.accent,
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              plan.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              plan.tagline,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  plan.cycleLabel.split(' ').first,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                      ),
                                ),
                                const SizedBox(width: AppSpacing.xs),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    _cycleSuffix(plan),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.white
                                              .withValues(alpha: 0.9),
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      PaymentStatusIndicator(
                        status: _status,
                        message: _status == PaymentStatus.processing
                            ? SubscriptionStrings.processingPurchase
                            : null,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _TrustRow(),
                      const SizedBox(height: AppSpacing.lg),
                      PurchaseButton(
                        label: SubscriptionStrings.confirmPurchaseCta,
                        amountLabel: plan.cycleLabel.split(' ').first,
                        isProcessing:
                            _status == PaymentStatus.processing,
                        onPressed: () => _confirmPurchase(plan),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      TextButton(
                        onPressed: _close,
                        child: const Text(SubscriptionStrings.cancelCta),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  SubscriptionPlanEntity? _resolvePlan(SubscriptionState state) {
    if (widget.planId == null) return null;
    for (final SubscriptionPlanEntity plan in state.plans) {
      if (plan.id == widget.planId) return plan;
    }
    return null;
  }

  String _cycleSuffix(SubscriptionPlanEntity plan) {
    if (plan.billingCycleMonths == 12) return '/ year';
    if (plan.billingCycleMonths == 3) return '/ quarter';
    if (plan.billingCycleMonths == 1) return '/ month';
    return 'one-time';
  }
}

class _TrustRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Icon(
          Icons.shield_outlined,
          size: AppSizes.iconSm,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            'Payments are encrypted and processed by the gateway you '
            'chose. Prep Quest never stores your card.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}