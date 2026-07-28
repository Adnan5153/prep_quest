import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

enum EventLifecycle { scheduled, live, ended, cancelled }

@immutable
class EventEntity {
  const EventEntity({
    required this.id,
    required this.slug,
    required this.displayName,
    required this.kind,
    required this.startsAt,
    required this.endsAt,
    required this.scope,
    required this.payload,
    required this.lifecycle,
    required this.updatedAt,
    this.bannerAssetId,
    this.summary,
  });

  final String id;
  final String slug;
  final String displayName;
  final EventKind kind;
  final DateTime startsAt;
  final DateTime endsAt;
  final Map<String, dynamic> scope;
  final Map<String, dynamic> payload;
  final EventLifecycle lifecycle;
  final DateTime updatedAt;
  final String? bannerAssetId;
  final String? summary;

  bool get isLive {
    final DateTime now = DateTime.now();
    return lifecycle == EventLifecycle.live ||
        (lifecycle == EventLifecycle.scheduled &&
            now.isAfter(startsAt) &&
            now.isBefore(endsAt));
  }

  EventEntity copyWith({
    String? id,
    String? slug,
    String? displayName,
    EventKind? kind,
    DateTime? startsAt,
    DateTime? endsAt,
    Map<String, dynamic>? scope,
    Map<String, dynamic>? payload,
    EventLifecycle? lifecycle,
    DateTime? updatedAt,
    String? bannerAssetId,
    String? summary,
  }) {
    return EventEntity(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      displayName: displayName ?? this.displayName,
      kind: kind ?? this.kind,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
      scope: scope ?? this.scope,
      payload: payload ?? this.payload,
      lifecycle: lifecycle ?? this.lifecycle,
      updatedAt: updatedAt ?? this.updatedAt,
      bannerAssetId: bannerAssetId ?? this.bannerAssetId,
      summary: summary ?? this.summary,
    );
  }
}
