import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_action_button.dart';
import '../../../../../../core/widgets/ai/ai_button_variants.dart';
import '../../../../../../core/widgets/ai/ai_empty_state.dart';
import '../../../providers/widget_builder_provider.dart';

class AiEmptyStatePreview extends StatelessWidget {
  const AiEmptyStatePreview({super.key, required this.provider});

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
                  const _SectionLabel(text: 'Default empty state'),
                  const AiEmptyState(
                    title: 'No AI History Yet',
                    subtitle: 'Your conversations will appear here.',
                    description:
                        'Start chatting with PrepQuest AI to receive explanations, summaries, recommendations, and personalized learning assistance.',
                    icon: Icons.history_rounded,
                    primaryAction: AiActionButton(
                      text: 'Start Chat',
                      onPressed: _noop,
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Learn More',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Icon only — minimal preview'),
                  const AiEmptyState(
                    title: 'Nothing to show',
                    icon: Icons.inbox_outlined,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Illustration slot — custom widget',
                  ),
                  AiEmptyState(
                    title: 'AI Insights coming soon',
                    subtitle: 'We are training your personalised model',
                    illustration: Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                            Color(0xFF06B6D4),
                          ],
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(
                              0xFF6366F1,
                            ).withValues(alpha: 0.4),
                            blurRadius: 24,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                        size: 48,
                      ),
                    ),
                    description:
                        'Once enough data is gathered, you will see deep insights about your learning patterns here.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Primary action only'),
                  AiEmptyState(
                    title: 'No saved prompts',
                    icon: Icons.bookmark_border_rounded,
                    description:
                        'Save useful prompts to revisit them from any device.',
                    primaryAction: AiActionButton(
                      text: 'Browse Prompt Library',
                      onPressed: _noop,
                      icon: Icons.collections_bookmark_outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Primary + secondary actions'),
                  AiEmptyState(
                    title: 'No exam scheduled',
                    subtitle: 'Generate a personalised mock exam',
                    icon: Icons.assignment_outlined,
                    description:
                        'Pick a subject, difficulty, and time limit — the AI will assemble a 50-question mock exam tailored to your weak areas.',
                    primaryAction: AiActionButton(
                      text: 'Generate Exam',
                      onPressed: _noop,
                      icon: Icons.auto_awesome_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Browse Past Exams',
                      onPressed: _noop,
                      variant: AiButtonVariant.outlined,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Column action layout — mobile'),
                  AiEmptyState(
                    title: 'Connect your account',
                    subtitle: 'Sync history across devices',
                    icon: Icons.cloud_off_outlined,
                    description:
                        'You are currently offline. Reconnect to keep your AI history, prompts, and bookmarks synchronised.',
                    actionLayout: AiEmptyStateActionLayout.column,
                    primaryAction: AiActionButton(
                      text: 'Reconnect',
                      onPressed: _noop,
                      icon: Icons.refresh_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Continue Offline',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Background surface — card variant',
                  ),
                  AiEmptyState(
                    title: 'No recommendations yet',
                    subtitle: 'Complete 5 practice sessions to unlock them',
                    icon: Icons.recommend_rounded,
                    description:
                        'PrepQuest AI analyses your performance to surface topics that will have the highest impact on your score.',
                    backgroundColor: const Color(0xFFF6F7FB),
                    borderRadius: BorderRadius.circular(20),
                    primaryAction: AiActionButton(
                      text: 'Start Practice',
                      onPressed: _noop,
                      icon: Icons.play_arrow_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Dismiss',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Custom child slot — quick prompts',
                  ),
                  AiEmptyState(
                    title: 'How can AI Tutor help you today?',
                    subtitle: 'Pick a starter prompt or write your own',
                    icon: Icons.psychology_rounded,
                    customChild: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        _SuggestionChip(label: 'Explain photosynthesis'),
                        _SuggestionChip(label: 'Quiz me on calculus'),
                        _SuggestionChip(label: 'Summarise today’s class'),
                        _SuggestionChip(label: 'Find my weak topics'),
                      ],
                    ),
                    primaryAction: AiActionButton(
                      text: 'Open Chat',
                      onPressed: _noop,
                      icon: Icons.chat_bubble_outline_rounded,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Header + footer slots'),
                  AiEmptyState(
                    title: 'No chat history',
                    subtitle: 'This is your first conversation',
                    icon: Icons.forum_outlined,
                    description:
                        'Ask anything about your BCS preparation — the AI tutor will answer with explanations, examples, and practice questions.',
                    header: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'BETA • NEW',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.6,
                          color: Color(0xFF4F46E5),
                        ),
                      ),
                    ),
                    footer: TextButton(
                      onPressed: _noop,
                      child: const Text('Read our privacy policy'),
                    ),
                    primaryAction: AiActionButton(
                      text: 'Start Chatting',
                      onPressed: _noop,
                      icon: Icons.arrow_forward_rounded,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Alignment — start'),
                  const AiEmptyState(
                    title: 'Left-aligned empty state',
                    subtitle: 'Useful for inline panels',
                    icon: Icons.info_outline_rounded,
                    alignment: AiEmptyStateAlignment.start,
                    description:
                        'When the empty state lives in a side panel or settings row, a left-aligned layout reads better than a centred one.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom accent — gold'),
                  AiEmptyState(
                    title: 'Premium feature locked',
                    subtitle: 'Upgrade to unlock this section',
                    icon: Icons.workspace_premium_rounded,
                    accentColor: const Color(0xFFF59E0B),
                    description:
                        'This is a Pro-tier feature. Upgrade your subscription to unlock AI-powered recommendations, advanced analytics, and unlimited regenerations.',
                    primaryAction: AiActionButton(
                      text: 'Upgrade',
                      onPressed: _noop,
                      icon: Icons.arrow_forward_rounded,
                    ),
                    secondaryAction: AiActionButton(
                      text: 'Maybe Later',
                      onPressed: _noop,
                      variant: AiButtonVariant.minimal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Animation — none (reduced motion)',
                  ),
                  const AiEmptyState(
                    title: 'Static empty state',
                    subtitle: 'No entrance animation',
                    icon: Icons.notifications_off_outlined,
                    description:
                        'Honours the system reduced-motion setting and renders without any transition.',
                    animation: AiEmptyStateAnimation.none,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Dark theme surface'),
                  AiEmptyState(
                    title: 'Dark theme friendly',
                    subtitle: 'Rendered on a dark surface',
                    icon: Icons.dark_mode_outlined,
                    description:
                        'Every colour resolves from the active theme — the empty state looks at home in either light or dark mode.',
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

class _SuggestionChip extends StatelessWidget {
  const _SuggestionChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ActionChip(
      label: Text(label),
      onPressed: _noop,
      backgroundColor: theme.colorScheme.primaryContainer.withValues(
        alpha: 0.4,
      ),
      side: BorderSide(color: theme.colorScheme.primary.withValues(alpha: 0.2)),
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
