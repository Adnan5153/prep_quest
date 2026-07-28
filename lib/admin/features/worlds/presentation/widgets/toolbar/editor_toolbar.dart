import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/admin_strings.dart';
import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_radius.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../../../shared/enums/workflow_state.dart';
import '../../../../../shared/routing/admin_routes.dart';
import '../../../../auth/presentation/providers/auth_provider.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class EditorToolbar extends ConsumerWidget {
  const EditorToolbar({required this.controller, required this.draft, super.key});

  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final WorldEditorState s = controller.value;
    final ThemeData theme = Theme.of(context);

    return Container(
      height: AdminSpacing.toolbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline),
        ),
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Back',
            onPressed: () => context.go(AdminRoutes.worlds),
            icon: const Icon(Icons.arrow_back, size: 18),
          ),
          const SizedBox(width: AdminSpacing.sm),
          _StatusPill(status: s.draft.nodes.isEmpty
              ? WorkflowState.draft
              : WorkflowState.draft),
          const SizedBox(width: AdminSpacing.sm),
          Expanded(
            child: Text(
              'Draft · ${s.draft.branchName}',
              style: theme.textTheme.titleSmall,
            ),
          ),
          if (s.dirty)
            Text(
              'Unsaved',
              style: theme.textTheme.labelSmall?.copyWith(color: AdminPalette.warning),
            )
          else if (s.lastSavedAt != null)
            Text(
              'Saved ${_ago(s.lastSavedAt!)}',
              style: theme.textTheme.labelSmall,
            ),
          const SizedBox(width: AdminSpacing.md),
          _IconAction(
            tooltip: AdminStrings.actionUndo,
            icon: Icons.undo,
            onTap: s.history.isEmpty ? null : () => _undo(ref),
          ),
          _IconAction(
            tooltip: AdminStrings.actionRedo,
            icon: Icons.redo,
            onTap: s.future.isEmpty ? null : () => _redo(ref),
          ),
          const SizedBox(width: AdminSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _autoConnect(ref),
            icon: const Icon(Icons.timeline, size: 16),
            label: const Text('Auto-connect'),
          ),
          const SizedBox(width: AdminSpacing.sm),
          OutlinedButton.icon(
            onPressed: () => _save(context, ref),
            icon: const Icon(Icons.save_outlined, size: 16),
            label: Text(s.saving ? 'Saving…' : AdminStrings.actionSave),
          ),
          const SizedBox(width: AdminSpacing.sm),
          FilledButton.icon(
            onPressed: () => _publish(context, ref),
            icon: const Icon(Icons.publish, size: 16),
            label: const Text(AdminStrings.actionPublish),
          ),
        ],
      ),
    );
  }

  void _undo(WidgetRef ref) {
    ref
        .read(worldEditorControllerProvider(draft).notifier)
        .undo();
    _refresh(ref);
  }

  void _redo(WidgetRef ref) {
    ref
        .read(worldEditorControllerProvider(draft).notifier)
        .redo();
    _refresh(ref);
  }

  void _autoConnect(WidgetRef ref) {
    ref
        .read(worldEditorControllerProvider(draft).notifier)
        .autoConnectNodes();
    _refresh(ref);
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(worldEditorControllerProvider(draft).notifier).save();
      _refresh(ref);
    } catch (e) {
      if (!context.mounted) return;
      _showSnack(context, 'Save failed: $e');
    }
  }

  Future<void> _publish(BuildContext context, WidgetRef ref) async {
    final TextEditingController notes =
        TextEditingController(text: 'Publish draft');
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Publish draft'),
          content: SizedBox(
            width: 380,
            child: TextField(
              controller: notes,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: AdminStrings.labelReleaseNotes,
                hintText: 'Summarise what changed.',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Publish'),
            ),
          ],
        );
      },
    );
    if (proceed != true) return;
    final String actorId =
        ref.read(authStateProvider).session?.userId ?? 'usr_admin';
    try {
      await ref
          .read(worldEditorControllerProvider(draft).notifier)
          .publish(notes.text, actorId);
      _refresh(ref);
      if (!context.mounted) return;
      _showSnack(context, 'Published');
    } catch (e) {
      if (!context.mounted) return;
      _showSnack(context, 'Publish failed: $e');
    }
  }

  void _refresh(WidgetRef ref) {
    controller.value = ref.read(worldEditorControllerProvider(draft));
  }

  void _showSnack(BuildContext context, String text) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _ago(DateTime when) {
    final Duration d = DateTime.now().difference(when);
    if (d.inSeconds < 60) return '${d.inSeconds}s ago';
    if (d.inMinutes < 60) return '${d.inMinutes}m ago';
    if (d.inHours < 24) return '${d.inHours}h ago';
    return '${d.inDays}d ago';
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final WorkflowState status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = switch (status) {
      WorkflowState.draft => AdminPalette.statusDraft,
      WorkflowState.inReview => AdminPalette.statusInReview,
      WorkflowState.testing => AdminPalette.statusTesting,
      WorkflowState.published => AdminPalette.statusPublished,
      WorkflowState.archived => AdminPalette.statusArchived,
    };
    final String label = switch (status) {
      WorkflowState.draft => AdminStrings.statusDraft,
      WorkflowState.inReview => AdminStrings.statusInReview,
      WorkflowState.testing => AdminStrings.statusTesting,
      WorkflowState.published => AdminStrings.statusPublished,
      WorkflowState.archived => AdminStrings.statusArchived,
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({required this.icon, required this.tooltip, this.onTap});

  final IconData icon;
  final String tooltip;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon, size: 18),
      onPressed: onTap,
    );
  }
}
