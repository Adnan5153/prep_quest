import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class DiffSummaryEntity {
  const DiffSummaryEntity({
    required this.addedNodeIds,
    required this.removedNodeIds,
    required this.modifiedNodeIds,
    required this.addedDecorationIds,
    required this.modifiedDecorationIds,
    required this.addedPathIds,
    required this.modifiedPathIds,
    required this.totalChanges,
  });

  final List<String> addedNodeIds;
  final List<String> removedNodeIds;
  final List<String> modifiedNodeIds;
  final List<String> addedDecorationIds;
  final List<String> modifiedDecorationIds;
  final List<String> addedPathIds;
  final List<String> modifiedPathIds;
  final int totalChanges;

  static const DiffSummaryEntity empty = DiffSummaryEntity(
    addedNodeIds: <String>[],
    removedNodeIds: <String>[],
    modifiedNodeIds: <String>[],
    addedDecorationIds: <String>[],
    modifiedDecorationIds: <String>[],
    addedPathIds: <String>[],
    modifiedPathIds: <String>[],
    totalChanges: 0,
  );
}

@immutable
class WorldVersionEntity {
  const WorldVersionEntity({
    required this.id,
    required this.worldId,
    required this.parentId,
    required this.status,
    required this.schemaVersion,
    required this.rendererContractVersion,
    required this.payloadHash,
    required this.payload,
    required this.diffSummary,
    required this.releaseNotes,
    required this.createdBy,
    required this.createdAt,
    this.publishedBy,
    this.publishedAt,
    this.archivedAt,
    this.branchName,
  });

  final String id;
  final String worldId;
  final String? parentId;
  final WorkflowState status;
  final String schemaVersion;
  final String rendererContractVersion;
  final String payloadHash;
  final Map<String, dynamic> payload;
  final DiffSummaryEntity diffSummary;
  final String releaseNotes;
  final String createdBy;
  final DateTime createdAt;
  final String? publishedBy;
  final DateTime? publishedAt;
  final DateTime? archivedAt;
  final String? branchName;

  bool get isPublished => status == WorkflowState.published;
  bool get isImmutable =>
      status == WorkflowState.published || status == WorkflowState.archived;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'worldId': worldId,
        'parentId': parentId,
        'status': status.wire,
        'schemaVersion': schemaVersion,
        'rendererContractVersion': rendererContractVersion,
        'payloadHash': payloadHash,
        'payload': payload,
        'diffSummary': <String, dynamic>{
          'addedNodeIds': diffSummary.addedNodeIds,
          'removedNodeIds': diffSummary.removedNodeIds,
          'modifiedNodeIds': diffSummary.modifiedNodeIds,
          'addedDecorationIds': diffSummary.addedDecorationIds,
          'modifiedDecorationIds': diffSummary.modifiedDecorationIds,
          'addedPathIds': diffSummary.addedPathIds,
          'modifiedPathIds': diffSummary.modifiedPathIds,
          'totalChanges': diffSummary.totalChanges,
        },
        'releaseNotes': releaseNotes,
        'createdBy': createdBy,
        'createdAt': createdAt.toIso8601String(),
        'publishedBy': publishedBy,
        'publishedAt': publishedAt?.toIso8601String(),
        'archivedAt': archivedAt?.toIso8601String(),
        'branchName': branchName,
      };

  factory WorldVersionEntity.fromJson(Map<String, dynamic> json) =>
      WorldVersionEntity(
        id: json['id'] as String,
        worldId: json['worldId'] as String,
        parentId: json['parentId'] as String?,
        status: WorkflowState.fromWire(json['status'] as String),
        schemaVersion: json['schemaVersion'] as String,
        rendererContractVersion: json['rendererContractVersion'] as String,
        payloadHash: json['payloadHash'] as String,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        diffSummary: _diffFromJson(json['diffSummary']),
        releaseNotes: json['releaseNotes'] as String? ?? '',
        createdBy: json['createdBy'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        publishedBy: json['publishedBy'] as String?,
        publishedAt: json['publishedAt'] == null
            ? null
            : DateTime.parse(json['publishedAt'] as String),
        archivedAt: json['archivedAt'] == null
            ? null
            : DateTime.parse(json['archivedAt'] as String),
        branchName: json['branchName'] as String?,
      );

  static DiffSummaryEntity _diffFromJson(dynamic raw) {
    if (raw == null) return DiffSummaryEntity.empty;
    final Map<String, dynamic> map = Map<String, dynamic>.from(raw as Map);
    List<String> readList(String key) =>
        (map[key] as List<dynamic>?)
                ?.map((dynamic e) => e as String)
                .toList() ??
            const <String>[];
    return DiffSummaryEntity(
      addedNodeIds: readList('addedNodeIds'),
      removedNodeIds: readList('removedNodeIds'),
      modifiedNodeIds: readList('modifiedNodeIds'),
      addedDecorationIds: readList('addedDecorationIds'),
      modifiedDecorationIds: readList('modifiedDecorationIds'),
      addedPathIds: readList('addedPathIds'),
      modifiedPathIds: readList('modifiedPathIds'),
      totalChanges:
          (map['totalChanges'] as num? ?? 0).toInt(),
    );
  }
}
