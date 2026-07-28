import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/admin_strings.dart';
import '../../../../../core/theme/admin_palette.dart';
import '../../../../../core/theme/admin_radius.dart';
import '../../../../../core/theme/admin_spacing.dart';
import '../../../../../shared/enums/workflow_state.dart';
import '../../../../assets/presentation/providers/assets_provider.dart';

class AssetBrowserPanel extends ConsumerWidget {
  const AssetBrowserPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AssetKind? filter = ref.watch(assetKindFilterProvider);
    final String query = ref.watch(assetSearchQueryProvider);
    final AsyncValue<List<AssetSummary>> asyncAssets =
        ref.watch(assetsListProvider(filter));
    final ThemeData theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: AdminSpacing.assetsWidth),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(left: BorderSide(color: theme.colorScheme.outline)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(AdminSpacing.md),
            child: Text(AdminStrings.panelAssets, style: theme.textTheme.titleSmall),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.md),
            child: TextField(
              decoration: const InputDecoration(
                hintText: AdminStrings.placeholderSearchAssets,
                prefixIcon: Icon(Icons.search, size: 16),
              ),
              onChanged: (String v) =>
                  ref.read(assetSearchQueryProvider.notifier).state = v,
            ),
          ),
          const SizedBox(height: AdminSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.md),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: <Widget>[
                  _Chip(
                    label: 'All',
                    selected: filter == null,
                    onTap: () => ref.read(assetKindFilterProvider.notifier).state = null,
                  ),
                  for (final AssetKind k in AssetKind.values)
                    Padding(
                      padding: const EdgeInsets.only(left: AdminSpacing.xs),
                      child: _Chip(
                        label: k.wire,
                        selected: filter == k,
                        onTap: () => ref.read(assetKindFilterProvider.notifier).state = k,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AdminSpacing.sm),
          const Divider(height: 1),
          Expanded(
            child: asyncAssets.when(
              data: (List<AssetSummary> assets) {
                final List<AssetSummary> filtered = query.isEmpty
                    ? assets
                    : assets
                        .where((AssetSummary a) =>
                            a.displayName.toLowerCase().contains(query.toLowerCase()))
                        .toList();
                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(AdminSpacing.lg),
                      child: Text(
                        'No assets match your filter.',
                        style: theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(AdminSpacing.md),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: AdminSpacing.sm,
                    mainAxisSpacing: AdminSpacing.sm,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (BuildContext _, int index) {
                    final AssetSummary a = filtered[index];
                    return _AssetTile(asset: a);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (Object e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AdminSpacing.lg),
                  child: Text('Failed: $e', style: theme.textTheme.bodySmall),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AdminRadius.pill),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm, vertical: 4),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : Colors.transparent,
          border: Border.all(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(AdminRadius.pill),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelSmall
              ?.copyWith(color: selected ? theme.colorScheme.primary : null),
        ),
      ),
    );
  }
}

class _AssetTile extends StatelessWidget {
  const _AssetTile({required this.asset});

  final AssetSummary asset;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Draggable<String>(
      data: asset.id,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(AdminRadius.md),
          ),
          child: Center(
            child: Text(
              asset.displayName,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AdminRadius.md),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AdminRadius.md),
          border: Border.all(color: theme.colorScheme.outline),
        ),
        padding: const EdgeInsets.all(AdminSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AdminPalette.ivory,
                  borderRadius: BorderRadius.circular(AdminRadius.sm),
                ),
                child: Center(
                  child: Icon(
                    _iconFor(asset.kind),
                    color: AdminPalette.slate,
                    size: 28,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AdminSpacing.xs),
            Text(
              asset.displayName,
              style: theme.textTheme.labelSmall,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              asset.kind.wire,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(AssetKind kind) {
    switch (kind) {
      case AssetKind.image:
        return Icons.image_outlined;
      case AssetKind.lottie:
        return Icons.animation_outlined;
      case AssetKind.audio:
        return Icons.audiotrack_outlined;
      case AssetKind.video:
        return Icons.video_library_outlined;
      case AssetKind.font:
        return Icons.text_fields_outlined;
      case AssetKind.shader:
        return Icons.blur_on_outlined;
      case AssetKind.custom:
        return Icons.category_outlined;
    }
  }
}
