import '../../domain/entities/recent_search_entity.dart';
import '../../domain/enums/search_category.dart';

/// JSON-ready persistence shape for [RecentSearchEntity].
class RecentSearchModel {
  const RecentSearchModel({
    required this.query,
    required this.queriedAtIso,
    this.categoryAtTime,
  });

  factory RecentSearchModel.fromEntity(RecentSearchEntity entity) {
    return RecentSearchModel(
      query: entity.query,
      queriedAtIso: entity.queriedAtIso,
      categoryAtTime: entity.categoryAtTime,
    );
  }

  factory RecentSearchModel.fromJson(Map<String, dynamic> json) {
    return RecentSearchModel(
      query: (json['query'] as String?) ?? '',
      queriedAtIso: (json['queriedAtIso'] as String?) ?? '',
      categoryAtTime: _parseCategory(json['categoryAtTime'] as String?),
    );
  }

  final String query;
  final String queriedAtIso;
  final SearchCategory? categoryAtTime;

  RecentSearchEntity toEntity() => RecentSearchEntity(
        query: query,
        queriedAtIso: queriedAtIso,
        categoryAtTime: categoryAtTime,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'query': query,
        'queriedAtIso': queriedAtIso,
        'categoryAtTime': categoryAtTime?.name,
      };

  RecentSearchModel copyWith({
    String? query,
    String? queriedAtIso,
    SearchCategory? categoryAtTime,
    bool clearCategory = false,
  }) {
    return RecentSearchModel(
      query: query ?? this.query,
      queriedAtIso: queriedAtIso ?? this.queriedAtIso,
      categoryAtTime:
          clearCategory ? null : (categoryAtTime ?? this.categoryAtTime),
    );
  }

  static SearchCategory? _parseCategory(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return SearchCategory.values.firstWhere(
      (SearchCategory c) => c.name == raw,
      orElse: () => SearchCategory.lessons,
    );
  }
}