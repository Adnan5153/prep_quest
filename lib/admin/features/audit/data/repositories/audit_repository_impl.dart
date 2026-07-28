import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/audit_entry.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../../worlds/domain/entities/world_entity.dart';
import '../../../worlds/domain/entities/world_version_entity.dart';

class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl() {
    _seed();
  }

  final List<AuditEntry> _entries = <AuditEntry>[];
  final StreamController<List<AuditEntry>> _feed =
      StreamController<List<AuditEntry>>.broadcast();

  void _seed() {
    final DateTime now = DateTime.now();
    _entries.addAll(<AuditEntry>[
      AuditEntry(
        id: Ulid.generate(time: now.subtract(const Duration(days: 5))),
        actorId: 'usr_admin',
        actorEmail: 'admin@prepquest.app',
        action: AuditAction.publish,
        resourceType: 'world',
        resourceId: 'wld_bcs',
        beforeHash: 'none',
        afterHash: 'bcs-v1',
        reason: 'Launch BCS world',
        ip: '127.0.0.1',
        userAgent: 'PrepQuest Admin Web',
        correlationId: 'seed-publish-bcs',
        timestamp: now.subtract(const Duration(days: 5)),
      ),
      AuditEntry(
        id: Ulid.generate(time: now.subtract(const Duration(days: 1))),
        actorId: 'usr_author',
        actorEmail: 'author@prepquest.app',
        action: AuditAction.update,
        resourceType: 'world',
        resourceId: 'wld_bank',
        beforeHash: 'bank-v0',
        afterHash: 'bank-v0.1',
        reason: 'Reorder chapters',
        ip: '127.0.0.1',
        userAgent: 'PrepQuest Admin Web',
        correlationId: 'seed-update-bank',
        timestamp: now.subtract(const Duration(days: 1)),
      ),
      AuditEntry(
        id: Ulid.generate(time: now.subtract(const Duration(hours: 12))),
        actorId: 'usr_reviewer',
        actorEmail: 'reviewer@prepquest.app',
        action: AuditAction.submit,
        resourceType: 'world',
        resourceId: 'wld_primary',
        beforeHash: 'primary-v0.2',
        afterHash: 'primary-v0.2',
        reason: 'Ready for review',
        ip: '127.0.0.1',
        userAgent: 'PrepQuest Admin Web',
        correlationId: 'seed-submit-primary',
        timestamp: now.subtract(const Duration(hours: 12)),
      ),
    ]);
  }

  @override
  Future<List<AuditEntry>> recent({int limit = 100, String? resourceType}) async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    final Iterable<AuditEntry> filtered = resourceType == null
        ? _entries
        : _entries.where((AuditEntry e) => e.resourceType == resourceType);
    return filtered
        .toList()
        .reversed
        .take(limit)
        .toList();
  }

  @override
  Future<AuditEntry> record(AuditEntry entry) async {
    _entries.add(entry);
    _feed.add(_entries.reversed.take(50).toList());
    return entry;
  }

  @override
  Future<AuditEntry> recordWorldCreated({
    required WorldEntity world,
    required String actorId,
  }) {
    return record(AuditEntry(
      id: Ulid.generate(),
      actorId: actorId,
      actorEmail: actorId,
      action: AuditAction.create,
      resourceType: 'world',
      resourceId: world.id,
      beforeHash: '',
      afterHash: world.slug,
      reason: 'Create world ${world.slug}',
      ip: '127.0.0.1',
      userAgent: 'PrepQuest Admin Web',
      correlationId: Ulid.generate(),
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<AuditEntry> recordWorldPublished({
    required WorldVersionEntity version,
    required String actorId,
  }) {
    return record(AuditEntry(
      id: Ulid.generate(),
      actorId: actorId,
      actorEmail: actorId,
      action: AuditAction.publish,
      resourceType: 'world_version',
      resourceId: version.id,
      beforeHash: version.parentId ?? '',
      afterHash: version.payloadHash,
      reason: version.releaseNotes,
      ip: '127.0.0.1',
      userAgent: 'PrepQuest Admin Web',
      correlationId: Ulid.generate(),
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<AuditEntry> recordRollback({
    required String world,
    required String versionId,
    required String actorId,
    required String reason,
  }) {
    return record(AuditEntry(
      id: Ulid.generate(),
      actorId: actorId,
      actorEmail: actorId,
      action: AuditAction.rollback,
      resourceType: 'world',
      resourceId: world,
      beforeHash: versionId,
      afterHash: versionId,
      reason: reason,
      ip: '127.0.0.1',
      userAgent: 'PrepQuest Admin Web',
      correlationId: Ulid.generate(),
      timestamp: DateTime.now(),
    ));
  }

  @override
  Stream<List<AuditEntry>> watchFeed({int limit = 50}) {
    _feed.add(_entries.reversed.take(limit).toList());
    return _feed.stream;
  }
}

final auditRepositoryProvider = Provider<AuditRepository>((Ref ref) {
  final AuditRepositoryImpl repo = AuditRepositoryImpl();
  ref.onDispose(repo._feed.close);
  return repo;
});
