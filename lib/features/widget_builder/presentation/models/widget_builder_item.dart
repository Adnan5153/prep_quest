import '../providers/widget_builder_selection.dart';

enum WidgetCategory {
  buttons,
  cards,
  appbars,
  loading,
  errors,
  avatars,
  chips,
  progress,
  navigation,
  inputs,
  playgroundNodes,
  playgroundDecorations,
  playgroundBuildings,
  playgroundOverlays,
  playgroundRewards,
  playgroundCards,
  playgroundMaps,
  leaderboard,
  misc,
}

class WidgetBuilderItem {
  const WidgetBuilderItem({
    required this.selection,
    required this.name,
    required this.category,
    this.icon,
    this.description,
  });

  final WidgetBuilderSelection selection;
  final String name;
  final WidgetCategory category;
  final String? icon;
  final String? description;
}
