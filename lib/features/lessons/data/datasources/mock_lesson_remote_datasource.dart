import '../models/lesson_model.dart';
import 'lesson_remote_datasource.dart';

class MockLessonRemoteDataSource implements LessonRemoteDataSource {
  MockLessonRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 320);

  final Duration _latency;
  final List<LessonModel> _lessons = _seedLessons();

  @override
  Future<List<LessonModel>> fetchAllLessons() async {
    await Future<void>.delayed(_latency);
    return List<LessonModel>.unmodifiable(_lessons);
  }

  @override
  Future<List<LessonModel>> fetchLessonsForNode(String nodeId) async {
    await Future<void>.delayed(_latency);
    return _lessons
        .where((LessonModel l) => l.nodeIds.contains(nodeId))
        .toList(growable: false);
  }

  @override
  Future<LessonModel?> fetchLessonById(String id) async {
    await Future<void>.delayed(_latency);
    for (final LessonModel l in _lessons) {
      if (l.id == id) return l;
    }
    return null;
  }

  @override
  Future<LessonModel?> fetchLessonBySlug(String slug) async {
    await Future<void>.delayed(_latency);
    for (final LessonModel l in _lessons) {
      if (l.slug == slug) return l;
    }
    return null;
  }

  static List<LessonModel> _seedLessons() {
    return <LessonModel>[
      LessonModel(
        id: 'lesson-foundations',
        slug: 'bcs-foundations',
        subject: 'Bangladesh Affairs',
        title: 'Foundations of Bangladesh',
        subtitle: 'History, geography, and identity',
        summary:
            'A concise introduction to the political, geographic, and cultural foundations of Bangladesh.',
        sections: <LessonSectionModel>[
          LessonSectionModel(
            id: 'sec-intro',
            title: 'Introduction',
            kind: 'introduction',
            body:
                'Bangladesh emerged as an independent nation in 1971 after a Liberation War. Understanding its geography and history is essential for every BCS candidate.',
            bullets: const <String>[
              'Capital: Dhaka',
              'Independence: 1971',
              'Official language: Bangla',
            ],
            callout: 'Bangladesh is the eighth most populous country in the world.',
            estimatedMinutes: 2,
          ),
          LessonSectionModel(
            id: 'sec-history',
            title: 'Historical Background',
            kind: 'explanation',
            body:
                'The region witnessed the Partition of Bengal in 1905, the Language Movement of 1952, and the Six Point Movement in 1966 — all foundational to the independence movement.',
            bullets: const <String>[
              '1905: Partition of Bengal',
              '1947: Partition of India',
              '1952: Language Movement',
              '1971: Liberation War',
            ],
            estimatedMinutes: 3,
          ),
          LessonSectionModel(
            id: 'sec-geography',
            title: 'Geography at a Glance',
            kind: 'concept',
            body:
                'Bangladesh lies on the Ganges-Brahmaputra delta, with three major rivers shaping its fertile plains and monsoonal cycles.',
            estimatedMinutes: 2,
          ),
        ],
        examples: <LessonExampleModel>[
          LessonExampleModel(
            id: 'ex-1',
            title: 'Chronology Match',
            prompt: 'Match the year with the event that shaped Bangladesh.',
            steps: const <String>[
              'Identify the year of the Language Movement.',
              'Identify the year of independence.',
              'Identify the year of the Six Point Movement.',
            ],
            answer:
                '1952 (Language Movement), 1966 (Six Point), 1971 (Independence).',
            explanation:
                'Remembering the chronology helps in both general knowledge and current affairs sections.',
          ),
        ],
        summarySection: LessonSummaryModel(
          keyTakeaways: const <String>[
            'Bangladesh is a young nation with deep historical roots.',
            'Three major rivers define its geography and economy.',
            'The Liberation War is central to national identity.',
          ],
          nextSteps: const <String>[
            'Review the Constitution of Bangladesh.',
            'Move on to the Independence War lesson.',
          ],
          recommendedChallengeId: 'challenge-history',
        ),
        estimatedReadingMinutes: 8,
        difficulty: 'easy',
        tags: const <String>['Bangladesh', 'History', 'Geography'],
        rewardXp: 25,
        rewardCoins: 10,
        nodeIds: const <String>['node-0', 'node-1'],
      ),
      LessonModel(
        id: 'lesson-grammar',
        slug: 'english-grammar-essentials',
        subject: 'English',
        title: 'Grammar Essentials',
        subtitle: 'Tenses, articles, and prepositions',
        summary:
            'Master the grammatical building blocks most often tested in BCS English.',
        sections: <LessonSectionModel>[
          LessonSectionModel(
            id: 'sec-tense',
            title: 'Tenses Overview',
            kind: 'concept',
            body:
                'English has three primary tenses — past, present, and future — each with simple, continuous, perfect, and perfect continuous forms.',
            bullets: const <String>[
              'Simple Present: I write.',
              'Present Continuous: I am writing.',
              'Present Perfect: I have written.',
              'Present Perfect Continuous: I have been writing.',
            ],
            callout:
                'Tense errors are the single biggest grammar issue in BCS English papers.',
            estimatedMinutes: 3,
          ),
          LessonSectionModel(
            id: 'sec-articles',
            title: 'Articles in Detail',
            kind: 'explanation',
            body:
                'Use "a" before consonant sounds and "an" before vowel sounds. Use "the" when referring to a specific noun.',
            bullets: const <String>[
              'a university (consonant sound)',
              'an honest man (vowel sound)',
              'the book on the table',
            ],
            estimatedMinutes: 2,
          ),
          LessonSectionModel(
            id: 'sec-prepositions',
            title: 'Common Prepositions',
            kind: 'tip',
            body:
                'Prepositions express relationships between nouns and other words. Memorise the most common pairs.',
            bullets: const <String>[
              'on time / in time',
              'at the corner / in the corner',
              'by car / on foot',
            ],
            estimatedMinutes: 2,
          ),
        ],
        examples: <LessonExampleModel>[
          LessonExampleModel(
            id: 'ex-grammar-1',
            title: 'Article Practice',
            prompt: 'Choose the correct article for each blank.',
            steps: const <String>[
              '___ honest man never tells a lie.',
              'She is ___ MBA.',
              '___ sun rises in the east.',
            ],
            answer: 'An, an, The.',
            explanation:
                '"Honest" starts with a vowel sound; "MBA" begins with "em"; "the sun" is unique.',
          ),
        ],
        summarySection: LessonSummaryModel(
          keyTakeaways: const <String>[
            'Tenses carry time; articles carry specificity.',
            'Preposition pairs are best memorised in context.',
          ],
          nextSteps: const <String>[
            'Take the Grammar Quiz from the Playground.',
            'Practice sentence transformation drills.',
          ],
        ),
        estimatedReadingMinutes: 10,
        difficulty: 'medium',
        tags: const <String>['English', 'Grammar', 'BCS'],
        rewardXp: 30,
        rewardCoins: 12,
        nodeIds: const <String>['node-1', 'node-2'],
        requiresLevel: 2,
      ),
      LessonModel(
        id: 'lesson-mathematics',
        slug: 'mathematics-fundamentals',
        subject: 'Mathematics',
        title: 'Mathematics Fundamentals',
        subtitle: 'Arithmetic, algebra, and geometry basics',
        summary:
            'Sharpen the core quantitative skills needed for BCS preliminary exams.',
        sections: <LessonSectionModel>[
          LessonSectionModel(
            id: 'sec-arithmetic',
            title: 'Arithmetic Refresher',
            kind: 'concept',
            body:
                'Revisit percentages, ratios, and averages — the most common question categories in BCS quantitative aptitude.',
            bullets: const <String>[
              'Percentage change formula',
              'Ratio and proportion',
              'Weighted averages',
            ],
            estimatedMinutes: 4,
          ),
          LessonSectionModel(
            id: 'sec-algebra',
            title: 'Algebra Essentials',
            kind: 'explanation',
            body:
                'Linear equations, quadratics, and inequalities form the backbone of algebra questions.',
            estimatedMinutes: 3,
          ),
          LessonSectionModel(
            id: 'sec-geometry',
            title: 'Geometry in a Nutshell',
            kind: 'practice',
            body:
                'Know the area, perimeter, and volume formulas for common shapes.',
            bullets: const <String>[
              'Circle: πr² and 2πr',
              'Triangle: ½ × b × h',
              'Cuboid volume: l × w × h',
            ],
            estimatedMinutes: 3,
          ),
        ],
        examples: <LessonExampleModel>[
          LessonExampleModel(
            id: 'ex-math-1',
            title: 'Percentage Increase',
            prompt:
                'A number is increased by 20% and then decreased by 20%. What is the net change?',
            steps: const <String>[
              'Multiply by 1.20 then by 0.80.',
              'Compare to the original value.',
            ],
            answer: 'A net 4% decrease.',
            explanation:
                'Compound percentage changes are multiplicative, not additive.',
          ),
        ],
        summarySection: LessonSummaryModel(
          keyTakeaways: const <String>[
            'Practice mental arithmetic daily.',
            'Memorise formulas but understand their derivation.',
          ],
          nextSteps: const <String>[
            'Attempt the Mock Test from the Playground.',
            'Track weak topics in the Weakness Dashboard.',
          ],
        ),
        estimatedReadingMinutes: 12,
        difficulty: 'medium',
        tags: const <String>['Mathematics', 'Quantitative', 'BCS'],
        rewardXp: 40,
        rewardCoins: 15,
        nodeIds: const <String>['node-2'],
        requiresLevel: 3,
      ),
      LessonModel(
        id: 'lesson-library',
        slug: 'reference-library',
        subject: 'Library',
        title: 'Reference Library',
        subtitle: 'Formulas, dates, and shortcuts',
        summary:
            'Quick-reference summaries to bookmark and consult during revision.',
        sections: <LessonSectionModel>[
          LessonSectionModel(
            id: 'sec-formulas',
            title: 'Common Formulas',
            kind: 'summary',
            body:
                'Curated formulas across math, physics, and finance — bookmark this section for fast lookup.',
            bullets: const <String>[
              'Simple interest: P × R × T / 100',
              'Compound interest: P(1 + R/100)^T − P',
              'Work rate: 1 / time',
            ],
            estimatedMinutes: 3,
          ),
        ],
        examples: <LessonExampleModel>[
          LessonExampleModel(
            id: 'ex-lib-1',
            title: 'Interest Comparison',
            prompt:
                'Which yields more: 10% simple interest for 3 years or 9% compound interest for 3 years?',
            steps: const <String>[
              'Compute simple interest total.',
              'Compute compound interest total.',
              'Compare the two.',
            ],
            answer: 'Compound interest at 9% slightly beats simple at 10%.',
          ),
        ],
        summarySection: LessonSummaryModel(
          keyTakeaways: const <String>[
            'Bookmark formulas for fast recall.',
            'Compare interest regimes before committing.',
          ],
          nextSteps: const <String>[
            'Continue exploring the Library via the Playground Library building.',
          ],
        ),
        estimatedReadingMinutes: 6,
        difficulty: 'easy',
        tags: const <String>['Library', 'Formulas', 'Reference'],
        rewardXp: 20,
        rewardCoins: 8,
        nodeIds: const <String>['node-3'],
      ),
      LessonModel(
        id: 'lesson-mock-test',
        slug: 'mock-test-strategy',
        subject: 'Strategy',
        title: 'Mock Test Strategy',
        subtitle: 'Time management and revision tactics',
        summary:
            'A focused strategy guide to maximise your score in the BCS mock test.',
        sections: <LessonSectionModel>[
          LessonSectionModel(
            id: 'sec-time',
            title: 'Time Management',
            kind: 'tip',
            body:
                'Allocate 45 seconds per MCQ in the preliminary exam. Skip questions you cannot answer within that window.',
            bullets: const <String>[
              'Pass 1: attempt easy questions.',
              'Pass 2: tackle medium questions.',
              'Pass 3: revisit flagged ones.',
            ],
            estimatedMinutes: 3,
          ),
          LessonSectionModel(
            id: 'sec-revision',
            title: 'Revision Tactics',
            kind: 'practice',
            body:
                'Use the last 10 minutes to review flagged answers and ensure no clerical mistakes.',
            estimatedMinutes: 2,
          ),
        ],
        examples: <LessonExampleModel>[
          LessonExampleModel(
            id: 'ex-mock-1',
            title: 'Question Triage',
            prompt: 'How do you decide whether to skip a question?',
            steps: const <String>[
              'Estimate the time required.',
              'Compare to remaining time budget.',
              'Skip if over budget.',
            ],
            answer: 'Skip if solving it would consume more than your per-question budget.',
          ),
        ],
        summarySection: LessonSummaryModel(
          keyTakeaways: const <String>[
            'Time is the most important resource in a mock test.',
            'Revisit flagged questions only after the easy pass.',
          ],
          nextSteps: const <String>[
            'Take a full-length mock test from the Mock Test hub.',
          ],
        ),
        estimatedReadingMinutes: 5,
        difficulty: 'easy',
        tags: const <String>['Mock Test', 'Strategy'],
        rewardXp: 20,
        rewardCoins: 8,
        nodeIds: const <String>['node-5'],
      ),
    ];
  }
}