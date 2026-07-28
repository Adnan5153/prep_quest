import '../../../worlds/domain/entities/world_entity.dart';
import '../../../worlds/domain/entities/world_version_entity.dart';
import '../entities/audit_entry.dart';

abstract class AuditRepository {
  Future<List<AuditEntry>> recent({int limit = 100, String? resourceType});
  Future<AuditEntry> record(AuditEntry entry);
  Stream<List<AuditEntry>> watchFeed({int limit = 50});

  Future<AuditEntry> recordWorldCreated({
    required WorldEntity world,
    required String actorId,
  });

  Future<AuditEntry> recordWorldPublished({
    required WorldVersionEntity version,
    required String actorId,
  });

  Future<AuditEntry> recordRollback({
    required String world,
    required String versionId,
    required String actorId,
    required String reason,
  });
}
