import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_radius.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class ConsolePanel extends ConsumerWidget {
  const ConsolePanel({
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
        color: AdminPalette.graphite,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.sm),
            child: Row(
              children: <Widget>[
                const Icon(Icons.terminal, size: 14, color: Colors.white70),
                const SizedBox(width: AdminSpacing.xs),
                Text(
                  'Console · ${s.issues.length} issue${s.issues.length == 1 ? '' : 's'}',
                  style: theme.textTheme.labelSmall?.copyWith(color: Colors.white70),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AdminSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: s.issues.any((ValidationIssue i) => i.severity == IssueSeverity.error)
                        ? AdminPalette.danger.withValues(alpha: 0.25)
                        : AdminPalette.success.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AdminRadius.pill),
                  ),
                  child: Text(
                    s.issues.any((ValidationIssue i) => i.severity == IssueSeverity.error)
                        ? 'blocking'
                        : 'ok',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: s.issues.any((ValidationIssue i) =>
                              i.severity == IssueSeverity.error)
                          ? AdminPalette.danger
                          : AdminPalette.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: s.issues.isEmpty
                ? Center(
                    child: Text(
                      'No validation issues · draft clean.',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(AdminSpacing.sm),
                    itemCount: s.issues.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (BuildContext context, int index) {
                      final ValidationIssue issue = s.issues[index];
                      final Color color = switch (issue.severity) {
                        IssueSeverity.error => AdminPalette.danger,
                        IssueSeverity.warning => AdminPalette.warning,
                        IssueSeverity.info => AdminPalette.info,
                      };
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AdminSpacing.sm),
                          Expanded(
                            child: Text(
                              issue.message,
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.white),
                            ),
                          ),
                          Text(
                            issue.code,
                            style:
                                theme.textTheme.labelSmall?.copyWith(color: Colors.white54),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
