import 'package:flutter/material.dart';

import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/widgets/ai/ai_summary_card.dart';
import '../../../providers/widget_builder_provider.dart';

class AiSummaryCardPreview extends StatelessWidget {
  const AiSummaryCardPreview({super.key, required this.provider});

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
                  const _SectionLabel(text: 'Default summary'),
                  AiSummaryCard(
                    title: 'Clean Architecture in Flutter',
                    subtitle: 'A practical overview of layered design',
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Flutter Clean Architecture separates presentation, '
                        'application, domain, repository, and data layers to '
                        'improve scalability, maintainability, testing, and '
                        'long-term project organization.',
                      ),
                    ],
                    category: 'Architecture',
                    model: 'PrepQuest AI',
                    timestamp: '2 minutes ago',
                    readingTime: '3 min read',
                    wordCount: '412 words',
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onBookmark: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Long summary — multi-section body',
                  ),
                  AiSummaryCard(
                    title: 'Newton\u2019s Laws of Motion',
                    subtitle: 'Classical mechanics fundamentals',
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Sir Isaac Newton published his three laws of motion '
                        'in 1687 in his work Philosophiæ Naturalis Principia '
                        'Mathematica. These laws form the foundation of '
                        'classical mechanics and remain essential to physics '
                        'education today.',
                      ),
                      const AiSummaryBulletListSection(<String>[
                        'First law: an object remains at rest or in uniform motion unless acted on by a force.',
                        'Second law: force equals mass times acceleration (F = m\u00B7a).',
                        'Third law: every action has an equal and opposite reaction.',
                      ]),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Inertia is a property of mass, not a force.',
                        'F = m\u00B7a only applies in inertial reference frames.',
                        'Action-reaction pairs act on different objects, never the same one.',
                      ]),
                    ],
                    category: 'Physics',
                    model: 'PrepQuest AI',
                    timestamp: 'Today 14:23',
                    readingTime: '5 min read',
                    wordCount: '687 words',
                    tags: <String>[
                      'Newton',
                      'Mechanics',
                      'Forces',
                      'Inertia',
                      'BCS',
                    ],
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onBookmark: _noop,
                      onLike: _noop,
                      onDislike: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Expandable summary — collapsed state',
                  ),
                  AiSummaryCard(
                    title: 'Big-O Notation Cheat Sheet',
                    subtitle: 'Time complexity reference',
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Big-O notation describes the upper bound of an '
                        'algorithm\u2019s running time as the input size '
                        'grows. It abstracts away constant factors and '
                        'machine-specific details so we can compare '
                        'algorithms at a high level.\n\n'
                        'A O(n) algorithm scales linearly with the input \u2014 '
                        'doubling the input doubles the work. A O(log n) '
                        'algorithm scales logarithmically \u2014 doubling the '
                        'input only adds one step of work. A O(n\u00B2) '
                        'algorithm scales quadratically \u2014 doubling the '
                        'input quadruples the work.',
                      ),
                      const AiSummaryBulletListSection(<String>[
                        'O(1) \u2014 constant time (hash lookup)',
                        'O(log n) \u2014 logarithmic (binary search)',
                        'O(n) \u2014 linear (linear scan)',
                        'O(n log n) \u2014 linearithmic (merge sort)',
                        'O(n\u00B2) \u2014 quadratic (bubble sort)',
                        'O(2^n) \u2014 exponential (recursive Fibonacci)',
                      ]),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Big-O ignores constants \u2014 5n is still O(n).',
                        'Worst case is the most common guarantee.',
                        'Space complexity uses the same notation.',
                      ]),
                    ],
                    category: 'Computer Science',
                    model: 'PrepQuest AI',
                    timestamp: 'Yesterday',
                    readingTime: '8 min read',
                    wordCount: '942 words',
                    canExpand: true,
                    expanded: false,
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onExpandToggle: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'With category badge & metadata'),
                  AiSummaryCard(
                    title: 'Photosynthesis Overview',
                    subtitle: 'How plants convert light into energy',
                    badgeLabel: 'AI BRIEF',
                    tone: AiSummaryTone.brief,
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Photosynthesis is the biochemical process by which '
                        'green plants, algae, and certain bacteria convert '
                        'light energy into chemical energy stored in glucose.',
                      ),
                      const AiSummaryHighlightSection(
                        text:
                            'The light-dependent reactions occur in the '
                            'thylakoid membranes of the chloroplast, while '
                            'the Calvin cycle takes place in the stroma.',
                        terms: <String>[
                          'thylakoid membranes',
                          'Calvin cycle',
                          'chloroplast',
                          'stroma',
                        ],
                      ),
                    ],
                    category: 'Biology',
                    model: 'Claude Sonnet',
                    timestamp: '3 hours ago',
                    readingTime: '2 min read',
                    wordCount: '256 words',
                    tags: <String>['Biology', 'Plants', 'Energy'],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'With footer actions — full toolbar',
                  ),
                  AiSummaryCard(
                    title: 'Bangladesh Constitution: Fundamental Rights',
                    subtitle: 'Articles 26\u201347 of the Constitution',
                    badgeLabel: 'AI DEEP DIVE',
                    tone: AiSummaryTone.deepDive,
                    sections: <AiSummarySection>[
                      const AiSummaryNumberedListSection(<String>[
                        'Right to equality before the law and equal protection of law.',
                        'Protection against discrimination on grounds of religion, race, caste, sex or place of birth.',
                        'Right to life, liberty and personal security.',
                        'Protection of freedom of speech, assembly and association.',
                        'Freedom of religion and religious worship.',
                      ]),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Fundamental Rights are enforceable through the High Court Division.',
                        'Articles can be suspended during emergencies (Article 141A).',
                        'Right to property was removed from fundamental rights in 1982.',
                      ]),
                    ],
                    category: 'Bangladesh Studies',
                    model: 'PrepQuest AI',
                    timestamp: 'This morning',
                    readingTime: '12 min read',
                    wordCount: '1,420 words',
                    tags: <String>[
                      'BCS',
                      'Constitution',
                      'Bangladesh',
                      'Rights',
                    ],
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onBookmark: _noop,
                      onRegenerate: _noop,
                      onReadAloud: _noop,
                      onLike: _noop,
                      onDislike: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'With code section'),
                  AiSummaryCard(
                    title: 'Bubble Sort Implementation',
                    subtitle: 'A simple O(n\u00B2) sorting algorithm',
                    badgeLabel: 'AI TIP',
                    tone: AiSummaryTone.tip,
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Bubble sort repeatedly steps through the list, '
                        'compares adjacent elements, and swaps them if they '
                        'are in the wrong order. The pass through the list '
                        'is repeated until the list is sorted.',
                      ),
                      const AiSummaryCodeSection(
                        code:
                            'void bubbleSort(List<int> arr) {\n'
                            '  for (var i = 0; i < arr.length - 1; i++) {\n'
                            '    for (var j = 0; j < arr.length - i - 1; j++) {\n'
                            '      if (arr[j] > arr[j + 1]) {\n'
                            '        final tmp = arr[j];\n'
                            '        arr[j] = arr[j + 1];\n'
                            '        arr[j + 1] = tmp;\n'
                            '      }\n'
                            '    }\n'
                            '  }\n'
                            '}',
                        language: 'dart',
                      ),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Worst-case time complexity: O(n\u00B2).',
                        'Space complexity: O(1) \u2014 in-place sorting.',
                        'Stable sort \u2014 preserves the relative order of equal elements.',
                      ]),
                    ],
                    category: 'Algorithms',
                    model: 'PrepQuest AI',
                    timestamp: 'Yesterday',
                    readingTime: '4 min read',
                    wordCount: '312 words',
                    tags: <String>['Algorithms', 'Sorting', 'Dart'],
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onRegenerate: _noop,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(
                    text: 'Warning tone — important findings',
                  ),
                  AiSummaryCard(
                    title: 'Account Security: Action Required',
                    subtitle: 'Unusual sign-in activity detected',
                    badgeLabel: 'SECURITY',
                    tone: AiSummaryTone.warning,
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'We detected a sign-in from a new device in Dhaka, '
                        'Bangladesh on July 19, 2026 at 23:42 local time. If '
                        'this was not you, please secure your account '
                        'immediately by changing your password and reviewing '
                        'recent activity.',
                      ),
                      const AiSummaryBulletListSection(<String>[
                        'Device: Chrome 126 on Windows 11',
                        'Location: Dhaka, Bangladesh',
                        'IP address: 103.59.x.x (approximate)',
                      ]),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Change your password if this was not you.',
                        'Enable two-factor authentication.',
                        'Review the active sessions list in account settings.',
                      ]),
                    ],
                    category: 'Security',
                    timestamp: '5 minutes ago',
                    actions: AiSummaryActions(onCopy: _noop, onShare: _noop),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Custom gradient background'),
                  AiSummaryCard(
                    title: 'Climate Change: 2026 Outlook',
                    subtitle: 'Latest findings from IPCC reports',
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Global average temperatures have risen 1.45\u00B0C '
                        'above pre-industrial levels. The IPCC projects that '
                        'we will exceed 1.5\u00B0C within the next decade '
                        'unless emissions are cut drastically.',
                      ),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Carbon budgets are running out faster than expected.',
                        'Renewable energy capacity doubled in the last 5 years.',
                        'Adaptation funding still falls short of need.',
                      ]),
                    ],
                    category: 'Environment',
                    model: 'PrepQuest AI',
                    timestamp: '1 day ago',
                    readingTime: '6 min read',
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: <Color>[Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
                    ),
                    borderColor: const Color(0xFFBFDBFE),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Minimal — no badge, no actions'),
                  const AiSummaryCard(
                    title: 'Recap: Today\u2019s Lesson',
                    sections: <AiSummarySection>[
                      AiSummaryTextSection(
                        'Today we covered the basics of photosynthesis, '
                        'including the light-dependent reactions and the '
                        'Calvin cycle. Tomorrow we will explore cellular '
                        'respiration and how it complements photosynthesis.',
                      ),
                    ],
                    showBadge: false,
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const _SectionLabel(text: 'Dark theme — heavy content'),
                  AiSummaryCard(
                    title: 'Quantum Mechanics Primer',
                    subtitle: 'Wave-particle duality and uncertainty',
                    badgeLabel: 'AI DEEP DIVE',
                    tone: AiSummaryTone.deepDive,
                    sections: <AiSummarySection>[
                      const AiSummaryTextSection(
                        'Quantum mechanics is the branch of physics that '
                        'describes nature at the smallest scales \u2014 atoms '
                        'and subatomic particles. Unlike classical mechanics, '
                        'it is fundamentally probabilistic.',
                      ),
                      const AiSummaryBulletListSection(<String>[
                        'Wave-particle duality \u2014 every particle also behaves like a wave.',
                        'Heisenberg\u2019s uncertainty principle \u2014 position and momentum cannot both be precisely measured.',
                        'Superposition \u2014 particles exist in all possible states until observed.',
                        'Quantum entanglement \u2014 particles can be correlated across arbitrary distances.',
                      ]),
                      const AiSummaryHighlightSection(
                        text:
                            'The Schr\u00F6dinger equation is the fundamental '
                            'equation of motion for quantum systems, '
                            'describing how the quantum state evolves over '
                            'time.',
                        terms: <String>[
                          'Schr\u00F6dinger equation',
                          'quantum state',
                        ],
                      ),
                      const AiSummaryKeyTakeawaysSection(<String>[
                        'Quantum effects disappear at macroscopic scales.',
                        'Observation collapses the wave function.',
                        'Entanglement does not allow faster-than-light communication.',
                      ]),
                    ],
                    category: 'Physics',
                    model: 'PrepQuest AI',
                    timestamp: '4 days ago',
                    readingTime: '15 min read',
                    wordCount: '2,100 words',
                    tags: <String>[
                      'Quantum',
                      'Physics',
                      'Wave',
                      'Particle',
                      'Uncertainty',
                    ],
                    actions: AiSummaryActions(
                      onCopy: _noop,
                      onShare: _noop,
                      onBookmark: _noop,
                      onRegenerate: _noop,
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
