import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_history_section/ai_history_enums.dart';
import '../../../../../../core/widgets/ai/ai_history_tile.dart';
import '../../../providers/widget_builder_provider.dart';

class AiHistoryTilePreview extends StatelessWidget {
  const AiHistoryTilePreview({super.key, required this.provider});

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
                  _SectionLabel(text: 'Configured via controls'),
                  _buildControlled(context),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionLabel(text: 'Entry type — Tutor'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.tutor,
                      id: 'demo-tutor',
                      title: 'B-Tree insertions',
                      preview:
                          'A B-Tree of minimum degree `t=2` maintains sorted data and supports search, insert, and delete in logarithmic time.',
                      timestamp: '2 min ago',
                      subtitle: 'Data Structures',
                      category: 'Tutor',
                      isPinned: true,
                      isFavorite: true,
                      isUnread: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Entry type — Prompt'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.prompt,
                      id: 'demo-prompt',
                      title: 'Explain gradient descent in Bangla',
                      preview:
                          'একটি ছোট উদাহরণের মাধ্যমে প্রতিটি ধাপ ব্যাখ্যা করো এবং শেষে একটি সারসংক্ষেপ দাও।',
                      timestamp: '10 min ago',
                      subtitle: 'Bangla',
                      category: 'Prompt',
                      isPremium: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Entry type — Exam'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.exam,
                      id: 'demo-exam',
                      title: 'BCS Mock Test 14 — Analytics',
                      preview:
                          'You scored 18/25. Focus on International Affairs and General Science for the next attempt.',
                      timestamp: 'Yesterday',
                      subtitle: 'Mock Test',
                      category: 'Exam',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Entry type — Summary'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.summary,
                      id: 'demo-summary',
                      title: 'Lecture summary — Constitution',
                      preview:
                          'A concise recap covering Articles of Association, fundamental rights, and amendment procedures.',
                      timestamp: '2 days ago',
                      subtitle: 'Summary',
                      category: 'Summary',
                      isFavorite: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _SectionLabel(text: 'Pinned only'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.tutor,
                      id: 'variant-pinned',
                      title: 'Binary heap invariants',
                      preview:
                          'A complete binary tree where every parent is greater than or equal to its children enables O(log n) extraction.',
                      timestamp: '5 min ago',
                      subtitle: 'Algorithms',
                      category: 'Algorithms',
                      isPinned: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Favorite only'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.summary,
                      id: 'variant-favorite',
                      title: 'Quick recap — Cell biology',
                      preview:
                          'Mitochondria are the powerhouse of the cell; ribosomes translate mRNA into polypeptide chains.',
                      timestamp: '3 hr ago',
                      subtitle: 'Biology',
                      category: 'Summary',
                      isFavorite: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Premium only'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.prompt,
                      id: 'variant-premium',
                      title: 'Advanced calculus walkthrough',
                      preview:
                          'Step-by-step derivation of the chain rule with worked examples and a short practice problem.',
                      timestamp: '1 hr ago',
                      subtitle: 'Premium',
                      category: 'Prompt',
                      isPremium: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Unread with bold title'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.tutor,
                      id: 'variant-unread',
                      title: 'Normalization in DBMS',
                      preview:
                          'Reduce redundancy by structuring tables so every non-key attribute depends on the key, the whole key, and nothing but the key.',
                      timestamp: 'Just now',
                      subtitle: 'Database',
                      category: 'Tutor',
                      isUnread: true,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Category hidden'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.tutor,
                      id: 'variant-no-category',
                      title: 'Big-O notation refresher',
                      preview:
                          'Drop constants and lower-order terms; keep only the term that grows fastest as n → ∞.',
                      timestamp: '12 min ago',
                      subtitle: 'Analysis',
                      category: 'Tutor',
                    ),
                    showCategory: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Timestamp hidden'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.prompt,
                      id: 'variant-no-timestamp',
                      title: 'Translate this paragraph to formal English',
                      preview:
                          'Restate the meaning with proper grammar, then output a single polished paragraph suitable for an editorial.',
                      timestamp: '20 min ago',
                      subtitle: 'Writing',
                      category: 'Prompt',
                    ),
                    showTimestamp: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Chevron hidden'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.summary,
                      id: 'variant-no-chevron',
                      title: 'Article 370 — historical context',
                      preview:
                          'Background on the special status of Jammu & Kashmir, the 2019 reorganisation, and the constitutional implications.',
                      timestamp: 'Yesterday',
                      subtitle: 'Civics',
                      category: 'Summary',
                    ),
                    showLeadingChevron: false,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Dense layout'),
                  AiHistoryTile(
                    entry: _fixture(
                      AiHistoryEntryType.tutor,
                      id: 'variant-dense',
                      title: 'Quick hint — pointer arithmetic',
                      preview:
                          'Pointer arithmetic scales by sizeof(T) automatically; never multiply by sizeof manually.',
                      timestamp: '4 min ago',
                      subtitle: 'C language',
                      category: 'Tutor',
                    ),
                    dense: true,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _SectionLabel(text: 'Minimal — only title + preview'),
                  AiHistoryTile(
                    entry: AiHistoryItem(
                      id: 'variant-minimal',
                      title: 'Plain entry',
                      preview:
                          'A bare tile with every optional indicator hidden.',
                      timestamp: '',
                    ),
                    showCategory: false,
                    showTimestamp: false,
                    showPinned: false,
                    showFavorite: false,
                    showPremiumBadge: false,
                    showLeadingChevron: false,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlled(BuildContext context) {
    final AiHistoryEntryType entryType = _resolveEntryType(
      provider.aiHistoryTileEntryType,
    );

    return AiHistoryTile(
      entry: AiHistoryItem(
        id: 'controlled',
        title: provider.aiHistoryTileTitle,
        preview: provider.aiHistoryTilePreview,
        timestamp: provider.aiHistoryTileTimestamp,
        subtitle: provider.aiHistoryTileSubtitle,
        category: provider.aiHistoryTileCategory,
        type: entryType,
        isFavorite: provider.aiHistoryTileIsFavorite,
        isPinned: provider.aiHistoryTileIsPinned,
        isPremium: provider.aiHistoryTileIsPremium,
        isUnread: provider.aiHistoryTileIsUnread,
      ),
      isDark: _resolveBrightness(provider.aiHistoryTileBrightness),
      showCategory: provider.aiHistoryTileShowCategory,
      showTimestamp: provider.aiHistoryTileShowTimestamp,
      showPremiumBadge: provider.aiHistoryTileShowPremiumBadge,
      showFavorite: provider.aiHistoryTileShowFavorite,
      showPinned: provider.aiHistoryTileShowPinned,
      showLeadingChevron: provider.aiHistoryTileShowLeadingChevron,
      dense: provider.aiHistoryTileDense,
    );
  }

  AiHistoryItem _fixture(
    AiHistoryEntryType type, {
    required String id,
    required String title,
    required String preview,
    required String timestamp,
    String? subtitle,
    String? category,
    bool isFavorite = false,
    bool isPinned = false,
    bool isPremium = false,
    bool isUnread = false,
  }) {
    return AiHistoryItem(
      id: id,
      title: title,
      preview: preview,
      timestamp: timestamp,
      subtitle: subtitle,
      category: category,
      type: type,
      isFavorite: isFavorite,
      isPinned: isPinned,
      isPremium: isPremium,
      isUnread: isUnread,
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

bool? _resolveBrightness(String value) {
  switch (value) {
    case 'light':
      return false;
    case 'dark':
      return true;
    default:
      return null;
  }
}

AiHistoryEntryType _resolveEntryType(String value) {
  for (final AiHistoryEntryType type in AiHistoryEntryType.values) {
    if (type.name == value) return type;
  }
  return AiHistoryEntryType.tutor;
}
