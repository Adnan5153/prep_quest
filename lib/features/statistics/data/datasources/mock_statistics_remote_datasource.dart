import 'dart:math';

import '../../domain/entities/statistics_entity.dart';
import '../../domain/entities/subject_statistics_entity.dart';
import '../models/statistics_model.dart';
import '../models/study_statistics_model.dart';
import '../models/subject_statistics_model.dart';
import 'statistics_remote_datasource.dart';

class MockStatisticsRemoteDataSource implements StatisticsRemoteDataSource {
  MockStatisticsRemoteDataSource({DateTime Function()? clock})
      : _clock = clock ?? DateTime.now;

  final DateTime Function() _clock;
  final Random _rng = Random(42);

  static const List<_SubjectBlueprint> _subjects =
      <_SubjectBlueprint>[
    _SubjectBlueprint(
      id: 'bcs_bangla',
      name: 'Bangla',
      total: 320,
      correct: 268,
      incorrect: 38,
      skipped: 14,
      minutes: 1280,
      xp: 1920,
      avgSeconds: 36,
      weakest: _TopicBlueprint('t_bangla_sahityo', 'সাহিত্য', 58),
      badgeId: 'subject_master_bangla',
    ),
    _SubjectBlueprint(
      id: 'bcs_english',
      name: 'English',
      total: 280,
      correct: 232,
      incorrect: 30,
      skipped: 18,
      minutes: 1110,
      xp: 1640,
      avgSeconds: 32,
      weakest: _TopicBlueprint('t_eng_vocab', 'Vocabulary', 62),
      badgeId: 'subject_master_english',
    ),
    _SubjectBlueprint(
      id: 'bcs_math',
      name: 'Mathematics',
      total: 240,
      correct: 154,
      incorrect: 64,
      skipped: 22,
      minutes: 1320,
      xp: 1480,
      avgSeconds: 58,
      weakest: _TopicBlueprint('t_math_probability', 'Probability', 48),
    ),
    _SubjectBlueprint(
      id: 'bcs_history',
      name: 'History',
      total: 200,
      correct: 138,
      incorrect: 50,
      skipped: 12,
      minutes: 940,
      xp: 1110,
      avgSeconds: 44,
      weakest: _TopicBlueprint('t_hist_world_war', 'World Wars', 52),
    ),
    _SubjectBlueprint(
      id: 'bcs_geography',
      name: 'Geography',
      total: 180,
      correct: 121,
      incorrect: 48,
      skipped: 11,
      minutes: 820,
      xp: 980,
      avgSeconds: 42,
      weakest: _TopicBlueprint('t_geo_climate', 'Climate', 50),
    ),
    _SubjectBlueprint(
      id: 'bcs_science',
      name: 'General Science',
      total: 220,
      correct: 175,
      incorrect: 32,
      skipped: 13,
      minutes: 1020,
      xp: 1290,
      avgSeconds: 38,
      weakest: _TopicBlueprint('t_sci_physics', 'Physics Basics', 64),
      badgeId: 'subject_master_science',
    ),
  ];

  @override
  Future<StatisticsEntity> fetchStatistics() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final DateTime now = _clock();
    final List<SubjectStatisticsModel> subjectModels = _subjects
        .map((blueprint) => SubjectStatisticsModel(
              subjectId: blueprint.id,
              subjectName: blueprint.name,
              totalQuestions: blueprint.total,
              correct: blueprint.correct,
              incorrect: blueprint.incorrect,
              skipped: blueprint.skipped,
              accuracyPercent: _percent(blueprint.correct, blueprint.total),
              averageSecondsPerQuestion: blueprint.avgSeconds,
              totalMinutes: blueprint.minutes,
              xpEarned: blueprint.xp,
              weakestTopicId: blueprint.weakest.id,
              weakestTopicName: blueprint.weakest.name,
              weakestTopicAccuracy: blueprint.weakest.accuracy,
              achievementBadgeId: blueprint.badgeId,
            ))
        .toList(growable: false);

    final List<SubjectStatisticsEntity> weakEntities = subjectModels
        .map((m) => m.toEntity())
        .toList()
      ..sort((a, b) => a.accuracyPercent.compareTo(b.accuracyPercent));

    final List<SubjectStatisticsEntity> strongEntities = subjectModels
        .map((m) => m.toEntity())
        .toList()
      ..sort((a, b) => b.accuracyPercent.compareTo(a.accuracyPercent));

    final int totalQuestions =
        subjectModels.fold(0, (acc, m) => acc + m.totalQuestions);
    final int totalCorrect =
        subjectModels.fold(0, (acc, m) => acc + m.correct);
    final int totalIncorrect =
        subjectModels.fold(0, (acc, m) => acc + m.incorrect);
    final int totalSkipped =
        subjectModels.fold(0, (acc, m) => acc + m.skipped);
    final int overallAccuracy = _percent(totalCorrect, totalQuestions);
    final int totalXp =
        subjectModels.fold(0, (acc, m) => acc + m.xpEarned);

    final List<XpGrowthPoint> xpGrowth = _buildXpGrowth(now);
    final List<AccuracyPoint> dailyAccuracy = _buildDailyAccuracy();
    final List<AccuracyPoint> weeklyAccuracy = _buildWeeklyAccuracy();
    final List<HeatmapCell> heatmap = _buildHeatmap(now);
    final List<ActivityPoint> weeklyActivity = _buildWeeklyActivity();
    final List<ActivityPoint> monthlyActivity = _buildMonthlyActivity();

    final StudyStatisticsModel studyModel = StudyStatisticsModel(
      todayMinutes: 42,
      weeklyMinutes: 320,
      monthlyMinutes: 1280,
      averageDailyMinutes: 45,
      streakDays: 12,
      longestStreak: 24,
    );

    final StatisticsModel model = StatisticsModel(
      totalXp: totalXp,
      todayXp: 180,
      weeklyXp: 980,
      monthlyXp: 3200,
      currentLevel: 14,
      currentXpIntoLevel: 320,
      nextLevelXp: 600,
      overallAccuracyPercent: overallAccuracy,
      totalQuestions: totalQuestions,
      totalCorrect: totalCorrect,
      totalIncorrect: totalIncorrect,
      totalSkipped: totalSkipped,
      streakDays: 12,
      study: studyModel,
      subjectBreakdown: subjectModels,
      xpGrowth: xpGrowth,
      dailyAccuracy: dailyAccuracy,
      weeklyAccuracy: weeklyAccuracy,
      studyHeatmap: heatmap,
      weeklyActivity: weeklyActivity,
      monthlyActivity: monthlyActivity,
    );

    final List<SubjectStatisticsEntity> weak = weakEntities
        .take(3)
        .map((e) => e.copyWith(isPriority: true))
        .toList();
    final List<SubjectStatisticsEntity> strong = strongEntities
        .take(3)
        .map((e) => e.copyWith(isPriority: false))
        .toList();

    return model.toEntity(weakSubjects: weak, strongSubjects: strong);
  }

  List<XpGrowthPoint> _buildXpGrowth(DateTime now) {
    const List<String> months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final List<int> values = <int>[
      180,
      240,
      320,
      410,
      520,
      640,
      780,
      900,
      1100,
      1280,
      1460,
      1680,
    ];
    return List<XpGrowthPoint>.generate(12, (index) {
      return XpGrowthPoint(
        label: months[index],
        xp: values[index] + _rng.nextInt(80),
      );
    });
  }

  List<AccuracyPoint> _buildDailyAccuracy() {
    const List<String> labels = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const List<int> values = <int>[72, 78, 81, 74, 85, 88, 82];
    return List<AccuracyPoint>.generate(
      labels.length,
      (index) => AccuracyPoint(
        label: labels[index],
        accuracyPercent: values[index] + _rng.nextInt(5) - 2,
      ),
    );
  }

  List<AccuracyPoint> _buildWeeklyAccuracy() {
    const List<String> labels = <String>['W1', 'W2', 'W3', 'W4', 'W5', 'W6', 'W7', 'W8'];
    const List<int> values = <int>[62, 68, 71, 74, 76, 79, 82, 85];
    return List<AccuracyPoint>.generate(
      labels.length,
      (index) => AccuracyPoint(
        label: labels[index],
        accuracyPercent: values[index] + _rng.nextInt(4) - 1,
      ),
    );
  }

  List<HeatmapCell> _buildHeatmap(DateTime now) {
    final List<HeatmapCell> cells = <HeatmapCell>[];
    for (int i = 89; i >= 0; i--) {
      final DateTime date = now.subtract(Duration(days: i));
      final double intensity = _rng.nextDouble();
      cells.add(HeatmapCell(
        date: DateTime(date.year, date.month, date.day),
        intensity: intensity,
        minutes: (intensity * 90).round(),
      ));
    }
    return List<HeatmapCell>.unmodifiable(cells);
  }

  List<ActivityPoint> _buildWeeklyActivity() {
    const List<String> labels = <String>[
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    const List<int> values = <int>[42, 55, 38, 60, 47, 80, 30];
    return List<ActivityPoint>.generate(
      labels.length,
      (index) => ActivityPoint(
        label: labels[index],
        minutes: values[index] + _rng.nextInt(15),
      ),
    );
  }

  List<ActivityPoint> _buildMonthlyActivity() {
    const List<String> labels = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    const List<int> values = <int>[
      900,
      1020,
      1140,
      1180,
      1240,
      1280,
      1320,
      1380,
      1420,
      1480,
      1520,
      1600,
    ];
    return List<ActivityPoint>.generate(
      labels.length,
      (index) => ActivityPoint(
        label: labels[index],
        minutes: values[index] + _rng.nextInt(120),
      ),
    );
  }

  int _percent(int part, int whole) {
    if (whole == 0) return 0;
    return ((part / whole) * 100).round();
  }
}

class _SubjectBlueprint {
  const _SubjectBlueprint({
    required this.id,
    required this.name,
    required this.total,
    required this.correct,
    required this.incorrect,
    required this.skipped,
    required this.minutes,
    required this.xp,
    required this.avgSeconds,
    required this.weakest,
    this.badgeId,
  });

  final String id;
  final String name;
  final int total;
  final int correct;
  final int incorrect;
  final int skipped;
  final int minutes;
  final int xp;
  final int avgSeconds;
  final _TopicBlueprint weakest;
  final String? badgeId;
}

class _TopicBlueprint {
  const _TopicBlueprint(this.id, this.name, this.accuracy);

  final String id;
  final String name;
  final int accuracy;
}