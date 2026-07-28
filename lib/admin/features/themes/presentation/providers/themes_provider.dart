import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/entities/theme_entity.dart';

class ThemeSummary {
  const ThemeSummary({
    required this.id,
    required this.displayName,
    required this.weather,
    required this.status,
  });

  final String id;
  final String displayName;
  final ThemeWeather weather;
  final WorkflowState status;

  factory ThemeSummary.fromEntity(ThemeEntity e) => ThemeSummary(
        id: e.id,
        displayName: e.displayName,
        weather: e.weather,
        status: e.status,
      );
}

final themesListProvider = FutureProvider<List<ThemeSummary>>((Ref ref) async {
  final List<ThemeEntity> list = await ref.watch(themeRepositoryProvider).listThemes();
  return list.map(ThemeSummary.fromEntity).toList();
});

final themeByIdProvider =
    FutureProvider.family<ThemeEntity, String>((Ref ref, String id) async {
  return ref.watch(themeRepositoryProvider).getTheme(id);
});
