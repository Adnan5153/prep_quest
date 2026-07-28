import '../../domain/entities/search_item_entity.dart';
import '../../domain/enums/search_category.dart';

/// JSON-ready persistence shape for [SearchItemEntity].
class SearchItemModel {
  const SearchItemModel({
    required this.id,
    required this.category,
    required this.title,
    required this.subtitle,
    required this.routeName,
    this.secondaryRouteName,
    this.iconName,
    this.updatedAtIso,
  });

  factory SearchItemModel.fromEntity(SearchItemEntity entity) {
    return SearchItemModel(
      id: entity.id,
      category: entity.category,
      title: entity.title,
      subtitle: entity.subtitle,
      routeName: entity.routeName,
      secondaryRouteName: entity.secondaryRouteName,
      iconName: entity.iconName,
      updatedAtIso: entity.updatedAtIso,
    );
  }

  factory SearchItemModel.fromJson(Map<String, dynamic> json) {
    return SearchItemModel(
      id: (json['id'] as String?) ?? '',
      category: _parseCategory(json['category'] as String?),
      title: (json['title'] as String?) ?? '',
      subtitle: (json['subtitle'] as String?) ?? '',
      routeName: (json['routeName'] as String?) ?? '',
      secondaryRouteName: json['secondaryRouteName'] as String?,
      iconName: json['iconName'] as String?,
      updatedAtIso: json['updatedAtIso'] as String?,
    );
  }

  final String id;
  final SearchCategory category;
  final String title;
  final String subtitle;
  final String routeName;
  final String? secondaryRouteName;
  final String? iconName;
  final String? updatedAtIso;

  SearchItemEntity toEntity() => SearchItemEntity(
        id: id,
        category: category,
        title: title,
        subtitle: subtitle,
        routeName: routeName,
        secondaryRouteName: secondaryRouteName,
        iconName: iconName,
        updatedAtIso: updatedAtIso,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'category': category.name,
        'title': title,
        'subtitle': subtitle,
        'routeName': routeName,
        'secondaryRouteName': secondaryRouteName,
        'iconName': iconName,
        'updatedAtIso': updatedAtIso,
      };

  SearchItemModel copyWith({
    String? id,
    SearchCategory? category,
    String? title,
    String? subtitle,
    String? routeName,
    String? secondaryRouteName,
    bool clearSecondary = false,
    String? iconName,
    bool clearIcon = false,
    String? updatedAtIso,
    bool clearUpdatedAt = false,
  }) {
    return SearchItemModel(
      id: id ?? this.id,
      category: category ?? this.category,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      routeName: routeName ?? this.routeName,
      secondaryRouteName:
          clearSecondary ? null : (secondaryRouteName ?? this.secondaryRouteName),
      iconName: clearIcon ? null : (iconName ?? this.iconName),
      updatedAtIso:
          clearUpdatedAt ? null : (updatedAtIso ?? this.updatedAtIso),
    );
  }

  static SearchCategory _parseCategory(String? raw) {
    return SearchCategory.values.firstWhere(
      (SearchCategory c) => c.name == raw,
      orElse: () => SearchCategory.lessons,
    );
  }
}