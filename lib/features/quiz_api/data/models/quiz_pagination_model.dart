/// Pagination envelope returned by every paginated Quiz Hub endpoint.
///
/// Mirrors the shape of `paginate()` from the Quiz Hub backend so the
/// data layer doesn't have to know the exact transport.
class QuizPaginationModel {
  const QuizPaginationModel({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory QuizPaginationModel.fromJson(Map<String, dynamic> json) {
    return QuizPaginationModel(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 20,
      totalItems: (json['totalItems'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      hasNext: json['hasNext'] as bool? ?? false,
      hasPrevious: json['hasPrevious'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'page': page,
      'limit': limit,
      'totalItems': totalItems,
      'totalPages': totalPages,
      'hasNext': hasNext,
      'hasPrevious': hasPrevious,
    };
  }
}
