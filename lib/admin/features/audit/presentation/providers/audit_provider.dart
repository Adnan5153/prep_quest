import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/audit_repository_impl.dart';
import '../../domain/entities/audit_entry.dart';

final auditEntriesProvider = FutureProvider<List<AuditEntry>>((Ref ref) {
  return ref.watch(auditRepositoryProvider).recent(limit: 100);
});
