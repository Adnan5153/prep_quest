import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class AssetVersion {
  const AssetVersion({
    required this.id,
    required this.version,
    required this.url,
    required this.sizeBytes,
    required this.hash,
    required this.createdAt,
  });

  final String id;
  final int version;
  final String url;
  final int sizeBytes;
  final String hash;
  final DateTime createdAt;
}

@immutable
class AssetEntity {
  const AssetEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.kind,
    required this.mimeType,
    required this.url,
    required this.sizeBytes,
    required this.status,
    required this.tags,
    required this.versions,
    required this.uploadedBy,
    required this.uploadedAt,
    this.width,
    this.height,
    this.altText,
    this.usedInWorldIds = const <String>[],
    this.usedInThemeIds = const <String>[],
  });

  final String id;
  final String slug;
  final String displayName;
  final AssetKind kind;
  final String mimeType;
  final String url;
  final int sizeBytes;
  final int? width;
  final int? height;
  final String? altText;
  final List<String> tags;
  final List<AssetVersion> versions;
  final List<String> usedInWorldIds;
  final List<String> usedInThemeIds;
  final WorkflowState status;
  final String uploadedBy;
  final DateTime uploadedAt;

  bool get isImage => kind == AssetKind.image;
  bool get isAnimation => kind == AssetKind.lottie;
  bool get isAudio => kind == AssetKind.audio;
  bool get isVideo => kind == AssetKind.video;

  AssetEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    AssetKind? kind,
    String? mimeType,
    String? url,
    int? sizeBytes,
    int? width,
    int? height,
    String? altText,
    List<String>? tags,
    List<AssetVersion>? versions,
    List<String>? usedInWorldIds,
    List<String>? usedInThemeIds,
    WorkflowState? status,
    String? uploadedBy,
    DateTime? uploadedAt,
  }) {
    return AssetEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      kind: kind ?? this.kind,
      mimeType: mimeType ?? this.mimeType,
      url: url ?? this.url,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      width: width ?? this.width,
      height: height ?? this.height,
      altText: altText ?? this.altText,
      tags: tags ?? this.tags,
      versions: versions ?? this.versions,
      usedInWorldIds: usedInWorldIds ?? this.usedInWorldIds,
      usedInThemeIds: usedInThemeIds ?? this.usedInThemeIds,
      status: status ?? this.status,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
