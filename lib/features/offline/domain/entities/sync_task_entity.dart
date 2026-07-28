import 'package:flutter/foundation.dart';

import '../enums/offline_content_type.dart';

/// Source feature that produced the queued sync action.
enum SyncSource { quiz, gamification, bookmarks, notes, aiHistory }

/// What kind of payload the sync task carries.
enum SyncPayloadType { quizAttempt, xpEvent, coinEvent, streakEvent, bookmark, note, aiMessage }

/// A queued action waiting for connectivity. The sync engine drains
/// the queue when the network returns.
@immutable
class SyncTaskEntity {
  const SyncTaskEntity({
    required this.id,
    required this.source,
    required this.payloadType,
    required this.payload,
    required this.createdAtIso,
    required this.status,
    this.attempts = 0,
    this.lastErrorMessage,
  });

  final String id;
  final SyncSource source;
  final SyncPayloadType payloadType;
  final Map<String, dynamic> payload;
  final String createdAtIso;
  final SyncStatus status;
  final int attempts;
  final String? lastErrorMessage;

  SyncTaskEntity copyWith({
    SyncStatus? status,
    int? attempts,
    String? lastErrorMessage,
  }) {
    return SyncTaskEntity(
      id: id,
      source: source,
      payloadType: payloadType,
      payload: payload,
      createdAtIso: createdAtIso,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      lastErrorMessage: lastErrorMessage ?? this.lastErrorMessage,
    );
  }
}
