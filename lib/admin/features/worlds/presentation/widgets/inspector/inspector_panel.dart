import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/admin_strings.dart';
import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../../../shared/enums/workflow_state.dart';
import '../../../../animations/presentation/providers/animations_provider.dart';
import '../../../../assets/presentation/providers/assets_provider.dart';
import '../../../../rewards/presentation/providers/rewards_provider.dart';
import '../../../../translations/presentation/providers/translations_provider.dart';
import '../../../domain/entities/building_entity.dart';
import '../../../domain/entities/coordinate_entity.dart';
import '../../../domain/entities/decoration_entity.dart';
import '../../../domain/entities/node_entity.dart';
import '../../../domain/entities/world_draft_entity.dart';
import '../../providers/world_editor_provider.dart';

class InspectorPanel extends ConsumerWidget {
  const InspectorPanel({
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

    Widget content;
    if (s.selection.isEmpty) {
      content = const _EmptyInspector();
    } else {
      switch (s.selection.kind) {
        case SelectionKind.node:
          final NodeEntity node = draft.nodes
              .firstWhere((NodeEntity n) => n.id == s.selection.id);
          content = _NodeInspector(node: node, controller: controller, draft: draft);
          break;
        case SelectionKind.building:
          final BuildingEntity b = draft.buildings
              .firstWhere((BuildingEntity b) => b.id == s.selection.id);
          content = _BuildingInspector(building: b, controller: controller, draft: draft);
          break;
        case SelectionKind.decoration:
          final DecorationEntity d = draft.decorations
              .firstWhere((DecorationEntity d) => d.id == s.selection.id);
          content = _DecorationInspector(decoration: d, controller: controller, draft: draft);
          break;
        case SelectionKind.path:
          content = _EmptyInspector(
            title: 'Path selected',
            description: 'Path control points can be dragged directly on the canvas.',
          );
          break;
        case SelectionKind.none:
          content = const _EmptyInspector();
      }
    }

    return Container(
      constraints: const BoxConstraints(maxWidth: AdminSpacing.inspectorWidth),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(AdminSpacing.md),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outline),
              ),
            ),
            child: Row(
              children: <Widget>[
                Icon(Icons.tune, size: 16, color: theme.colorScheme.onSurface),
                const SizedBox(width: AdminSpacing.sm),
                Text(AdminStrings.panelInspector,
                    style: theme.textTheme.titleSmall),
              ],
            ),
          ),
          Expanded(child: SingleChildScrollView(child: content)),
        ],
      ),
    );
  }
}

class _EmptyInspector extends StatelessWidget {
  const _EmptyInspector({this.title, this.description});

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title ?? 'Nothing selected', style: theme.textTheme.titleSmall),
          const SizedBox(height: AdminSpacing.sm),
          Text(
            description ??
                'Pick a node, building, decoration, or path to see its properties. Use the toolbar to switch between Select, Place, and Paint modes.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AdminSpacing.md, bottom: AdminSpacing.xs),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1.2),
      ),
    );
  }
}

class _CoordinateField extends StatelessWidget {
  const _CoordinateField({required this.x, required this.y, required this.onChanged});

  final double x;
  final double y;
  final void Function(double x, double y) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextFormField(
            initialValue: x.toStringAsFixed(0),
            decoration: const InputDecoration(labelText: 'X'),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (String v) =>
                onChanged(double.tryParse(v) ?? x, y),
          ),
        ),
        const SizedBox(width: AdminSpacing.sm),
        Expanded(
          child: TextFormField(
            initialValue: y.toStringAsFixed(0),
            decoration: const InputDecoration(labelText: 'Y'),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (String v) =>
                onChanged(x, double.tryParse(v) ?? y),
          ),
        ),
      ],
    );
  }
}

class _NodeInspector extends ConsumerWidget {
  const _NodeInspector({
    required this.node,
    required this.controller,
    required this.draft,
  });

  final NodeEntity node;
  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final translations = ref.watch(translationsListProvider as ProviderListenable<dynamic>);
    final animations = ref.watch(animationsListProvider);
    final rewards = ref.watch(rewardsListProvider);

    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: AdminPalette.nodeAvailable,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AdminSpacing.sm),
              Expanded(
                child: Text(
                  'Node · ${node.kind.wire}',
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AdminSpacing.sm),
          Text('ID: ${node.id}', style: theme.textTheme.bodySmall),
          const _SectionLabel('Position'),
          _CoordinateField(
            x: node.coordinate.x,
            y: node.coordinate.y,
            onChanged: (double x, double y) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) => n.copyWith(
                      coordinate: CoordinateEntity(x: x, y: y),
                    ),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const _SectionLabel('Content'),
          DropdownButtonFormField<String?>(
            initialValue: node.titleKey,
            decoration: const InputDecoration(labelText: AdminStrings.labelTranslationKey),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(value: null, child: Text('— none —')),
              ...translations.maybeWhen(
                data: (List<TranslationEntry> list) => list
                    .map((TranslationEntry e) => DropdownMenuItem<String?>(
                          value: e.key,
                          child: Text(e.key),
                        )),
                orElse: () => const <DropdownMenuItem<String?>>[],
              ),
            ],
            onChanged: (String? v) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) => n.copyWith(titleKey: v),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const SizedBox(height: AdminSpacing.sm),
          TextFormField(
            initialValue: node.levelNumber?.toString() ?? '',
            decoration: const InputDecoration(labelText: 'Level number'),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (String v) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) =>
                        n.copyWith(levelNumber: int.tryParse(v)),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const _SectionLabel('Animation'),
          DropdownButtonFormField<String?>(
            initialValue: node.animationId,
            decoration: const InputDecoration(labelText: AdminStrings.labelAnimation),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(value: null, child: Text('— none —')),
              ...animations.maybeWhen(
                data: (List<AnimationSummary> list) => list
                    .map((AnimationSummary a) => DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(a.displayName),
                        )),
                orElse: () => const <DropdownMenuItem<String?>>[],
              ),
            ],
            onChanged: (String? v) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) => n.copyWith(animationId: v),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const _SectionLabel('Reward table'),
          DropdownButtonFormField<String?>(
            initialValue: node.rewardTableId,
            decoration: const InputDecoration(labelText: AdminStrings.labelRewardTable),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(value: null, child: Text('— none —')),
              ...rewards.maybeWhen(
                data: (List<RewardSummary> list) => list
                    .map((RewardSummary r) => DropdownMenuItem<String?>(
                          value: r.id,
                          child: Text(r.name),
                        )),
                orElse: () => const <DropdownMenuItem<String?>>[],
              ),
            ],
            onChanged: (String? v) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) => n.copyWith(rewardTableId: v),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const _SectionLabel('Gate'),
          SwitchListTile.adaptive(
            title: const Text('Is Boss Gate'),
            value: node.hasBossGate,
            contentPadding: EdgeInsets.zero,
            onChanged: (bool v) {
              ref.read(worldEditorControllerProvider(draft).notifier).updateNode(
                    node.id,
                    (NodeEntity n) => n.copyWith(
                      kind: v ? WorldObjectKind.bossGate : WorldObjectKind.lessonNode,
                      gateRule: v
                          ? (n.gateRule ??
                              const GateRuleEntity(
                                kind: 'boss',
                                minLevel: 1,
                              ))
                          : null,
                    ),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
        ],
      ),
    );
  }
}

class _BuildingInspector extends ConsumerWidget {
  const _BuildingInspector({
    required this.building,
    required this.controller,
    required this.draft,
  });

  final BuildingEntity building;
  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final assets = ref.watch(assetsListProvider as ProviderListenable<dynamic>);
    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Building · ${building.kind}', style: theme.textTheme.titleSmall),
          const SizedBox(height: AdminSpacing.sm),
          Text('ID: ${building.id}', style: theme.textTheme.bodySmall),
          const _SectionLabel('Position'),
          _CoordinateField(
            x: building.coordinate.x,
            y: building.coordinate.y,
            onChanged: (double x, double y) {
              ref
                  .read(worldEditorControllerProvider(draft).notifier)
                  .updateBuilding(
                    building.id,
                    (BuildingEntity b) => b.copyWith(
                      coordinate: CoordinateEntity(x: x, y: y),
                    ),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const SizedBox(height: AdminSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: building.width.toStringAsFixed(0),
                  decoration: const InputDecoration(labelText: 'Width'),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String v) {
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .updateBuilding(
                          building.id,
                          (BuildingEntity b) =>
                              b.copyWith(width: double.tryParse(v) ?? b.width),
                        );
                    controller.value =
                        ref.read(worldEditorControllerProvider(draft));
                  },
                ),
              ),
              const SizedBox(width: AdminSpacing.sm),
              Expanded(
                child: TextFormField(
                  initialValue: building.height.toStringAsFixed(0),
                  decoration: const InputDecoration(labelText: 'Height'),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String v) {
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .updateBuilding(
                          building.id,
                          (BuildingEntity b) => b.copyWith(
                              height: double.tryParse(v) ?? b.height),
                        );
                    controller.value =
                        ref.read(worldEditorControllerProvider(draft));
                  },
                ),
              ),
            ],
          ),
          const _SectionLabel('Asset'),
          DropdownButtonFormField<String?>(
            initialValue: building.assetId,
            decoration: const InputDecoration(labelText: AdminStrings.labelAsset),
            items: <DropdownMenuItem<String?>>[
              const DropdownMenuItem<String?>(value: null, child: Text('— none —')),
              ...assets.maybeWhen(
                data: (List<AssetSummary> list) => list
                    .map((AssetSummary a) => DropdownMenuItem<String?>(
                          value: a.id,
                          child: Text(a.displayName),
                        )),
                orElse: () => const <DropdownMenuItem<String?>>[],
              ),
            ],
            onChanged: (String? v) {
              ref
                  .read(worldEditorControllerProvider(draft).notifier)
                  .updateBuilding(
                    building.id,
                    (BuildingEntity b) => b.copyWith(assetId: v),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
        ],
      ),
    );
  }
}

class _DecorationInspector extends ConsumerWidget {
  const _DecorationInspector({
    required this.decoration,
    required this.controller,
    required this.draft,
  });

  final DecorationEntity decoration;
  final ValueNotifier<WorldEditorState> controller;
  final WorldDraftEntity draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(AdminSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Decoration · ${decoration.kind.wire}',
              style: theme.textTheme.titleSmall),
          const SizedBox(height: AdminSpacing.sm),
          Text('ID: ${decoration.id}', style: theme.textTheme.bodySmall),
          const _SectionLabel('Position'),
          _CoordinateField(
            x: decoration.coordinate.x,
            y: decoration.coordinate.y,
            onChanged: (double x, double y) {
              ref
                  .read(worldEditorControllerProvider(draft).notifier)
                  .updateDecoration(
                    decoration.id,
                    (DecorationEntity d) => d.copyWith(
                      coordinate: CoordinateEntity(x: x, y: y),
                    ),
                  );
              controller.value = ref.read(worldEditorControllerProvider(draft));
            },
          ),
          const SizedBox(height: AdminSpacing.sm),
          Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  initialValue: decoration.scale.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: 'Scale'),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String v) {
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .updateDecoration(
                          decoration.id,
                          (DecorationEntity d) => d.copyWith(
                              scale: double.tryParse(v) ?? d.scale),
                        );
                    controller.value =
                        ref.read(worldEditorControllerProvider(draft));
                  },
                ),
              ),
              const SizedBox(width: AdminSpacing.sm),
              Expanded(
                child: TextFormField(
                  initialValue: decoration.rotation.toStringAsFixed(2),
                  decoration: const InputDecoration(labelText: 'Rotation'),
                  keyboardType: TextInputType.number,
                  onFieldSubmitted: (String v) {
                    ref
                        .read(worldEditorControllerProvider(draft).notifier)
                        .updateDecoration(
                          decoration.id,
                          (DecorationEntity d) => d.copyWith(
                              rotation: double.tryParse(v) ?? d.rotation),
                        );
                    controller.value =
                        ref.read(worldEditorControllerProvider(draft));
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
