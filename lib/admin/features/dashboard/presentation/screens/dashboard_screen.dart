import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../../../shared/routing/admin_routes.dart';
import '../../../audit/data/repositories/audit_repository_impl.dart';
import '../../../audit/domain/entities/audit_entry.dart';
import '../../../events/data/repositories/event_repository_impl.dart';
import '../../../events/domain/entities/event_entity.dart';
import '../../../worlds/domain/entities/world_entity.dart';
import '../../../worlds/presentation/providers/world_list_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<WorldEntity>> worlds = ref.watch(worldStreamProvider);
    final AsyncValue<List<AuditEntry>> audit =
        ref.watch(_auditFeedProvider);
    final AsyncValue<List<EventEntity>> events =
        ref.watch(_eventsProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text('Dashboard', style: theme.textTheme.displayMedium),
          const SizedBox(height: AdminSpacing.sm),
          Text(
            'Continue where you left off, watch what needs review, and prepare the next publish.',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AdminSpacing.xl),
          GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: AdminSpacing.md,
            mainAxisSpacing: AdminSpacing.md,
            childAspectRatio: 1.6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              _KpiCard(
                label: 'Worlds',
                value: worlds.maybeWhen(
                  data: (List<WorldEntity> list) => list.length.toString(),
                  orElse: () => '—',
                ),
                icon: Icons.public,
                tint: AdminPalette.accent,
              ),
              _KpiCard(
                label: 'Drafts in flight',
                value: worlds.maybeWhen(
                  data: (List<WorldEntity> list) => list
                      .where((WorldEntity w) =>
                          w.status == WorkflowState.draft ||
                          w.status == WorkflowState.inReview)
                      .length
                      .toString(),
                  orElse: () => '—',
                ),
                icon: Icons.edit_note,
                tint: AdminPalette.warning,
              ),
              _KpiCard(
                label: 'Live events',
                value: events.maybeWhen(
                  data: (List<EventEntity> list) => list
                      .where((EventEntity e) => e.isLive)
                      .length
                      .toString(),
                  orElse: () => '—',
                ),
                icon: Icons.event,
                tint: AdminPalette.success,
              ),
              _KpiCard(
                label: 'Audit entries',
                value: audit.maybeWhen(
                  data: (List<AuditEntry> list) => list.length.toString(),
                  orElse: () => '—',
                ),
                icon: Icons.history,
                tint: AdminPalette.info,
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: _SectionCard(
                  title: 'Recent worlds',
                  trailing: TextButton(
                    onPressed: () => context.go(AdminRoutes.worlds),
                    child: const Text('View all'),
                  ),
                  child: worlds.maybeWhen(
                    data: (List<WorldEntity> list) => Column(
                      children: <Widget>[
                        for (final WorldEntity w
                            in list.take(5))
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: AdminPalette.ivory,
                              child: Text(
                                w.examVertical.code.substring(0, 1),
                                style: theme.textTheme.labelMedium,
                              ),
                            ),
                            title: Text(w.displayName),
                            subtitle: Text(
                              '${w.examVertical.label} · ${w.status.wire}',
                              style: theme.textTheme.bodySmall,
                            ),
                            trailing: Text(
                              DateFormat.MMMd().format(w.updatedAt),
                              style: theme.textTheme.bodySmall,
                            ),
                            onTap: () => context.go(AdminRoutes.worldEditorPath(w.id)),
                          ),
                      ],
                    ),
                    orElse: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
              const SizedBox(width: AdminSpacing.lg),
              Expanded(
                flex: 1,
                child: _SectionCard(
                  title: 'Activity',
                  trailing: TextButton(
                    onPressed: () => context.go(AdminRoutes.activity),
                    child: const Text('View all'),
                  ),
                  child: audit.maybeWhen(
                    data: (List<AuditEntry> list) => Column(
                      children: <Widget>[
                        for (final AuditEntry e in list.take(8))
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: AdminSpacing.xs),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: const BoxDecoration(
                                    color: AdminPalette.accent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${e.action.wire.toUpperCase()} ${e.resourceType.split('.').last}',
                                    style: theme.textTheme.labelMedium,
                                  ),
                                ),
                                Text(
                                  DateFormat.Hm().format(e.timestamp),
                                  style: theme.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    orElse: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          _SectionCard(
            title: 'Scheduled events',
            child: events.maybeWhen(
              data: (List<EventEntity> list) {
                if (list.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(AdminSpacing.lg),
                    child: Text('No events scheduled.'),
                  );
                }
                return Column(
                  children: <Widget>[
                    for (final EventEntity e in list.take(6))
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(_iconFor(e.kind)),
                        title: Text(e.displayName),
                        subtitle: Text(
                          '${DateFormat.yMMMd().format(e.startsAt)} – ${DateFormat.yMMMd().format(e.endsAt)} · ${e.kind.wire}',
                          style: theme.textTheme.bodySmall,
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AdminSpacing.sm, vertical: 2),
                          decoration: BoxDecoration(
                            color: _tint(e.lifecycle).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(AdminRadius.pill),
                            border: Border.all(
                              color: _tint(e.lifecycle).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            e.lifecycle.name.toUpperCase(),
                            style: theme.textTheme.labelSmall
                                ?.copyWith(color: _tint(e.lifecycle)),
                          ),
                        ),
                      ),
                  ],
                );
              },
              orElse: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(EventKind k) {
    switch (k) {
      case EventKind.season:
        return Icons.ac_unit_outlined;
      case EventKind.holiday:
        return Icons.celebration_outlined;
      case EventKind.tournament:
        return Icons.emoji_events_outlined;
      case EventKind.offer:
        return Icons.local_offer_outlined;
      case EventKind.anniversary:
        return Icons.history_edu_outlined;
    }
  }

  Color _tint(EventLifecycle lc) {
    switch (lc) {
      case EventLifecycle.scheduled:
        return AdminPalette.statusInReview;
      case EventLifecycle.live:
        return AdminPalette.success;
      case EventLifecycle.ended:
        return AdminPalette.ash;
      case EventLifecycle.cancelled:
        return AdminPalette.danger;
    }
  }
}

final _auditFeedProvider =
    FutureProvider<List<AuditEntry>>((Ref ref) {
  return ref.watch(auditRepositoryProvider).recent(limit: 20);
});

final _eventsProvider = FutureProvider<List<EventEntity>>((Ref ref) {
  return ref.watch(eventRepositoryProvider).listEvents();
});

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AdminRadius.sm),
                ),
                child: Icon(icon, color: tint, size: 16),
              ),
              const SizedBox(width: AdminSpacing.sm),
              Expanded(
                child: Text(label,
                    style: theme.textTheme.labelSmall,
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          Text(value, style: theme.textTheme.displayLarge),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AdminSpacing.lg),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text(title, style: theme.textTheme.titleMedium)),
              ?trailing,
            ],
          ),
          const SizedBox(height: AdminSpacing.md),
          child,
        ],
      ),
    );
  }
}
