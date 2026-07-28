import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../constants/ai_tutor_strings.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/conversation_tile.dart';
import '../widgets/prompt_history_tile.dart';

/// Lists conversations + prompt history. Lets the user resume an old
/// conversation, delete it, or toggle a prompt's favorite status.
class AiHistoryScreen extends ConsumerStatefulWidget {
  const AiHistoryScreen({super.key});

  @override
  ConsumerState<AiHistoryScreen> createState() => _AiHistoryScreenState();
}

class _AiHistoryScreenState extends ConsumerState<AiHistoryScreen> {
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
    final AiHistoryState state = ref.watch(aiHistoryControllerProvider);
    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.historyTitle,
        subtitle: AiTutorStrings.historySubtitle,
        onLeadingPressed: () => context.canPop()
            ? context.pop()
            : context.goNamed(AppRoutes.aiTutor),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(aiHistoryControllerProvider.notifier).load();
          },
          child: switch (state.status) {
            AiTutorLoadStatus.initial ||
            AiTutorLoadStatus.idle ||
            AiTutorLoadStatus.loading =>
              const Center(child: CircularProgressIndicator()),
            AiTutorLoadStatus.error => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.error_outline,
                          size: 48, color: theme.colorScheme.error),
                      const SizedBox(height: AppSpacing.md),
                      Text(state.errorMessage ??
                          'Could not load history.'),
                      const SizedBox(height: AppSpacing.md),
                      FilledButton(
                        onPressed: () => ref
                            .read(aiHistoryControllerProvider.notifier)
                            .load(),
                        child: const Text(AiTutorStrings.retry),
                      ),
                    ],
                  ),
                ),
              ),
            AiTutorLoadStatus.ready => ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                children: <Widget>[
                  Text(
                    AiTutorStrings.historySubtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () =>
                              context.goNamed(AppRoutes.aiTutorChat),
                          icon: const Icon(Icons.add),
                          label: const Text('New conversation'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AiTutorStrings.sectionRecentSessions,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.conversations.isEmpty)
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
                    for (final convo in state.conversations)
                      AiTutorConversationTile(
                        conversation: convo,
                        onTap: () => context.goNamed(
                          AppRoutes.aiTutorChat,
                          queryParameters: <String, String>{
                            'conversationId': convo.id,
                          },
                        ),
                        onDelete: () => _confirmDelete(convo.id),
                      ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    AiTutorStrings.historyPromptsTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (state.prompts.isEmpty)
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
                        'No prompts yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  else
                    for (final entry in state.prompts)
                      AiTutorPromptHistoryTile(
                        entry: entry,
                        onFavoriteToggle: (bool _) => ref
                            .read(aiHistoryControllerProvider.notifier)
                            .toggleFavorite(entry.id),
                      ),
                ],
              ),
          },
        ),
      ),
    );
  }

  Future<void> _confirmDelete(String id) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(AiTutorStrings.deleteConfirmTitle),
          content: const Text(AiTutorStrings.deleteConfirmMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(AiTutorStrings.dismiss),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(AiTutorStrings.delete),
            ),
          ],
        );
      },
    );
    if (confirmed == true) {
      await ref
          .read(aiHistoryControllerProvider.notifier)
          .deleteConversation(id);
    }
  }
}