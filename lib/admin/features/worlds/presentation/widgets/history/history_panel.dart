import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/admin_spacing.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class HistoryPanel extends ConsumerWidget {
  const HistoryPanel({
    required this.controller,
    required this.draft,
    super.key,
  });

  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorldEditorState s = controller.value;
    final ThemeData theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(maxHeight: AdminSpacing.consoleHeight),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.sm),
            child: Row(
              children: <Widget>[
                Text('History (${s.history.length})',
                    style: theme.textTheme.titleSmall),
                const Spacer(),
                IconButton(
                  tooltip: 'Undo',
                  icon: const Icon(Icons.undo, size: 16),
                  onPressed: s.history.isEmpty
                      ? null
                      : () {
                          ref
                              .read(worldEditorControllerProvider(draft).notifier)
                              .undo();
                          controller.value =
                              ref.read(worldEditorControllerProvider(draft));
                        },
                ),
                IconButton(
                  tooltip: 'Redo',
                  icon: const Icon(Icons.redo, size: 16),
                  onPressed: s.future.isEmpty
                      ? null
                      : () {
                          ref
                              .read(worldEditorControllerProvider(draft).notifier)
                              .redo();
                          controller.value =
                              ref.read(worldEditorControllerProvider(draft));
                        },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: s.history.length,
              itemBuilder: (BuildContext context, int index) {
                final HistoryEntry h =
                    s.history[s.history.length - 1 - index];
                return ListTile(
                  dense: true,
                  leading: const Icon(Icons.history, size: 16),
                  title: Text(h.label),
                  subtitle: Text(
                    _timeAgo(h.timestamp),
                    style: theme.textTheme.bodySmall,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime t) {
    final Duration d = DateTime.now().difference(t);
    if (d.inSeconds < 60) return '${d.inSeconds}s ago';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}
