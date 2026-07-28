import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../router.dart';
import '../../domain/entities/flashcard.dart';
import '../constants/ai_tutor_strings.dart';
import '../extensions/ai_tutor_extensions.dart';
import '../providers/ai_tutor_provider.dart';
import '../widgets/ai_hub_action_card.dart';
import '../widgets/ai_response_section.dart';
import '../widgets/flashcard_tile.dart';

/// Generates and displays a flashcard deck for a chosen topic.
class AiFlashcardsScreen extends ConsumerStatefulWidget {
  const AiFlashcardsScreen({super.key});

  @override
  ConsumerState<AiFlashcardsScreen> createState() =>
      _AiFlashcardsScreenState();
}

class _AiFlashcardsScreenState extends ConsumerState<AiFlashcardsScreen> {
  final TextEditingController _topic = TextEditingController(text: 'Tenses');
  int _count = 8;
  FlashcardDifficulty _difficulty = FlashcardDifficulty.medium;

  @override
  void dispose() {
    _topic.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AiContentState state =
        ref.watch(aiContentControllerProvider(AiContentKind.flashcards));

    return Scaffold(
      appBar: CustomAppBar(
        title: AiTutorStrings.flashcardsTitle,
        subtitle: AiTutorStrings.flashcardsFieldTopic,
        onLeadingPressed: () => context.canPop()
            ? context.pop()
            : context.goNamed(AppRoutes.aiTutor),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextField(
                    controller: _topic,
                    decoration: const InputDecoration(
                      labelText: AiTutorStrings.flashcardsFieldTopic,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _CountStepper(
                          value: _count,
                          onChanged: (int v) => setState(() => _count = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: DropdownButtonFormField<FlashcardDifficulty>(
                          initialValue: _difficulty,
                          decoration: const InputDecoration(
                            labelText:
                                AiTutorStrings.flashcardsFieldDifficulty,
                          ),
                          items: FlashcardDifficulty.values
                              .map(
                                (FlashcardDifficulty d) =>
                                    DropdownMenuItem<FlashcardDifficulty>(
                                  value: d,
                                  child: Text(d.label),
                                ),
                              )
                              .toList(),
                          onChanged: (FlashcardDifficulty? v) {
                            if (v != null) {
                              setState(() => _difficulty = v);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  FilledButton.icon(
                    onPressed: _generate,
                    icon: const Icon(Icons.auto_awesome),
                    label: const Text(AiTutorStrings.flashcardsGenerate),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: switch (state.status) {
                AiTutorLoadStatus.idle ||
                AiTutorLoadStatus.initial =>
                  Center(
                    child: AiTutorEmptyState(
                      title: AiTutorStrings.flashcardsEmptyTitle,
                      subtitle: AiTutorStrings.flashcardsEmptySubtitle,
                      icon: Icons.style_rounded,
                    ),
                  ),
                AiTutorLoadStatus.loading =>
                  const AiTutorResponseLoading(
                    message: AiTutorStrings.flashcardsLoading,
                  ),
                AiTutorLoadStatus.error => AiTutorResponseError(
                    message: state.errorMessage,
                    onRetry: _generate,
                  ),
                AiTutorLoadStatus.ready => _FlashcardList(
                    deck: state.flashcards!,
                    theme: theme,
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generate() async {
    final String topic = _topic.text.trim();
    if (topic.isEmpty) return;
    await ref
        .read(aiContentControllerProvider(AiContentKind.flashcards).notifier)
        .generateFlashcards(
          topic: topic,
          count: _count,
          difficulty: _difficulty,
        );
  }
}

class _FlashcardList extends StatelessWidget {
  const _FlashcardList({required this.deck, required this.theme});

  final FlashcardDeck deck;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: <Widget>[
        Text(
          deck.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          '${deck.cardCount} cards • ${deck.topic}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final Flashcard card in deck.cards)
          FlashcardTile(
            card: card,
            onShowAnswer: () {},
            onHideAnswer: () {},
          ),
      ],
    );
  }
}

class _CountStepper extends StatelessWidget {
  const _CountStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: value <= 4 ? null : () => onChanged(value - 2),
            icon: const Icon(Icons.remove_rounded),
            iconSize: 18,
          ),
          Expanded(
            child: Center(
              child: Text(
                '$value cards',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
          IconButton(
            onPressed: value >= 20 ? null : () => onChanged(value + 2),
            icon: const Icon(Icons.add_rounded),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}