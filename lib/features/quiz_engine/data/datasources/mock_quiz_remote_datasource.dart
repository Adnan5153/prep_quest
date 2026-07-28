import '../models/question_model.dart';
import '../models/quiz_model.dart';
import '../models/quiz_report_model.dart';
import '../models/quiz_result_model.dart';
import '../models/quiz_session_model.dart';
import 'quiz_remote_datasource.dart';

/// In-memory implementation of [QuizRemoteDataSource] used while
/// Firebase is not yet wired. Persists nothing across app restarts.
class MockQuizRemoteDataSource implements QuizRemoteDataSource {
  MockQuizRemoteDataSource({Duration? latency})
      : _latency = latency ?? const Duration(milliseconds: 280);

  final Duration _latency;
  final List<QuizModel> _quizzes = _seedQuizzes();
  final Set<String> _bookmarks = <String>{};
  final List<QuizReportModel> _reports = <QuizReportModel>[];
  int _reportCounter = 0;

  @override
  Future<List<QuizModel>> fetchAllQuizzes() async {
    await Future<void>.delayed(_latency);
    return List<QuizModel>.unmodifiable(_quizzes);
  }

  @override
  Future<List<QuizModel>> fetchQuizzesForNode(String nodeId) async {
    await Future<void>.delayed(_latency);
    return _quizzes
        .where((QuizModel q) => q.nodeId == nodeId)
        .toList(growable: false);
  }

  @override
  Future<QuizModel?> fetchQuizById(String id) async {
    await Future<void>.delayed(_latency);
    for (final QuizModel q in _quizzes) {
      if (q.id == id) return q;
    }
    return null;
  }

  @override
  Future<QuizResultModel> submitQuizSession(
    QuizSessionModel session,
  ) async {
    await Future<void>.delayed(_latency);
    final QuizModel quiz = _quizzes.firstWhere(
      (QuizModel q) => q.id == session.quizId,
      orElse: () => _emptyQuiz(session.quizId),
    );
    final Map<String, bool> results = <String, bool>{};
    int correct = 0;
    int incorrect = 0;
    int skipped = 0;
    int earned = 0;
    int total = 0;
    for (final QuestionModel q in quiz.questions) {
      total += q.points;
      final QuestionProgressModel? progress = session.progress[q.id];
      if (progress == null ||
          progress.selectedAnswerIds.isEmpty) {
        skipped += 1;
        results[q.id] = false;
        continue;
      }
      final bool isRight =
          q.isCorrect(progress.selectedAnswerIds);
      results[q.id] = isRight;
      if (isRight) {
        correct += 1;
        earned += q.points;
      } else {
        incorrect += 1;
        if (quiz.negativeMarkingPercent > 0) {
          earned -= (q.points * quiz.negativeMarkingPercent / 100).round();
        }
      }
    }
    final int scorePercent =
        total == 0 ? 0 : ((earned.clamp(0, total) / total) * 100).round();
    final bool passed = scorePercent >= quiz.passingScorePercent;
    final int rewardXp = passed ? quiz.rewardXp : (quiz.rewardXp ~/ 2);
    final int rewardCoins = passed ? quiz.rewardCoins : 0;
    return QuizResultModel(
      sessionId: session.sessionId,
      quizId: session.quizId,
      scorePercent: scorePercent,
      totalPoints: total,
      earnedPoints: earned.clamp(0, total),
      correctCount: correct,
      incorrectCount: incorrect,
      skippedCount: skipped,
      timeSpentSeconds: 0,
      passed: passed,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      questionResults: results,
      difficultyId: quiz.difficultyId,
      completedAtIso: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<List<String>> fetchBookmarkedQuestionIds() async {
    await Future<void>.delayed(_latency);
    return List<String>.unmodifiable(_bookmarks);
  }

  @override
  Future<bool> toggleBookmark(String questionId) async {
    await Future<void>.delayed(_latency);
    if (_bookmarks.contains(questionId)) {
      _bookmarks.remove(questionId);
      return false;
    }
    _bookmarks.add(questionId);
    return true;
  }

  @override
  Future<QuizReportModel> submitReport({
    required String questionId,
    required String quizId,
    required String reasonId,
    required String note,
  }) async {
    await Future<void>.delayed(_latency);
    _reportCounter += 1;
    final QuizReportModel report = QuizReportModel(
      id: 'report-$_reportCounter',
      questionId: questionId,
      quizId: quizId,
      reasonId: reasonId,
      note: note,
      createdAtIso: DateTime.now().toIso8601String(),
    );
    _reports.add(report);
    return report;
  }

  QuizModel _emptyQuiz(String id) {
    return QuizModel(
      id: id,
      title: 'Unknown Quiz',
      subject: 'General',
      kindId: 'custom',
      difficultyId: 'medium',
      questions: const <QuestionModel>[],
      rewardXp: 0,
      rewardCoins: 0,
      tags: const <String>[],
      availableFromIso: DateTime(2000).toIso8601String(),
      availableUntilIso: DateTime(2100).toIso8601String(),
    );
  }

  static List<QuizModel> _seedQuizzes() {
    final DateTime now = DateTime.now();
    final DateTime from = now.subtract(const Duration(days: 1));
    final DateTime until = now.add(const Duration(days: 30));
    return <QuizModel>[
      QuizModel(
        id: 'quiz-bangladesh-basics',
        title: 'Bangladesh Affairs: Basics',
        subject: 'Bangladesh Affairs',
        kindId: 'lessonPractice',
        difficultyId: 'easy',
        nodeId: 'node-0',
        description: 'A foundational quiz covering Bangladesh history and geography.',
        timeLimitSeconds: 600,
        passingScorePercent: 60,
        rewardXp: 30,
        rewardCoins: 12,
        tags: const <String>['Bangladesh', 'History', 'Geography'],
        availableFromIso: from.toIso8601String(),
        availableUntilIso: until.toIso8601String(),
        questions: <QuestionModel>[
          QuestionModel(
            id: 'q-bd-1',
            quizId: 'quiz-bangladesh-basics',
            typeId: 'single_choice',
            prompt: 'In which year did Bangladesh gain independence?',
            topic: 'History',
            difficulty: 'easy',
            tags: const <String>['Independence'],
            points: 1,
            correctAnswerIds: const <String>['a-bd-1-3'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-bd-1-1', text: '1947'),
              AnswerModel(id: 'a-bd-1-2', text: '1952'),
              AnswerModel(id: 'a-bd-1-3', text: '1971'),
              AnswerModel(id: 'a-bd-1-4', text: '1990'),
            ],
            explanation:
                'Bangladesh declared independence on 26 March 1971 and won the Liberation War on 16 December 1971.',
          ),
          QuestionModel(
            id: 'q-bd-2',
            quizId: 'quiz-bangladesh-basics',
            typeId: 'single_choice',
            prompt: 'Which is the national river of Bangladesh?',
            topic: 'Geography',
            difficulty: 'easy',
            tags: const <String>['Rivers'],
            points: 1,
            correctAnswerIds: const <String>['a-bd-2-1'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-bd-2-1', text: 'Padma'),
              AnswerModel(id: 'a-bd-2-2', text: 'Meghna'),
              AnswerModel(id: 'a-bd-2-3', text: 'Jamuna'),
              AnswerModel(id: 'a-bd-2-4', text: 'Surma'),
            ],
          ),
          QuestionModel(
            id: 'q-bd-3',
            quizId: 'quiz-bangladesh-basics',
            typeId: 'multi_select',
            prompt: 'Which of the following are major rivers of Bangladesh?',
            topic: 'Geography',
            difficulty: 'medium',
            tags: const <String>['Rivers'],
            points: 2,
            correctAnswerIds: const <String>['a-bd-3-1', 'a-bd-3-2', 'a-bd-3-3'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-bd-3-1', text: 'Padma'),
              AnswerModel(id: 'a-bd-3-2', text: 'Meghna'),
              AnswerModel(id: 'a-bd-3-3', text: 'Jamuna'),
              AnswerModel(id: 'a-bd-3-4', text: 'Ganges'),
            ],
            hints: const <HintModel>[
              HintModel(
                id: 'h-bd-3-1',
                text: 'Three of the four options are rivers.',
              ),
            ],
          ),
          QuestionModel(
            id: 'q-bd-4',
            quizId: 'quiz-bangladesh-basics',
            typeId: 'true_false',
            prompt: 'The national anthem of Bangladesh was written by Rabindranath Tagore.',
            topic: 'Civics',
            difficulty: 'easy',
            tags: const <String>['National Symbols'],
            points: 1,
            correctAnswerIds: const <String>['a-bd-4-1'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-bd-4-1', text: 'True'),
              AnswerModel(id: 'a-bd-4-2', text: 'False'),
            ],
          ),
        ],
      ),
      QuizModel(
        id: 'quiz-grammar-essentials',
        title: 'English Grammar Essentials',
        subject: 'English',
        kindId: 'lessonPractice',
        difficultyId: 'medium',
        nodeId: 'node-1',
        description: 'Tenses, articles, and prepositions — the most tested BCS English topics.',
        timeLimitSeconds: 900,
        passingScorePercent: 65,
        negativeMarkingPercent: 25,
        rewardXp: 40,
        rewardCoins: 15,
        tags: const <String>['English', 'Grammar'],
        availableFromIso: from.toIso8601String(),
        availableUntilIso: until.toIso8601String(),
        questions: <QuestionModel>[
          QuestionModel(
            id: 'q-en-1',
            quizId: 'quiz-grammar-essentials',
            typeId: 'single_choice',
            prompt: 'Choose the correct article: ___ honest man never tells a lie.',
            topic: 'Articles',
            difficulty: 'easy',
            tags: const <String>['Articles'],
            points: 1,
            correctAnswerIds: const <String>['a-en-1-2'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-en-1-1', text: 'A'),
              AnswerModel(id: 'a-en-1-2', text: 'An'),
              AnswerModel(id: 'a-en-1-3', text: 'The'),
              AnswerModel(id: 'a-en-1-4', text: 'No article'),
            ],
            explanation:
                'Use "an" before vowel sounds. "Honest" starts with a silent "h".',
          ),
          QuestionModel(
            id: 'q-en-2',
            quizId: 'quiz-grammar-essentials',
            typeId: 'single_choice',
            prompt: 'Which sentence is in the present perfect continuous tense?',
            topic: 'Tenses',
            difficulty: 'medium',
            tags: const <String>['Tenses'],
            points: 2,
            correctAnswerIds: const <String>['a-en-2-3'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-en-2-1', text: 'I write letters.'),
              AnswerModel(id: 'a-en-2-2', text: 'I am writing a letter.'),
              AnswerModel(id: 'a-en-2-3', text: 'I have been writing for two hours.'),
              AnswerModel(id: 'a-en-2-4', text: 'I wrote a letter.'),
            ],
            hints: const <HintModel>[
              HintModel(
                id: 'h-en-2-1',
                text: 'Look for "have been" + present participle.',
              ),
            ],
          ),
        ],
      ),
      QuizModel(
        id: 'quiz-mathematics-fundamentals',
        title: 'Mathematics Fundamentals',
        subject: 'Mathematics',
        kindId: 'mockTest',
        difficultyId: 'mixed',
        nodeId: 'node-2',
        description: 'Arithmetic, algebra, and geometry — BCS preliminary level.',
        timeLimitSeconds: 1200,
        passingScorePercent: 60,
        rewardXp: 50,
        rewardCoins: 20,
        tags: const <String>['Mathematics', 'Quantitative'],
        availableFromIso: from.toIso8601String(),
        availableUntilIso: until.toIso8601String(),
        questions: <QuestionModel>[
          QuestionModel(
            id: 'q-mt-1',
            quizId: 'quiz-mathematics-fundamentals',
            typeId: 'single_choice',
            prompt: 'A number is increased by 20% and then decreased by 20%. What is the net change?',
            topic: 'Arithmetic',
            difficulty: 'medium',
            tags: const <String>['Percentages'],
            points: 2,
            correctAnswerIds: const <String>['a-mt-1-2'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-mt-1-1', text: 'No change'),
              AnswerModel(id: 'a-mt-1-2', text: '4% decrease'),
              AnswerModel(id: 'a-mt-1-3', text: '4% increase'),
              AnswerModel(id: 'a-mt-1-4', text: '2% decrease'),
            ],
            explanation:
                '1.20 × 0.80 = 0.96, so net change is −4%.',
          ),
          QuestionModel(
            id: 'q-mt-2',
            quizId: 'quiz-mathematics-fundamentals',
            typeId: 'single_choice',
            prompt: 'What is the area of a triangle with base 10 and height 6?',
            topic: 'Geometry',
            difficulty: 'easy',
            tags: const <String>['Geometry'],
            points: 1,
            correctAnswerIds: const <String>['a-mt-2-1'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-mt-2-1', text: '30'),
              AnswerModel(id: 'a-mt-2-2', text: '60'),
              AnswerModel(id: 'a-mt-2-3', text: '16'),
              AnswerModel(id: 'a-mt-2-4', text: '20'),
            ],
          ),
        ],
      ),
      QuizModel(
        id: 'quiz-daily-challenge',
        title: 'Daily Challenge',
        subject: 'Mixed',
        kindId: 'dailyChallenge',
        difficultyId: 'mixed',
        nodeId: 'node-1',
        description: 'A 5-question daily mix. New set every day.',
        timeLimitSeconds: 300,
        passingScorePercent: 60,
        rewardXp: 25,
        rewardCoins: 10,
        tags: const <String>['Daily', 'Challenge'],
        availableFromIso: from.toIso8601String(),
        availableUntilIso: until.toIso8601String(),
        questions: <QuestionModel>[
          QuestionModel(
            id: 'q-d-1',
            quizId: 'quiz-daily-challenge',
            typeId: 'true_false',
            prompt: 'The sun rises in the east.',
            topic: 'General Knowledge',
            difficulty: 'easy',
            tags: const <String>['GK'],
            points: 1,
            correctAnswerIds: const <String>['a-d-1-1'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-d-1-1', text: 'True'),
              AnswerModel(id: 'a-d-1-2', text: 'False'),
            ],
          ),
          QuestionModel(
            id: 'q-d-2',
            quizId: 'quiz-daily-challenge',
            typeId: 'single_choice',
            prompt: '2 + 2 × 3 = ?',
            topic: 'Mathematics',
            difficulty: 'easy',
            tags: const <String>['Arithmetic'],
            points: 1,
            correctAnswerIds: const <String>['a-d-2-2'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-d-2-1', text: '12'),
              AnswerModel(id: 'a-d-2-2', text: '8'),
              AnswerModel(id: 'a-d-2-3', text: '10'),
              AnswerModel(id: 'a-d-2-4', text: '6'),
            ],
            explanation: 'Order of operations: multiplication before addition.',
          ),
        ],
      ),
      QuizModel(
        id: 'quiz-boss-gate',
        title: 'BCS Boss Gate',
        subject: 'Bangladesh Affairs',
        kindId: 'bossGate',
        difficultyId: 'hard',
        nodeId: 'node-boss',
        description: 'A challenging gate to unlock the BCS Boss challenge.',
        timeLimitSeconds: 600,
        passingScorePercent: 75,
        rewardXp: 100,
        rewardCoins: 50,
        tags: const <String>['Boss', 'BCS'],
        availableFromIso: from.toIso8601String(),
        availableUntilIso: until.toIso8601String(),
        requiresLevel: 4,
        isPremium: true,
        questions: <QuestionModel>[
          QuestionModel(
            id: 'q-boss-1',
            quizId: 'quiz-boss-gate',
            typeId: 'single_choice',
            prompt: 'Who was the first President of Bangladesh?',
            topic: 'History',
            difficulty: 'hard',
            tags: const <String>['Presidents'],
            points: 3,
            correctAnswerIds: const <String>['a-boss-1-1'],
            answers: const <AnswerModel>[
              AnswerModel(id: 'a-boss-1-1', text: 'Sheikh Mujibur Rahman'),
              AnswerModel(id: 'a-boss-1-2', text: 'Ziaur Rahman'),
              AnswerModel(id: 'a-boss-1-3', text: 'A.S.M. Abdur Rab'),
              AnswerModel(id: 'a-boss-1-4', text: 'Iajuddin Ahmed'),
            ],
          ),
        ],
      ),
    ];
  }
}
