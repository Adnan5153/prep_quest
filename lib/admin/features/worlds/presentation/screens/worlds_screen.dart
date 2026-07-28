import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/admin_strings.dart';
import '../../../../core/theme/admin_palette.dart';
import '../../../../core/theme/admin_radius.dart';
import '../../../../core/theme/admin_spacing.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../../../shared/routing/admin_routes.dart';
import '../../data/repositories/world_repository_impl.dart';
import '../../domain/entities/world_entity.dart';
import '../../domain/usecases/world_usecases.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/world_list_provider.dart';

class WorldsScreen extends ConsumerWidget {
  const WorldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AsyncValue<List<WorldEntity>> asyncWorlds = ref.watch(worldStreamProvider);

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
                    Text('Worlds', style: theme.textTheme.displayMedium),
                    const SizedBox(height: AdminSpacing.xs),
                    Text(
                      'Author visual worlds that ship to the mobile app. Every visible element on the learner map is authored here.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AdminSpacing.lg),
              FilledButton.icon(
                onPressed: () => _openCreate(context, ref),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('New world'),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.xl),
          Expanded(
            child: asyncWorlds.when(
              data: (List<WorldEntity> worlds) => _WorldsTable(worlds: worlds),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(child: Text('Failed: $e')),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final TextEditingController name = TextEditingController();
    final TextEditingController slug = TextEditingController();
    final TextEditingController desc = TextEditingController();
    ExamVertical vertical = ExamVertical.bcs;
    final bool? proceed = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext c, StateSetter setState) {
            return AlertDialog(
              title: const Text('Create a new world'),
              content: SizedBox(
                width: 420,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    TextField(
                      controller: name,
                      decoration: const InputDecoration(
                        labelText: AdminStrings.labelName,
                        hintText: 'Bangladesh Civil Service',
                      ),
                    ),
                    const SizedBox(height: AdminSpacing.md),
                    TextField(
                      controller: slug,
                      decoration: const InputDecoration(
                        labelText: AdminStrings.labelSlug,
                        hintText: 'bcs',
                      ),
                    ),
                    const SizedBox(height: AdminSpacing.md),
                    DropdownButtonFormField<ExamVertical>(
                      initialValue: vertical,
                      decoration: const InputDecoration(labelText: 'Vertical'),
                      items: ExamVertical.values
                          .map((ExamVertical v) =>
                              DropdownMenuItem<ExamVertical>(
                                value: v,
                                child: Text(v.label),
                              ))
                          .toList(),
                      onChanged: (ExamVertical? v) =>
                          setState(() => vertical = v ?? vertical),
                    ),
                    const SizedBox(height: AdminSpacing.md),
                    TextField(
                      controller: desc,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: AdminStrings.labelDescription),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
    if (proceed != true) return;
    try {
      final String actorId =
          ref.read(authStateProvider).session?.userId ?? 'usr_admin';
      final WorldEntity world = await CreateWorldUseCase(
        ref.read(worldRepositoryProvider),
      )(CreateWorldParams(
        slug: slug.text,
        displayName: name.text,
        examVerticalCode: vertical.code,
        description: desc.text,
        ownerId: actorId,
      ));
      // The repo's `watchWorlds` stream emits a new snapshot on every
      // write (see `InMemoryWorldRepository._emitWorlds`), so the table
      // updates automatically. No explicit invalidation needed.
      ref.invalidate(worldStreamProvider);
      if (context.mounted) {
        context.go(AdminRoutes.worldEditorPath(world.id));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      }
    }
  }
}

class _WorldsTable extends ConsumerWidget {
  const _WorldsTable({required this.worlds});

  final List<WorldEntity> worlds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    if (worlds.isEmpty) {
      return Center(
        child: Text('No worlds yet.', style: theme.textTheme.bodyMedium),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AdminRadius.lg),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AdminSpacing.lg, vertical: AdminSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: Text('Name', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Vertical', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Status', style: theme.textTheme.labelSmall),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Updated', style: theme.textTheme.labelSmall),
                ),
                const SizedBox(width: 80),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: worlds.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final WorldEntity w = worlds[index];
                return InkWell(
                  onTap: () => context.go(AdminRoutes.worldEditorPath(w.id)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AdminSpacing.lg, vertical: AdminSpacing.md),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(w.displayName,
                                  style: theme.textTheme.titleMedium),
                              Text(w.slug,
                                  style: theme.textTheme.bodySmall),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(w.examVertical.label,
                              style: theme.textTheme.bodyMedium),
                        ),
                        Expanded(
                          flex: 2,
                          child: _StatusPill(status: w.status),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            DateFormat.yMMMd().format(w.updatedAt),
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: const Icon(Icons.chevron_right, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final WorkflowState status;

  @override
  Widget build(BuildContext context) {
    final Color color = switch (status) {
      WorkflowState.draft => AdminPalette.statusDraft,
      WorkflowState.inReview => AdminPalette.statusInReview,
      WorkflowState.testing => AdminPalette.statusTesting,
      WorkflowState.published => AdminPalette.statusPublished,
      WorkflowState.archived => AdminPalette.statusArchived,
    };
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminRadius.pill),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        status.wire.replaceAll('_', ' ').toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
