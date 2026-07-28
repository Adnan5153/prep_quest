import 'package:flutter/foundation.dart';

import '../../../../shared/enums/workflow_state.dart';

@immutable
class AuditEntry {
  const AuditEntry({
    required this.id,
    required this.actorId,
    required this.actorEmail,
    required this.action,
    required this.resourceType,
    required this.resourceId,
    required this.beforeHash,
    required this.afterHash,
    required this.reason,
    required this.ip,
    required this.userAgent,
    required this.correlationId,
    required this.timestamp,
    this.signature,
  });

  final String id;
  final String actorId;
  final String actorEmail;
  final AuditAction action;
  final String resourceType;
  final String resourceId;
  final String beforeHash;
  final String afterHash;
  final String reason;
  final String ip;
  final String userAgent;
  final String correlationId;
  final DateTime timestamp;
  final String? signature;

  String get summary => '$action · ${resourceType.split('.').last}';
}
