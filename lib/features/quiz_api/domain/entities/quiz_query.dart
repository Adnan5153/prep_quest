/// Query parameters for [QuizApiRepository.listCategories].
class QuizCategoryQuery {
  const QuizCategoryQuery({
    this.page = 1,
    this.limit = 20,
    this.search,
  });

  final int page;
  final int limit;
  final String? search;

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> out = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search!.isNotEmpty) {
      out['search'] = search;
    }
    return out;
  }
}

/// Query parameters for [QuizApiRepository.listQuestionsForCategory].
class QuizQuestionQuery {
  const QuizQuestionQuery({
    this.page = 1,
    this.limit = 20,
    this.search,
  });

  final int page;
  final int limit;
  final String? search;

  Map<String, dynamic> toQueryParameters() {
    final Map<String, dynamic> out = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (search != null && search!.isNotEmpty) {
      out['search'] = search;
    }
    return out;
  }
}
