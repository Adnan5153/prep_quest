import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_response_card.dart';
import '../../../providers/widget_builder_provider.dart';

class AiResponseCardPreview extends StatelessWidget {
  const AiResponseCardPreview({super.key, required this.provider});

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
                  const _SectionLabel(text: 'Controlled via palette'),
                  _buildControlled(),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Standard AI response'),
                  const AiResponseCard(
                    title: 'AI Tutor',
                    subtitle: 'Your personalised explanation is ready',
                    body:
                        'Newton’s second law states that the acceleration of an object is directly proportional to the net force acting on it and inversely proportional to its mass. In equation form: F = m × a.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Long AI explanation'),
                  const AiResponseCard(
                    title: 'Concept Walkthrough',
                    subtitle: 'Big-O notation demystified',
                    body:
                        'Big-O notation describes the upper bound of an algorithm’s running time as the input size grows. **O(1)** means constant time — the operation takes the same number of steps regardless of input size. **O(log n)** describes algorithms that halve the problem space with each step, like binary search. **O(n)** is linear — each additional input element adds one more step. **O(n log n)** describes efficient sorting algorithms such as merge sort. Finally, **O(n²)** describes algorithms with nested loops over the input, which become slow quickly.\n\nWhen evaluating performance, remember that constants and lower-order terms are dropped — an algorithm that runs in 5n² + 3n + 7 steps is still classified as O(n²).',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI summary'),
                  AiResponseCard(
                    title: 'Session Summary',
                    subtitle: 'Last 5 minutes of your study session',
                    responseType: AiResponseType.summary,
                    body:
                        'You covered 3 key topics: photosynthesis, cellular respiration, and enzyme kinetics. Accuracy on practice questions improved from 62% to 84%. One concept to revisit: competitive vs non-competitive inhibition.',
                    metadata: AiResponseMetadata(
                      model: 'GPT-4o',
                      timestamp: '5 min ago',
                      category: 'Biology',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI hint'),
                  AiResponseCard(
                    title: 'Hint',
                    subtitle: 'Stuck on the practice question?',
                    responseType: AiResponseType.hint,
                    body:
                        'Try eliminating the two most obviously wrong options first. This narrows the choice and raises your chance of picking the right answer to 50%, even before you read carefully.',
                    metadata: AiResponseMetadata(
                      model: 'Tutor v3',
                      timestamp: 'just now',
                      confidence: AiResponseConfidence.medium,
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onRegenerate: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI recommendation'),
                  AiResponseCard(
                    title: 'Recommended Next Topic',
                    subtitle: 'Based on your recent performance',
                    responseType: AiResponseType.recommendation,
                    body:
                        'Spend 20 minutes on "Two-pointer techniques" before moving to dynamic programming. It is the natural next step and your past attempts show strong foundational knowledge.',
                    metadata: AiResponseMetadata(
                      model: 'Adaptive Engine',
                      timestamp: '2 min ago',
                      category: 'Algorithms',
                      confidence: AiResponseConfidence.high,
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onLike: _noop,
                      onDislike: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI analysis'),
                  AiResponseCard(
                    title: 'Performance Analysis',
                    subtitle: 'Last 7 days',
                    responseType: AiResponseType.analysis,
                    body:
                        'Your strongest subject is organic chemistry (92% accuracy) and your weakest is electromagnetism (61%). Study time is well-distributed but tends to drop on weekends. Suggestion: schedule a 30-minute weekend block for physics to maintain momentum.',
                    metadata: AiResponseMetadata(
                      model: 'Insights v2',
                      timestamp: '1 hour ago',
                      category: 'Performance',
                      status: AiResponseStatus.delivered,
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onRegenerate: _noop,
                      onFavorite: _noop,
                      isFavorite: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'AI response with markdown enabled',
                  ),
                  const AiResponseCard(
                    title: 'Quick Reference',
                    subtitle: 'Markdown formatting is supported',
                    markdown: true,
                    body:
                        '# Quadratic formula\n\n'
                        'For any quadratic equation of the form **ax² + bx + c = 0**, the roots are given by:\n\n'
                        '`x = (-b ± √(b² - 4ac)) / 2a`\n\n'
                        '*Note:* The discriminant `b² - 4ac` determines the nature of the roots:\n'
                        '- Positive → two real roots\n'
                        '- Zero → one repeated real root\n'
                        '- Negative → two complex roots',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with selectable text'),
                  const AiResponseCard(
                    title: 'Definition',
                    subtitle: 'Long-press to copy any portion',
                    selectable: true,
                    body:
                        'Mitosis is the process of cell division in which a single parent cell divides to produce two genetically identical daughter cells, each containing the same number of chromosomes as the parent. The phases of mitosis are prophase, metaphase, anaphase, and telophase, followed by cytokinesis.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'AI response with feedback actions',
                  ),
                  AiResponseCard(
                    title: 'Did this help?',
                    subtitle: 'Your feedback improves future responses',
                    body:
                        'Try reviewing the concept map under "Cellular Respiration" before moving to the next module.',
                    metadata: const AiResponseMetadata(
                      model: 'Tutor v3',
                      timestamp: 'just now',
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onRegenerate: _noop,
                      onLike: _noop,
                      onDislike: _noop,
                      isLiked: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with copy button'),
                  AiResponseCard(
                    title: 'Glossary Entry',
                    subtitle: 'Copy this definition to your notes',
                    body:
                        'Photosynthesis: the biochemical process by which green plants, algae, and some bacteria convert light energy into chemical energy stored in glucose, using carbon dioxide and water as raw materials.',
                    actions: AiResponseActions(onCopy: _noop),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with share button'),
                  AiResponseCard(
                    title: 'Shareable insight',
                    subtitle: 'Send to your study group',
                    body:
                        'Spaced repetition is most effective when review intervals expand by a factor of 2-3x after each successful recall. Aim for the following pattern: 1 day, 3 days, 7 days, 21 days.',
                    actions: AiResponseActions(onShare: _noop),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'AI response with regenerate button',
                  ),
                  AiResponseCard(
                    title: 'First attempt',
                    subtitle: 'Tap regenerate for an alternative',
                    body:
                        'The mitochondrion is often called the powerhouse of the cell because it generates most of the cell’s supply of adenosine triphosphate (ATP), used as a source of chemical energy.',
                    actions: AiResponseActions(onRegenerate: _noop),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with favorite button'),
                  AiResponseCard(
                    title: 'Saved for review',
                    subtitle: 'Tap to remove from your saved list',
                    body:
                        'A reflex arc is the neural pathway that controls a reflex action. It involves a receptor, sensory neuron, interneuron, motor neuron, and effector — typically completing in under a millisecond.',
                    actions: AiResponseActions(
                      onFavorite: _noop,
                      isFavorite: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with full metadata'),
                  AiResponseCard(
                    title: 'Comprehensive Response',
                    subtitle: 'All metadata fields populated',
                    body:
                        'The Bohr model of the atom describes electrons orbiting the nucleus in fixed energy levels. Electrons can jump between levels by absorbing or emitting photons of specific energies.',
                    metadata: const AiResponseMetadata(
                      model: 'Claude Sonnet 4.5',
                      timestamp: '2 min ago',
                      category: 'Physics',
                      confidence: AiResponseConfidence.high,
                      status: AiResponseStatus.delivered,
                      extra: 'Tokens: 142',
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onRegenerate: _noop,
                      onFavorite: _noop,
                      onLike: _noop,
                      onDislike: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'AI response with confidence indicator',
                  ),
                  AiResponseCard(
                    title: 'High confidence answer',
                    subtitle: 'Verified against standard references',
                    body:
                        'Water boils at 100 °C at standard atmospheric pressure (1 atm or 101.325 kPa). At higher altitudes, the boiling point decreases because atmospheric pressure is lower.',
                    metadata: const AiResponseMetadata(
                      confidence: AiResponseConfidence.high,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with category chip'),
                  AiResponseCard(
                    title: 'Mathematics',
                    subtitle: 'Algebra refresher',
                    body:
                        'To solve a linear equation, isolate the variable by applying inverse operations to both sides of the equation until the variable stands alone.',
                    metadata: const AiResponseMetadata(category: 'Mathematics'),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'AI response with custom footer'),
                  AiResponseCard(
                    title: 'Premium insight',
                    subtitle: 'Available to Pro subscribers',
                    body:
                        'Stochastic gradient descent is the optimisation algorithm that powers most modern machine learning. Instead of using the entire dataset to compute the gradient, it uses a single randomly selected example per iteration, which makes each step cheap and noisy but converges in expectation.',
                    metadata: const AiResponseMetadata(
                      model: 'Pro Engine',
                      timestamp: 'just now',
                      category: 'Machine Learning',
                      confidence: AiResponseConfidence.high,
                    ),
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onRegenerate: _noop,
                      onFavorite: _noop,
                      isFavorite: true,
                      onLike: _noop,
                      isLiked: true,
                      onDislike: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'Expandable — long body with collapsed state',
                  ),
                  AiResponseCard(
                    title: 'Detailed walkthrough',
                    subtitle: 'Tap expand to read the full explanation',
                    body:
                        'A linked list is a linear data structure in which elements are stored in nodes, and each node points to the next node in the sequence. Unlike arrays, linked lists do not require contiguous memory allocation, which makes insertion and deletion at arbitrary positions efficient — at the cost of constant-time random access.\n\n'
                        'There are three common variants: singly linked lists, where each node points only to the next; doubly linked lists, where each node points to both the next and the previous; and circular linked lists, where the last node points back to the first, forming a cycle.\n\n'
                        'Linked lists are the foundation for more advanced structures such as stacks, queues, hash table chains, and adjacency-list representations of graphs.',
                    canExpand: true,
                    expanded: false,
                    collapsedMaxLines: 3,
                    actions: AiResponseActions(
                      onExpandToggle: _noop,
                      canExpand: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Header-only — minimal preview'),
                  const AiResponseCard(
                    title: 'Quick answer',
                    body: 'Yes — the answer is 42.',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(text: 'Custom accent colour'),
                  AiResponseCard(
                    title: 'Premium tier',
                    subtitle: 'Gold-accented variant',
                    accentColor: const Color(0xFFF59E0B),
                    body:
                        'You have unlocked the Premium tier. All AI features are now available, including deep analysis, unlimited regenerations, and priority response times.',
                    badgeLabel: 'PRO',
                    actions: AiResponseActions(
                      onCopy: _noop,
                      onFavorite: _noop,
                      isFavorite: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _SectionLabel(
                    text: 'No badge, no metadata, no footer — pure body',
                  ),
                  const AiResponseCard(
                    title: 'Bare card',
                    showBadge: false,
                    body:
                        'This card has no badge, no metadata, and no footer — the simplest possible expression of the response card primitive.',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlled() {
    return AiResponseCard(
      title: provider.aiResponseTitle,
      subtitle: provider.aiResponseSubtitle,
      responseType: _parseType(provider.aiResponseType),
      badgeLabel: provider.aiResponseBadgeLabel.isEmpty
          ? null
          : provider.aiResponseBadgeLabel,
      body: provider.aiResponseBody,
      markdown: provider.aiResponseMarkdown,
      selectable: provider.aiResponseSelectable,
      showBadge: provider.aiResponseShowBadge,
      metadata: provider.aiResponseShowMetadata
          ? AiResponseMetadata(
              model: provider.aiResponseMetadataModel,
              timestamp: provider.aiResponseMetadataTimestamp,
              category: provider.aiResponseMetadataCategory,
              confidence: _parseConfidence(
                provider.aiResponseMetadataConfidence,
              ),
              status: _parseStatus(provider.aiResponseMetadataStatus),
            )
          : null,
      canExpand: provider.aiResponseCanExpand,
      expanded: provider.aiResponseExpanded,
      actions: provider.aiResponseShowActions
          ? AiResponseActions(
              onCopy: provider.aiResponseActionCopy ? _noop : null,
              onShare: provider.aiResponseActionShare ? _noop : null,
              onRegenerate: provider.aiResponseActionRegenerate ? _noop : null,
              onFavorite: provider.aiResponseActionFavorite ? _noop : null,
              onLike: provider.aiResponseActionLike ? _noop : null,
              onDislike: provider.aiResponseActionDislike ? _noop : null,
              isFavorite: provider.aiResponseActionFavoriteActive,
              isLiked: provider.aiResponseActionLikeActive,
              isDisliked: provider.aiResponseActionDislikeActive,
              canExpand: provider.aiResponseCanExpand,
              onExpandToggle: _noop,
            )
          : null,
    );
  }

  AiResponseType _parseType(String value) {
    return AiResponseType.values.firstWhere(
      (AiResponseType t) => t.name == value,
      orElse: () => AiResponseType.generic,
    );
  }

  AiResponseConfidence _parseConfidence(String value) {
    return AiResponseConfidence.values.firstWhere(
      (AiResponseConfidence c) => c.name == value,
      orElse: () => AiResponseConfidence.unknown,
    );
  }

  AiResponseStatus _parseStatus(String value) {
    return AiResponseStatus.values.firstWhere(
      (AiResponseStatus s) => s.name == value,
      orElse: () => AiResponseStatus.delivered,
    );
  }

  void _noop() {}
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
