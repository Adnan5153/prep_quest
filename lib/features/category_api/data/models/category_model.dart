import '../../domain/entities/category_entity.dart';

/// JSON-ready representation of [CategoryEntity].
///
/// Used as the transport between the Firestore data source and the
/// domain layer. `kind` is persisted as a stable string (`lesson`,
/// `mockTest`, `bossGate`, `reward`, `milestone`) so renames in code
/// don't break documents already in the wild.
class CategoryModel {
  const CategoryModel({
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

  /// Optional secondary line shown beneath the title in tooltips and
  /// the playground node label.
  final String subtitle;

  /// Stable kind identifier (see [CategoryNodeKind]).
  final String kind;

  /// Lower values render first in the playground layout.
  final int order;

  /// XP awarded on completion.
  final int xpReward;

  /// Coins awarded on completion.
  final int coinReward;

  /// Subject the category belongs to (Bangladesh Affairs / English /
  /// Mathematics / etc.). Optional — null for global milestones.
  final String? subject;

  /// Optional icon identifier used by the playground visual mappers.
  final String? iconName;

  /// Quiz the node opens when tapped (when null the playground
  /// defaults to the lessons / mock / boss route).
  final String? quizId;

  /// Other category ids the player must finish before this one
  /// unlocks. Translated to `WorldStep` lock state at the presentation
  /// layer.
  final List<String> prerequisiteCategoryIds;

  /// True once the post-completion reward has been claimed. Stored
  /// alongside the category so the UI can render a finished node
  /// without an additional round-trip.
  final bool isRewardClaimed;

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      kind: CategoryNodeKindX.fromId(kind),
      order: order,
      xpReward: xpReward,
      coinReward: coinReward,
      subject: subject,
      iconName: iconName,
      quizId: quizId,
      prerequisiteCategoryIds:
          List<String>.unmodifiable(prerequisiteCategoryIds),
      isRewardClaimed: isRewardClaimed,
    );
  }

  factory CategoryModel.fromEntity(CategoryEntity entity) {
    return CategoryModel(
      id: entity.id,
      title: entity.title,
      subtitle: entity.subtitle,
      kind: entity.kind.id,
      order: entity.order,
      xpReward: entity.xpReward,
      coinReward: entity.coinReward,
      subject: entity.subject,
      iconName: entity.iconName,
      quizId: entity.quizId,
      prerequisiteCategoryIds:
          List<String>.unmodifiable(entity.prerequisiteCategoryIds),
      isRewardClaimed: entity.isRewardClaimed,
    );
  }

  factory CategoryModel.fromMap(String id, Map<String, dynamic> map) {
    return CategoryModel(
      id: id,
      title: map['title'] as String? ?? '',
      subtitle: map['subtitle'] as String? ?? '',
      kind: (map['kind'] as String?) ?? 'lesson',
      order: (map['order'] as num?)?.toInt() ?? 0,
      xpReward: (map['xpReward'] as num?)?.toInt() ?? 0,
      coinReward: (map['coinReward'] as num?)?.toInt() ?? 0,
      subject: map['subject'] as String?,
      iconName: map['iconName'] as String?,
      quizId: map['quizId'] as String?,
      prerequisiteCategoryIds: ((map['prerequisiteCategoryIds'] as List<dynamic>?) ??
              const <dynamic>[])
          .whereType<String>()
          .toList(growable: false),
      isRewardClaimed: map['isRewardClaimed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'subtitle': subtitle,
      'kind': kind,
      'order': order,
      'xpReward': xpReward,
      'coinReward': coinReward,
      'subject': subject,
      'iconName': iconName,
      'quizId': quizId,
      'prerequisiteCategoryIds': prerequisiteCategoryIds,
      'isRewardClaimed': isRewardClaimed,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? kind,
    int? order,
    int? xpReward,
    int? coinReward,
    Object? subject = _sentinel,
    Object? iconName = _sentinel,
    Object? quizId = _sentinel,
    List<String>? prerequisiteCategoryIds,
    bool? isRewardClaimed,
  }) {
    return CategoryModel(
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
}

const Object _sentinel = Object();

extension CategoryNodeKindX on CategoryNodeKind {
  String get id {
    switch (this) {
      case CategoryNodeKind.lesson:
        return 'lesson';
      case CategoryNodeKind.mockTest:
        return 'mockTest';
      case CategoryNodeKind.bossGate:
        return 'bossGate';
      case CategoryNodeKind.reward:
        return 'reward';
      case CategoryNodeKind.milestone:
        return 'milestone';
    }
  }

  static CategoryNodeKind fromId(String? value) {
    switch (value) {
      case 'lesson':
        return CategoryNodeKind.lesson;
      case 'mockTest':
        return CategoryNodeKind.mockTest;
      case 'bossGate':
        return CategoryNodeKind.bossGate;
      case 'reward':
        return CategoryNodeKind.reward;
      case 'milestone':
      default:
        return CategoryNodeKind.milestone;
    }
  }
}