import '../entities/theme_entity.dart';

abstract class ThemeRepository {
  Future<List<ThemeEntity>> listThemes();
  Future<ThemeEntity> getTheme(String id);
  Future<ThemeEntity> upsertTheme(ThemeEntity theme);
  Future<void> deleteTheme(String id);
}
