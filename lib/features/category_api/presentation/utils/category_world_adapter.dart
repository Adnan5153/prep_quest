import '../../../playground/presentation/utils/world_layout.dart'
    show WorldStep, WorldStepKind;
import '../../domain/entities/category_entity.dart';

/// Translates API-driven [CategoryEntity]s into the presentation-only
/// [WorldStep]s consumed by `world_layout.dart`.
///
/// The playground layout is a procedural pipeline that accepts a
/// `List<WorldStep>`; the category API exposes dynamically-curated
/// entities. This adapter keeps the two decoupled so adding new
/// category kinds only changes the mapping table here, not the
/// layout engine.
class CategoryWorldAdapter {
  const CategoryWorldAdapter._();

  /// `mockTest` intentionally collapses to `regular` so the playground
  /// layout pipeline doesn't need to learn a new `WorldStepKind`. Routing
  /// for `mockTest` is identical to `lesson` (both → `quizOverview`) per
  /// `docs/backendconnection/backend.mermaid` H5.
  static WorldStepKind kindFor(CategoryEntity category) {
    switch (category.kind) {
      case CategoryNodeKind.lesson:
      case CategoryNodeKind.mockTest:
        return WorldStepKind.regular;
      case CategoryNodeKind.reward:
        return WorldStepKind.reward;
      case CategoryNodeKind.milestone:
        return WorldStepKind.milestone;
      case CategoryNodeKind.bossGate:
        return WorldStepKind.boss;
    }
  }

  /// Offline fallback steps used by the playground layout when both
  /// the Firestore `categories` stream and the Quiz Hub REST list
  /// resolve to empty. Subtitle strings mirror
  /// `MockCategoryRemoteDataSource._seedCategories()` in
  /// `lib/features/category_api/data/datasources/category_remote_datasource.dart`
  /// so the offline rendering has a single canonical definition.
  static const List<WorldStep> fallbackSteps = <WorldStep>[
    WorldStep(
      kind: WorldStepKind.regular,
      subtitle: 'History, geography, civics',
      isCompleted: true,
    ),
    WorldStep(
      kind: WorldStepKind.regular,
      subtitle: 'Tenses, articles, prepositions',
      isCompleted: true,
    ),
    WorldStep(kind: WorldStepKind.regular, subtitle: 'Arithmetic + algebra'),
    WorldStep(kind: WorldStepKind.milestone, subtitle: 'Reference materials'),
    WorldStep(kind: WorldStepKind.reward, subtitle: 'Open every day'),
    WorldStep(kind: WorldStepKind.regular, subtitle: 'Full-length BCS-style test'),
    WorldStep(kind: WorldStepKind.boss, subtitle: 'Final boss gate'),
  ];

  static List<WorldStep> toWorldSteps(
    List<CategoryEntity> categories, {
    Set<String> completedIds = const <String>{},
  }) {
    final List<CategoryEntity> sorted = List<CategoryEntity>.of(categories)
      ..sort((a, b) => a.order.compareTo(b.order));
    return sorted
        .map(
          (category) => WorldStep(
            kind: kindFor(category),
            subtitle: category.subtitle.isNotEmpty
                ? category.subtitle
                : category.title,
            isCompleted: completedIds.contains(category.id),
          ),
        )
        .toList(growable: false);
  }
}