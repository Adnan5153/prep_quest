import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/event_entity.dart';
import '../providers/events_provider.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<EventEntity>> events =
        ref.watch(eventsListProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Events', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Seasonal arcs, holidays, tournaments and offers. Events lock themes and reward tables.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              FilledButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (_) => const _EventCreateDialog(),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New event'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: events.when(
              data: (List<EventEntity> list) {
                if (list.isEmpty) {
                  return const Center(child: Text('No events scheduled.'));
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
                      Padding(
                        padding: const EdgeInsets.all(AdminSpacing.md),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Name',
                                style: theme.textTheme.labelSmall,
                              ),
                            ),
                            Expanded(
                              child: Text('Kind',
                                  style: theme.textTheme.labelSmall),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text('Window',
                                  style: theme.textTheme.labelSmall),
                            ),
                            SizedBox(
                              width: 110,
                              child: Text('Lifecycle',
                                  style: theme.textTheme.labelSmall),
                            ),
                            SizedBox(width: 40, child: Text('')),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Expanded(
                        child: ListView.separated(
                          itemCount: list.length,
                          separatorBuilder: (BuildContext _, int _) =>
                              const Divider(height: 1),
                          itemBuilder: (BuildContext c, int i) =>
                              _Row(event: list[i]),
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

class _EventCreateDialog extends ConsumerStatefulWidget {
  const _EventCreateDialog();

  @override
  ConsumerState<_EventCreateDialog> createState() =>
      _EventCreateDialogState();
}

class _EventCreateDialogState extends ConsumerState<_EventCreateDialog> {
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _slugCtrl = TextEditingController();
  EventKind _kind = EventKind.season;
  DateTime _start = DateTime.now();
  DateTime _end = DateTime.now().add(const Duration(days: 14));

  @override
  void dispose() {
    _nameCtrl.dispose();
    _slugCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New event'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'Display name'),
            ),
            const SizedBox(height: AdminSpacing.sm),
            TextField(
              controller: _slugCtrl,
              decoration: const InputDecoration(labelText: 'Slug'),
            ),
            const SizedBox(height: AdminSpacing.sm),
            DropdownButtonFormField<EventKind>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: 'Kind'),
              items: EventKind.values
                  .map((EventKind k) => DropdownMenuItem<EventKind>(
                        value: k,
                        child: Text(k.wire),
                      ))
                  .toList(),
              onChanged: (EventKind? v) {
                if (v != null) setState(() => _kind = v);
              },
            ),
            const SizedBox(height: AdminSpacing.sm),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final DateTime? picked =
                          await showDatePickerPicker(context, _start);
                      if (picked != null) setState(() => _start = picked);
                    },
                    icon: const Icon(Icons.calendar_today_outlined, size: 14),
                    label: Text('Start: ${DateFormat.yMd().format(_start)}'),
                  ),
                ),
                const SizedBox(width: AdminSpacing.sm),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final DateTime? picked =
                          await showDatePickerPicker(context, _end);
                      if (picked != null) setState(() => _end = picked);
                    },
                    icon: const Icon(Icons.event_outlined, size: 14),
                    label: Text('End: ${DateFormat.yMd().format(_end)}'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            await ref.read(eventsControllerProvider).create(
                  name: _nameCtrl.text.isEmpty ? 'Untitled event' : _nameCtrl.text,
                  slug: _slugCtrl.text.isEmpty
                      ? 'event-${DateTime.now().millisecondsSinceEpoch}'
                      : _slugCtrl.text,
                  kind: _kind,
                  startsAt: _start,
                  endsAt: _end,
                );
            if (context.mounted) Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}

Future<DateTime?> showDatePickerPicker(BuildContext context, DateTime initial) {
  return showDatePicker(
    context: context,
    initialDate: initial,
    firstDate: DateTime(2024),
    lastDate: DateTime(2030),
  );
}

class _Row extends StatelessWidget {
  const _Row({required this.event});

  final EventEntity event;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md, vertical: AdminSpacing.sm),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(event.displayName, style: theme.textTheme.titleSmall),
                if (event.summary != null)
                  Text(event.summary!,
                      style: theme.textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Icon(_iconFor(event.kind), size: 14),
                const SizedBox(width: 4),
                Text(event.kind.wire, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          SizedBox(
            width: 200,
            child: Text(
              '${DateFormat.yMMMd().format(event.startsAt)} – '
              '${DateFormat.yMMMd().format(event.endsAt)}',
              style: theme.textTheme.bodySmall,
            ),
          ),
          SizedBox(
            width: 110,
            child: _LifecycleBadge(lc: event.lifecycle),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, size: 16),
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
}

class _LifecycleBadge extends StatelessWidget {
  const _LifecycleBadge({required this.lc});

  final EventLifecycle lc;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color tint = switch (lc) {
      EventLifecycle.scheduled => AdminPalette.statusInReview,
      EventLifecycle.live => AdminPalette.success,
      EventLifecycle.ended => AdminPalette.ash,
      EventLifecycle.cancelled => AdminPalette.danger,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: tint.withValues(alpha: 0.4)),
      ),
      child: Text(
        lc.name.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: tint),
      ),
    );
  }
}
