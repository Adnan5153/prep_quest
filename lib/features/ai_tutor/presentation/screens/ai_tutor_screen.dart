import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../constants/ai_tutor_strings.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_hub_action_card.dart';
import '../widgets/conversation_tile.dart';

/// Hub screen for the AI Tutor feature. Shows quick actions and a
/// preview of recent conversations and prompts.
class AiTutorScreen extends ConsumerStatefulWidget {
  const AiTutorScreen({super.key});

  @override
  ConsumerState<AiTutorScreen> createState() => _AiTutorScreenState();
}

class _AiTutorScreenState extends ConsumerState<AiTutorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(aiHistoryControllerProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AiHistoryState history = ref.watch(aiHistoryControllerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.hubTitle,
        subtitle: AiTutorStrings.hubSubtitle,
        onLeadingPressed: () => context.goNamed(AppRoutes.playground),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(aiHistoryControllerProvider.notifier).load();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            children: <Widget>[
              Text(
                AiTutorStrings.hubSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(title: AiTutorStrings.sectionQuickActions),
              const SizedBox(height: AppSpacing.sm),
              _ActionsGrid(theme: theme),
              const SizedBox(height: AppSpacing.lg),
              _SectionHeader(
                title: AiTutorStrings.sectionRecentSessions,
                trailing: TextButton(
                  onPressed: () =>
                      context.goNamed(AppRoutes.aiTutorHistory),
                  child: const Text('See all'),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              if (history.status == AiTutorLoadStatus.loading)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (history.recentSessions.isEmpty)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    AiTutorStrings.historyEmptySubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                )
              else
                for (final convo in history.recentSessions.take(3))
                  AiTutorConversationTile(
                    conversation: convo,
                    onTap: () => context.goNamed(
                      AppRoutes.aiTutorChat,
                      queryParameters: <String, String>{
                        'conversationId': convo.id,
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}

class _ActionsGrid extends StatelessWidget {
  const _ActionsGrid({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final List<_ActionSpec> specs = <_ActionSpec>[
      _ActionSpec(
        title: AiTutorStrings.hubActionHint,
        subtitle: AiTutorStrings.hubActionHintSubtitle,
        icon: Icons.lightbulb_outline_rounded,
        accent: theme.colorScheme.primary,
        route: AppRoutes.aiTutorHint,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionExplain,
        subtitle: AiTutorStrings.hubActionExplainSubtitle,
        icon: Icons.menu_book_rounded,
        accent: theme.colorScheme.secondary,
        route: AppRoutes.aiTutorExplain,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionSimplify,
        subtitle: AiTutorStrings.hubActionSimplifySubtitle,
        icon: Icons.compress_rounded,
        accent: theme.colorScheme.tertiary,
        route: AppRoutes.aiTutorSimplify,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionSummary,
        subtitle: AiTutorStrings.hubActionSummarySubtitle,
        icon: Icons.summarize_rounded,
        accent: theme.colorScheme.primary,
        route: AppRoutes.aiTutorSummary,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionFlashcards,
        subtitle: AiTutorStrings.hubActionFlashcardsSubtitle,
        icon: Icons.style_rounded,
        accent: theme.colorScheme.secondary,
        route: AppRoutes.aiTutorFlashcards,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionStudyPlan,
        subtitle: AiTutorStrings.hubActionStudyPlanSubtitle,
        icon: Icons.event_note_rounded,
        accent: theme.colorScheme.tertiary,
        route: AppRoutes.aiTutorStudyPlan,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionQuestions,
        subtitle: AiTutorStrings.hubActionQuestionsSubtitle,
        icon: Icons.quiz_outlined,
        accent: theme.colorScheme.primary,
        route: AppRoutes.aiTutorQuestions,
      ),
      _ActionSpec(
        title: AiTutorStrings.hubActionChat,
        subtitle: AiTutorStrings.hubActionChatSubtitle,
        icon: Icons.chat_bubble_outline_rounded,
        accent: theme.colorScheme.secondary,
        route: AppRoutes.aiTutorChat,
      ),
    ];
    return Column(
      children: <Widget>[
        for (final _ActionSpec spec in specs)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: AiTutorHubActionCard(
              title: spec.title,
              subtitle: spec.subtitle,
              icon: spec.icon,
              accentColor: spec.accent,
              onTap: () => context.goNamed(spec.route),
            ),
          ),
      ],
    );
  }
}

class _ActionSpec {
  const _ActionSpec({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.route,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final String route;
}