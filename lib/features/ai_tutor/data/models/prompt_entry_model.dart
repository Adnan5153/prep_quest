import '../../domain/entities/conversation.dart';
import 'ai_response_model.dart';

class PromptEntryModel {
  const PromptEntryModel({
    required this.id,
    required this.text,
    required this.createdAtIso,
    required this.response,
    this.category,
    this.tags = const <String>[],
    this.isFavorite = false,
  });

  final String id;
  final String text;
  final String createdAtIso;
  final AIResponseModel response;
  final String? category;
  final List<String> tags;
  final bool isFavorite;

  PromptEntry toEntity() {
    return PromptEntry(
      id: id,
      text: text,
      createdAt: DateTime.parse(createdAtIso),
      response: response.toEntity(),
      category: category,
      tags: List<String>.unmodifiable(tags),
      isFavorite: isFavorite,
    );
  }

  PromptEntryModel copyWith({
    String? id,
    String? text,
    String? createdAtIso,
    AIResponseModel? response,
    String? category,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return PromptEntryModel(
      id: id ?? this.id,
      text: text ?? this.text,
      createdAtIso: createdAtIso ?? this.createdAtIso,
      response: response ?? this.response,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}