import '../../domain/entities/trending_search_entity.dart';
import '../../domain/enums/search_category.dart';

/// JSON-ready persistence shape for [TrendingSearchEntity].
class TrendingSearchModel {
  const TrendingSearchModel({
    required this.label,
    required this.query,
    required this.rank,
    this.category,
  });

  factory TrendingSearchModel.fromEntity(TrendingSearchEntity entity) {
    return TrendingSearchModel(
      label: entity.label,
      query: entity.query,
      rank: entity.rank,
      category: entity.category,
    );
  }

  factory TrendingSearchModel.fromJson(Map<String, dynamic> json) {
    return TrendingSearchModel(
      label: (json['label'] as String?) ?? '',
      query: (json['query'] as String?) ?? '',
      rank: (json['rank'] as int?) ?? 0,
      category: _parseCategory(json['category'] as String?),
    );
  }

  final String label;
  final String query;
  final int rank;
  final SearchCategory? category;

  TrendingSearchEntity toEntity() => TrendingSearchEntity(
        label: label,
        query: query,
        rank: rank,
        category: category,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'label': label,
        'query': query,
        'rank': rank,
        'category': category?.name,
      };

  static SearchCategory? _parseCategory(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    return SearchCategory.values.firstWhere(
      (SearchCategory c) => c.name == raw,
      orElse: () => SearchCategory.lessons,
    );
  }
}