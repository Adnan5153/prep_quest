import '../../domain/entities/quiz_category_entity.dart';

/// Data-layer model for a quiz category served by the Quiz Hub API.
///
/// Categories group quiz questions together (e.g. "General Knowledge",
/// "Bangladesh Affairs") and are persisted by the admin console.
class QuizCategoryModel {
  const QuizCategoryModel({
    required this.id,
    required this.name,
    this.description,
  });

  final String id;
  final String name;
  final String? description;

  QuizCategoryEntity toEntity() {
    return QuizCategoryEntity(
      id: id,
      name: name,
      description: description,
    );
  }

  factory QuizCategoryModel.fromApiResponse(Map<String, dynamic> response) {
    // The Quiz Hub API sometimes returns the category inside a
    // `data` envelope and sometimes as a bare object. Unwrap
    // transparently.
    final Map<String, dynamic>? inner =
        response['data'] is Map<String, dynamic>
            ? response['data'] as Map<String, dynamic>
            : null;
    final Map<String, dynamic> source = inner ?? response;
    final String name = (source['name'] as String? ?? '').trim();
    return QuizCategoryModel(
      id: '${source['id'] ?? ''}',
      name: name,
      description: source['description'] as String?,
    );
  }

  factory QuizCategoryModel.fromJson(Map<String, dynamic> json) {
    final String name = (json['name'] as String? ?? '').trim();
    return QuizCategoryModel(
      id: '${json['id'] ?? ''}',
      name: name,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> out = <String, dynamic>{'name': name};
    if (description != null) out['description'] = description;
    return out;
  }
}
