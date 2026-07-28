import '../../domain/entities/lesson_entity.dart';
import '../../domain/entities/lesson_example_entity.dart';
import '../../domain/entities/lesson_section_entity.dart';
import '../../domain/entities/lesson_summary_entity.dart';

class LessonSectionModel {
  const LessonSectionModel({
    required this.id,
    required this.title,
    required this.body,
    this.kind = 'concept',
    this.bullets = const <String>[],
    this.callout,
    this.estimatedMinutes = 2,
  });

  final String id;
  final String title;
  final String body;
  final String kind;
  final List<String> bullets;
  final String? callout;
  final int estimatedMinutes;

  LessonSectionEntity toEntity({bool isCompleted = false}) {
    return LessonSectionEntity(
      id: id,
      title: title,
      body: body,
      kind: _resolveKind(kind),
      bullets: bullets,
      callout: callout,
      isCompleted: isCompleted,
      estimatedMinutes: estimatedMinutes,
    );
  }

  static LessonSectionKind _resolveKind(String raw) {
    switch (raw) {
      case 'introduction':
        return LessonSectionKind.introduction;
      case 'explanation':
        return LessonSectionKind.explanation;
      case 'practice':
        return LessonSectionKind.practice;
      case 'tip':
        return LessonSectionKind.tip;
      case 'summary':
        return LessonSectionKind.summary;
      default:
        return LessonSectionKind.concept;
    }
  }
}

class LessonExampleModel {
  const LessonExampleModel({
    required this.id,
    required this.title,
    required this.prompt,
    required this.steps,
    required this.answer,
    this.explanation,
  });

  final String id;
  final String title;
  final String prompt;
  final List<String> steps;
  final String answer;
  final String? explanation;

  LessonExampleEntity toEntity() {
    return LessonExampleEntity(
      id: id,
      title: title,
      prompt: prompt,
      steps: steps,
      answer: answer,
      explanation: explanation,
    );
  }
}

class LessonSummaryModel {
  const LessonSummaryModel({
    required this.keyTakeaways,
    required this.nextSteps,
    this.recommendedChallengeId,
  });

  final List<String> keyTakeaways;
  final List<String> nextSteps;
  final String? recommendedChallengeId;

  LessonSummaryEntity toEntity() {
    return LessonSummaryEntity(
      keyTakeaways: keyTakeaways,
      nextSteps: nextSteps,
      recommendedChallengeId: recommendedChallengeId,
    );
  }
}

class LessonModel {
  const LessonModel({
    required this.id,
    required this.slug,
    required this.subject,
    required this.title,
    required this.subtitle,
    required this.summary,
    required this.sections,
    required this.examples,
    required this.summarySection,
    required this.estimatedReadingMinutes,
    required this.difficulty,
    required this.tags,
    required this.rewardXp,
    required this.rewardCoins,
    required this.nodeIds,
    this.requiresLevel = 1,
    this.isPremium = false,
    this.prerequisiteLessonIds = const <String>[],
  });

  final String id;
  final String slug;
  final String subject;
  final String title;
  final String subtitle;
  final String summary;
  final List<LessonSectionModel> sections;
  final List<LessonExampleModel> examples;
  final LessonSummaryModel summarySection;
  final int estimatedReadingMinutes;
  final String difficulty;
  final List<String> tags;
  final int rewardXp;
  final int rewardCoins;
  final List<String> nodeIds;
  final int requiresLevel;
  final bool isPremium;
  final List<String> prerequisiteLessonIds;

  LessonEntity toEntity({Set<String> completedSectionIds = const <String>{}}) {
    return LessonEntity(
      id: id,
      subject: subject,
      title: title,
      subtitle: subtitle,
      summary: summary,
      sections: sections
          .map(
            (LessonSectionModel s) => s.toEntity(
              isCompleted: completedSectionIds.contains(s.id),
            ),
          )
          .toList(growable: false),
      examples: examples
          .map((LessonExampleModel e) => e.toEntity())
          .toList(growable: false),
      summarySection: summarySection.toEntity(),
      estimatedReadingMinutes: estimatedReadingMinutes,
      difficulty: difficulty,
      tags: tags,
      rewardXp: rewardXp,
      rewardCoins: rewardCoins,
      requiresLevel: requiresLevel,
      isPremium: isPremium,
      prerequisiteLessonIds: prerequisiteLessonIds,
    );
  }
}