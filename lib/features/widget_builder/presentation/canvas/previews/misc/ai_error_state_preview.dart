import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_action_button.dart';
import '../../../../../../core/widgets/ai/ai_button_variants.dart';
import '../../../../../../core/widgets/ai/ai_error_state.dart';
import '../../../providers/widget_builder_provider.dart';

class AiErrorStatePreview extends StatelessWidget {
  const AiErrorStatePreview({super.key, required this.provider});

  final WidgetBuilderProvider provider;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth < 480
            ? constraints.maxWidth
            : (constraints.maxWidth < 900 ? 600 : 720);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: width),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const _SectionLabel(text: 'Default error'),
                  AiErrorState(
                    title: 'Something Went Wrong',
                    subtitle: 'Unable to load AI content',
                    icon: Icons.error_outline_rounded,
                    description:
                        'An unexpected error occurred while communicating with the AI service. Please try again.',
                    primaryAction: AiActionButton(
                      text: 'Retry',
                      onPressed: _noop,
                      icon: Icons.refresh_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Cancel',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Network error — connection lost'),
                  AiErrorState(
                    title: 'No Internet Connection',
                    subtitle: 'You appear to be offline',
                    icon: Icons.wifi_off_rounded,
                    description:
                        'We could not reach the AI service. Check your network connection and try again.',
                    errorCode: 'NETWORK_503',
                    retryAttempts: 3,
                    primaryAction: AiActionButton(
                      text: 'Retry',
                      onPressed: _noop,
                      icon: Icons.refresh_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Go Offline',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Server error — service unavailable',
                  ),
                  AiErrorState(
                    title: 'AI Service Unavailable',
                    subtitle: 'Our servers are having a bad day',
                    icon: Icons.cloud_off_rounded,
                    description:
                        'The AI service is temporarily unreachable. Our team has been notified — please retry in a few minutes.',
                    errorCode: 'SERVER_500',
                    primaryAction: AiActionButton(
                      text: 'Try Again',
                      onPressed: _noop,
                      icon: Icons.refresh_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Contact Support',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Permission error — access denied'),
                  AiErrorState(
                    title: 'Access Denied',
                    subtitle: 'This feature is restricted',
                    icon: Icons.lock_outline_rounded,
                    description:
                        'Your account does not have permission to use this AI feature. Upgrade your subscription or contact your administrator to request access.',
                    errorCode: 'AUTH_403',
                    primaryAction: AiActionButton(
                      text: 'Upgrade Plan',
                      onPressed: _noop,
                      icon: Icons.workspace_premium_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Back',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Rate limit — too many requests'),
                  AiErrorState(
                    title: 'Slow Down',
                    subtitle: 'You are sending requests too quickly',
                    icon: Icons.hourglass_disabled_rounded,
                    description:
                        'You have hit the AI usage limit for this minute. Wait a moment before sending another request.',
                    errorCode: 'RATE_429',
                    retryAttempts: 1,
                    primaryAction: AiActionButton(
                      text: 'Wait & Retry',
                      onPressed: _noop,
                      icon: Icons.timer_outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Background surface — card variant',
                  ),
                  AiErrorState(
                    title: 'Quiz generation failed',
                    subtitle: 'We could not build your mock exam',
                    icon: Icons.quiz_outlined,
                    description:
                        'PrepQuest AI ran into an issue while assembling your questions. Try generating again with a smaller topic list.',
                    backgroundColor: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(20),
                    primaryAction: AiActionButton(
                      text: 'Generate Again',
                      onPressed: _noop,
                      icon: Icons.auto_awesome_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Edit Topics',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Custom illustration — broken robot',
                  ),
                  AiErrorState(
                    title: 'AI Tutor is asleep',
                    subtitle: 'Waking the model takes a moment',
                    icon: Icons.psychology_alt_rounded,
                    illustration: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFFF43F5E),
                            Color(0xFFE11D48),
                            Color(0xFFB91C1C),
                          ],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(
                              0xFFF43F5E,
                            ).withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.precision_manufacturing_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    description:
                        'The model is reloading. This usually takes less than a minute — your chat history is preserved.',
                    errorCode: 'MODEL_001',
                    primaryAction: AiActionButton(
                      text: 'Wake AI',
                      onPressed: _noop,
                      icon: Icons.power_settings_new_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Cancel',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Header + footer slots'),
                  AiErrorState(
                    title: 'Subscription Expired',
                    subtitle: 'Renew to restore AI access',
                    icon: Icons.workspace_premium_outlined,
                    description:
                        'Your premium subscription has lapsed. AI features are paused until you renew — your study progress and history remain safe.',
                    header: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF43F5E).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'ACTION REQUIRED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                    footer: TextButton(
                      onPressed: _noop,
                      child: const Text('Read billing FAQ'),
                    ),
                    primaryAction: AiActionButton(
                      text: 'Renew Now',
                      onPressed: _noop,
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Alignment — start'),
                  const AiErrorState(
                    title: 'Inline error panel',
                    subtitle: 'Left-aligned for side rails',
                    icon: Icons.info_outline_rounded,
                    alignment: AiErrorStateAlignment.start,
                    description:
                        'When the error state lives inside a settings row or narrow panel, a left-aligned layout reads better than a centred one.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Column action layout — mobile'),
                  AiErrorState(
                    title: 'Sync failed',
                    subtitle: 'Your data did not reach the cloud',
                    icon: Icons.cloud_sync_rounded,
                    description:
                        'We could not sync your AI history, prompts, and bookmarks. Reconnect to retry the sync, or continue offline.',
                    actionLayout: AiErrorStateActionLayout.column,
                    primaryAction: AiActionButton(
                      text: 'Retry Sync',
                      onPressed: _noop,
                      icon: Icons.sync_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Continue Offline',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom accent — amber'),
                  AiErrorState(
                    title: 'Quota Exceeded',
                    subtitle: 'You have used your monthly AI credits',
                    icon: Icons.warning_amber_rounded,
                    accentColor: const Color(0xFFF59E0B),
                    description:
                        'You have used all of your AI credits for this billing cycle. Upgrade to a higher tier or wait until next month to continue.',
                    primaryAction: AiActionButton(
                      text: 'Upgrade',
                      onPressed: _noop,
                      icon: Icons.arrow_forward_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'View Usage',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Animation — none (reduced motion)',
                  ),
                  const AiErrorState(
                    title: 'Static error state',
                    subtitle: 'No entrance animation',
                    icon: Icons.notifications_off_outlined,
                    description:
                        'Honours the system reduced-motion setting and renders without any transition.',
                    animation: AiErrorStateAnimation.none,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Dark theme surface'),
                  AiErrorState(
                    title: 'Dark theme friendly',
                    subtitle: 'Rendered on a dark surface',
                    icon: Icons.dark_mode_outlined,
                    description:
                        'Every colour resolves from the active theme — the error state looks at home in either light or dark mode.',
                    backgroundColor: const Color(0xFF15171F),
                    primaryAction: AiActionButton(
                      text: 'Got it',
                      onPressed: _noop,
                      icon: Icons.check_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

void _noop() {}
