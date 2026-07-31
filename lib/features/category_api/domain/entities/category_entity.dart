/// Pure domain description of a single curriculum category.
///
/// A category is the canonical unit of the world map: one Firestore
/// document in the `categories` collection becomes one node on the
/// playground. The presentation layer translates [CategoryNodeKind]
/// into the legacy `WorldStepKind` used by `world_layout.dart`.
library;

/// Logical kind of category — what the player experiences when the
/// node is opened.
enum CategoryNodeKind {
  /// A regular lesson / topic node that drives into the quiz engine.
  lesson,

  /// A full-length BCS-style mock test.
  mockTest,

  /// The final boss gate (BCS Boss).
  bossGate,

  /// A bonus reward (chest) node — claim-only, no quiz.
  reward,

  /// A milestone (Library, Academy) that doubles as a building anchor.
  milestone,
}

class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.title,
    this.subtitle = '',
    required this.kind,
    this.order = 0,
    this.xpReward = 0,
    this.coinReward = 0,
    this.subject,
    this.iconName,
    this.quizId,
    this.prerequisiteCategoryIds = const <String>[],
    this.isRewardClaimed = false,
  });

  /// Firestore document id — also the playground node id.
  final String id;

  /// Display title for the node and category browser.
  final String title;

  /// Optional secondary line shown beneath the title.
  final String subtitle;

  /// Logical kind of category — drives routing + visual mapping.
  final CategoryNodeKind kind;

  /// Lower values render first in the playground layout.
  final int order;

  /// XP awarded on completion.
  final int xpReward;

  /// Coins awarded on completion.
  final int coinReward;

  /// Subject the category belongs to (Bangladesh Affairs / English /
  /// Mathematics / etc.).
  final String? subject;

  /// Optional icon identifier used by the playground visual mappers.
  final String? iconName;

  /// Quiz the node opens when tapped (when null the playground
  /// defaults to the lessons / mock / boss route).
  final String? quizId;

  /// Other category ids the player must finish before this one
  /// unlocks.
  final List<String> prerequisiteCategoryIds;

  /// True once the post-completion reward has been claimed.
  final bool isRewardClaimed;

  bool get isLesson => kind == CategoryNodeKind.lesson;
  bool get isMockTest => kind == CategoryNodeKind.mockTest;
  bool get isBossGate => kind == CategoryNodeKind.bossGate;
  bool get isReward => kind == CategoryNodeKind.reward;
  bool get isMilestone => kind == CategoryNodeKind.milestone;

  CategoryEntity copyWith({
    String? id,
    String? title,
    String? subtitle,
    CategoryNodeKind? kind,
    int? order,
    int? xpReward,
    int? coinReward,
    Object? subject = _sentinel,
    Object? iconName = _sentinel,
    Object? quizId = _sentinel,
    List<String>? prerequisiteCategoryIds,
    bool? isRewardClaimed,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      kind: kind ?? this.kind,
      order: order ?? this.order,
      xpReward: xpReward ?? this.xpReward,
      coinReward: coinReward ?? this.coinReward,
      subject: identical(subject, _sentinel) ? this.subject : subject as String?,
      iconName:
          identical(iconName, _sentinel) ? this.iconName : iconName as String?,
      quizId: identical(quizId, _sentinel) ? this.quizId : quizId as String?,
      prerequisiteCategoryIds:
          prerequisiteCategoryIds ?? this.prerequisiteCategoryIds,
      isRewardClaimed: isRewardClaimed ?? this.isRewardClaimed,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryEntity &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.kind == kind &&
        other.order == order &&
        other.xpReward == xpReward &&
        other.coinReward == coinReward &&
        other.subject == subject &&
        other.iconName == iconName &&
        other.quizId == quizId &&
        other.prerequisiteCategoryIds == prerequisiteCategoryIds &&
        other.isRewardClaimed == isRewardClaimed;
  }

  @override
  int get hashCode => Object.hash(
        id,
        title,
        subtitle,
        kind,
        order,
        xpReward,
        coinReward,
        subject,
        iconName,
        quizId,
        prerequisiteCategoryIds,
        isRewardClaimed,
      );
}

const Object _sentinel = Object();