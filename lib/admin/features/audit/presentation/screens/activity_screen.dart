import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/audit_entry.dart';
import '../providers/audit_provider.dart';

class ActivityScreen extends ConsumerWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<AuditEntry>> entries =
        ref.watch(auditEntriesProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Activity', style: theme.textTheme.displayMedium),
          const SizedBox(height: AdminSpacing.sm),
          Text(
            'Append-only audit trail of every admin action: world edits, publishes, rollbacks, role changes.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: entries.when(
              data: (List<AuditEntry> list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No audit entries yet.'));
                }
                return Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(AdminRadius.lg),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _HeaderRow(theme: theme),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext c, int i) =>
                              _AuditRow(entry: list[i]),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(child: Text('Failed: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final TextStyle? style = theme.textTheme.labelSmall
        ?.copyWith(color: AdminPalette.slate);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.lg, vertical: AdminSpacing.md),
      child: Row(
        children: <Widget>[
          SizedBox(width: 120, child: Text('Time', style: style)),
          SizedBox(width: 100, child: Text('Action', style: style)),
          SizedBox(width: 80, child: Text('Resource', style: style)),
          Expanded(child: Text('Reason', style: style)),
          SizedBox(width: 100, child: Text('Actor', style: style)),
          SizedBox(width: 140, child: Text('Hash diff', style: style)),
        ],
      ),
    );
  }
}

class _AuditRow extends StatelessWidget {
  const _AuditRow({required this.entry});

  final AuditEntry entry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.lg, vertical: AdminSpacing.sm),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 120,
            child: Text(
              DateFormat('MMM d HH:mm').format(entry.timestamp),
              style: theme.textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 100,
            child: _ActionChip(action: entry.action),
          ),
          SizedBox(
            width: 80,
            child: Text(
              entry.resourceType.split('.').last,
              style: theme.textTheme.bodySmall,
            ),
          ),
          Expanded(
            child: Text(entry.reason,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 100,
            child: Text(entry.actorEmail,
                style: theme.textTheme.bodySmall,
                overflow: TextOverflow.ellipsis),
          ),
          SizedBox(
            width: 140,
            child: Text(
              '${entry.beforeHash} → ${entry.afterHash}',
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({required this.action});

  final AuditAction action;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = switch (action) {
      AuditAction.create => AdminPalette.accent,
      AuditAction.update => AdminPalette.info,
      AuditAction.publish => AdminPalette.success,
      AuditAction.rollback => AdminPalette.warning,
      AuditAction.delete || AuditAction.archive => AdminPalette.danger,
      AuditAction.submit || AuditAction.approve => AdminPalette.statusInReview,
      AuditAction.reject => AdminPalette.danger,
      AuditAction.upload => AdminPalette.statusTesting,
      AuditAction.roleAssign || AuditAction.roleRevoke =>
        AdminPalette.statusDraft,
      _ => AdminPalette.slate,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: tint.withValues(alpha: 0.4)),
      ),
      child: Text(
        action.wire.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: tint),
      ),
    );
  }
}
