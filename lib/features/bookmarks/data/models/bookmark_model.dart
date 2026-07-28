import '../../domain/entities/bookmark_entity.dart';
import '../../domain/enums/bookmark_item_type.dart';

/// JSON-ready persistence shape for [BookmarkEntity].
class BookmarkModel {
  const BookmarkModel({
    required this.id,
    required this.itemType,
    required this.itemId,
    required this.title,
    required this.createdAtIso,
    required this.updatedAtIso,
    required this.sourceFeature,
    required this.tags,
    required this.routeName,
    required this.routeParams,
    this.subtitle,
    this.thumbnailIconKey,
  });

  factory BookmarkModel.fromEntity(BookmarkEntity entity) {
    return BookmarkModel(
      id: entity.id,
      itemType: entity.itemType,
      itemId: entity.itemId,
      title: entity.title,
      subtitle: entity.subtitle,
      thumbnailIconKey: entity.thumbnailIconKey,
      createdAtIso: entity.createdAt?.toIso8601String() ?? '',
      updatedAtIso: entity.updatedAt?.toIso8601String() ?? '',
      sourceFeature: entity.sourceFeature,
      tags: entity.tags,
      routeName: entity.routeName,
      routeParams: entity.routeParams,
    );
  }

  factory BookmarkModel.fromJson(Map<String, dynamic> json) {
    final String? typeName = json['itemType'] as String?;
    final BookmarkItemType type = BookmarkItemType.values.firstWhere(
      (BookmarkItemType t) => t.name == typeName,
      orElse: () => BookmarkItemType.note,
    );
    return BookmarkModel(
      id: (json['id'] as String?) ?? '',
      itemType: type,
      itemId: (json['itemId'] as String?) ?? '',
      title: (json['title'] as String?) ?? '',
      subtitle: json['subtitle'] as String?,
      thumbnailIconKey: json['thumbnailIconKey'] as String?,
      createdAtIso: (json['createdAtIso'] as String?) ?? '',
      updatedAtIso: (json['updatedAtIso'] as String?) ?? '',
      sourceFeature: (json['sourceFeature'] as String?) ?? '',
      tags: (json['tags'] as List<dynamic>?)
              ?.map((dynamic e) => e.toString())
              .toList(growable: false) ??
          const <String>[],
      routeName: (json['routeName'] as String?) ?? '',
      routeParams: (json['routeParams'] as Map<String, dynamic>?)
              ?.map((String key, dynamic value) => MapEntry<String, String>(key, value?.toString() ?? '')) ??
          const <String, String>{},
    );
  }

  final String id;
  final BookmarkItemType itemType;
  final String itemId;
  final String title;
  final String? subtitle;
  final String? thumbnailIconKey;
  final String createdAtIso;
  final String updatedAtIso;
  final String sourceFeature;
  final List<String> tags;
  final String routeName;
  final Map<String, String> routeParams;

  BookmarkEntity toEntity() => BookmarkEntity(
        id: id,
        itemType: itemType,
        itemId: itemId,
        title: title,
        subtitle: subtitle,
        thumbnailIconKey: thumbnailIconKey,
        createdAt: createdAtIso.isEmpty ? null : DateTime.tryParse(createdAtIso),
        updatedAt: updatedAtIso.isEmpty ? null : DateTime.tryParse(updatedAtIso),
        sourceFeature: sourceFeature,
        tags: tags,
        routeName: routeName,
        routeParams: routeParams,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'itemType': itemType.name,
        'itemId': itemId,
        'title': title,
        'subtitle': subtitle,
        'thumbnailIconKey': thumbnailIconKey,
        'createdAtIso': createdAtIso,
        'updatedAtIso': updatedAtIso,
        'sourceFeature': sourceFeature,
        'tags': tags,
        'routeName': routeName,
        'routeParams': routeParams,
      };

  BookmarkModel copyWith({
    String? id,
    BookmarkItemType? itemType,
    String? itemId,
    String? title,
    String? subtitle,
    bool clearSubtitle = false,
    String? thumbnailIconKey,
    bool clearThumbnailIconKey = false,
    String? createdAtIso,
    String? updatedAtIso,
    String? sourceFeature,
    List<String>? tags,
    String? routeName,
    Map<String, String>? routeParams,
  }) =>
      BookmarkModel(
        id: id ?? this.id,
        itemType: itemType ?? this.itemType,
        itemId: itemId ?? this.itemId,
        title: title ?? this.title,
        subtitle: clearSubtitle ? null : (subtitle ?? this.subtitle),
        thumbnailIconKey: clearThumbnailIconKey
            ? null
            : (thumbnailIconKey ?? this.thumbnailIconKey),
        createdAtIso: createdAtIso ?? this.createdAtIso,
        updatedAtIso: updatedAtIso ?? this.updatedAtIso,
        sourceFeature: sourceFeature ?? this.sourceFeature,
        tags: tags ?? this.tags,
        routeName: routeName ?? this.routeName,
        routeParams: routeParams ?? this.routeParams,
      );
}