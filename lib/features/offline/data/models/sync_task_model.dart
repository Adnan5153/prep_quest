import '../../domain/entities/sync_task_entity.dart';
import '../../domain/enums/offline_content_type.dart';

class SyncTaskModel {
  const SyncTaskModel({
    required this.id,
    required this.sourceName,
    required this.payloadTypeName,
    required this.payload,
    required this.createdAtIso,
    required this.statusName,
    this.attempts = 0,
    this.lastErrorMessage,
  });

  factory SyncTaskModel.fromMap(Map<String, dynamic> map) {
    return SyncTaskModel(
      id: map['id'] as String,
      sourceName: map['source'] as String? ?? 'quiz',
      payloadTypeName: map['payload_type'] as String? ?? 'quizAttempt',
      payload: Map<String, dynamic>.from(
        (map['payload'] as Map?) ?? const <String, dynamic>{},
      ),
      createdAtIso: (map['created_at_iso'] as String?) ?? '',
      statusName: map['status'] as String? ?? 'pending',
      attempts: (map['attempts'] as num?)?.toInt() ?? 0,
      lastErrorMessage: map['last_error_message'] as String?,
    );
  }

  final String id;
  final String sourceName;
  final String payloadTypeName;
  final Map<String, dynamic> payload;
  final String createdAtIso;
  final String statusName;
  final int attempts;
  final String? lastErrorMessage;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'source': sourceName,
      'payload_type': payloadTypeName,
      'payload': payload,
      'created_at_iso': createdAtIso,
      'status': statusName,
      'attempts': attempts,
      'last_error_message': lastErrorMessage,
    };
  }

  SyncTaskEntity toEntity() {
    return SyncTaskEntity(
      id: id,
      source: _parseSource(sourceName),
      payloadType: _parsePayloadType(payloadTypeName),
      payload: payload,
      createdAtIso: createdAtIso,
      status: _parseStatus(statusName),
      attempts: attempts,
      lastErrorMessage: lastErrorMessage,
    );
  }

  static SyncSource _parseSource(String raw) {
    return SyncSource.values.firstWhere(
      (SyncSource s) => s.name == raw,
      orElse: () => SyncSource.quiz,
    );
  }

  static SyncPayloadType _parsePayloadType(String raw) {
    return SyncPayloadType.values.firstWhere(
      (SyncPayloadType p) => p.name == raw,
      orElse: () => SyncPayloadType.quizAttempt,
    );
  }

  static SyncStatus _parseStatus(String raw) {
    return SyncStatus.values.firstWhere(
      (SyncStatus s) => s.name == raw,
      orElse: () => SyncStatus.pending,
    );
  }
}