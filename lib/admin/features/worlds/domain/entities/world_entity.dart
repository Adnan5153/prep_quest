import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class WorldEntity {
  const WorldEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.examVertical,
    required this.ownerId,
    required this.tags,
    required this.status,
    required this.activeVersionId,
    required this.createdAt,
    required this.updatedAt,
    this.description,
    this.archivedAt,
    this.coverAssetId,
  });

  final String id;
  final String slug;
  final String displayName;
  final ExamVertical examVertical;
  final String ownerId;
  final List<String> tags;
  final WorkflowState status;
  final String? activeVersionId;
  final String? description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? archivedAt;
  final String? coverAssetId;

  bool get hasPublishedVersion => activeVersionId != null;
  bool get isEditable =>
      status == WorkflowState.draft || status == WorkflowState.inReview;

  WorldEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    ExamVertical? examVertical,
    String? ownerId,
    List<String>? tags,
    WorkflowState? status,
    String? activeVersionId,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? archivedAt,
    String? coverAssetId,
  }) {
    return WorldEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      examVertical: examVertical ?? this.examVertical,
      ownerId: ownerId ?? this.ownerId,
      tags: tags ?? this.tags,
      status: status ?? this.status,
      activeVersionId: activeVersionId ?? this.activeVersionId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      archivedAt: archivedAt ?? this.archivedAt,
      coverAssetId: coverAssetId ?? this.coverAssetId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'slug': slug,
        'displayName': displayName,
        'examVertical': examVertical.code,
        'ownerId': ownerId,
        'tags': tags,
        'status': status.wire,
        'activeVersionId': activeVersionId,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'archivedAt': archivedAt?.toIso8601String(),
        'coverAssetId': coverAssetId,
      };

  factory WorldEntity.fromJson(Map<String, dynamic> json) => WorldEntity(
        id: json['id'] as String,
        slug: json['slug'] as String,
        displayName: json['displayName'] as String,
        examVertical:
            ExamVertical.fromCode(json['examVertical'] as String),
        ownerId: json['ownerId'] as String,
        tags: (json['tags'] as List<dynamic>)
            .map((dynamic e) => e as String)
            .toList(),
        status: WorkflowState.fromWire(json['status'] as String),
        activeVersionId: json['activeVersionId'] as String?,
        description: json['description'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
        archivedAt: json['archivedAt'] == null
            ? null
            : DateTime.parse(json['archivedAt'] as String),
        coverAssetId: json['coverAssetId'] as String?,
      );
}
