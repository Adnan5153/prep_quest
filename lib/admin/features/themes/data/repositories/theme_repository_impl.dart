import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/theme_entity.dart';
import '../../domain/repositories/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  ThemeRepositoryImpl() {
    _seed();
  }

  final Map<String, ThemeEntity> _themes = <String, ThemeEntity>{};

  void _seed() {
    final DateTime now = DateTime.now();
    final ThemeEntity classicMeadow = ThemeEntity(
      id: 'thm_classic_meadow',
      slug: 'classic-meadow',
      displayName: 'Classic Meadow',
      parentId: null,
      tokens: const ThemeTokens(
        skyTop: '#A6D8FF',
        skyBottom: '#E4F4FF',
        ground: '#7CB342',
        pathPrimary: '#C9A36B',
        pathShadow: '#8E7148',
        buildingPrimary: '#E8D5B7',
        buildingSecondary: '#A57E50',
        nodeLocked: '#90A4AE',
        nodeAvailable: '#0E7C4A',
        nodeCompleted: '#1B3B6F',
        bossGate: '#F5A623',
        particleColor: '#FFF59D',
        cloudColor: '#FFFFFF',
        atmosphereTint: '#A6D8FF',
      ),
      weather: ThemeWeather.sunny,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 90)),
      seasonalWeight: 1,
    );

    final ThemeEntity winter = ThemeEntity(
      id: 'thm_winter',
      slug: 'winter',
      displayName: 'Winter',
      parentId: 'thm_classic_meadow',
      tokens: const ThemeTokens(
        skyTop: '#BFD7E8',
        skyBottom: '#EAF3FA',
        ground: '#F5FBFF',
        pathPrimary: '#B3CFDD',
        pathShadow: '#6E8CA0',
        buildingPrimary: '#F0F8FE',
        buildingSecondary: '#7C8FA4',
        nodeLocked: '#90A4AE',
        nodeAvailable: '#0288D1',
        nodeCompleted: '#01579B',
        bossGate: '#FF7043',
        particleColor: '#FFFFFF',
        cloudColor: '#FFFAFE',
        atmosphereTint: '#BFD7E8',
      ),
      weather: ThemeWeather.snowy,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 60)),
      seasonalWeight: 0.4,
    );

    final ThemeEntity monsoon = ThemeEntity(
      id: 'thm_monsoon',
      slug: 'monsoon',
      displayName: 'Monsoon',
      parentId: 'thm_classic_meadow',
      tokens: const ThemeTokens(
        skyTop: '#7DA0A8',
        skyBottom: '#B3C8D1',
        ground: '#3F7E47',
        pathPrimary: '#9F6D3A',
        pathShadow: '#5C3C1D',
        buildingPrimary: '#A1887F',
        buildingSecondary: '#5D4037',
        nodeLocked: '#78909C',
        nodeAvailable: '#388E3C',
        nodeCompleted: '#1B5E20',
        bossGate: '#FFC107',
        particleColor: '#B3E5FC',
        cloudColor: '#CFD8DC',
        atmosphereTint: '#7DA0A8',
      ),
      weather: ThemeWeather.rainy,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 30)),
      seasonalWeight: 0.5,
    );

    final ThemeEntity night = ThemeEntity(
      id: 'thm_night',
      slug: 'night',
      displayName: 'Night',
      parentId: 'thm_classic_meadow',
      tokens: const ThemeTokens(
        skyTop: '#0B1335',
        skyBottom: '#1A237E',
        ground: '#1B2E4B',
        pathPrimary: '#3F51B5',
        pathShadow: '#1A237E',
        buildingPrimary: '#283593',
        buildingSecondary: '#0D1657',
        nodeLocked: '#5C6BC0',
        nodeAvailable: '#FFC107',
        nodeCompleted: '#FFEB3B',
        bossGate: '#FF5722',
        particleColor: '#80D8FF',
        cloudColor: '#3F51B5',
        atmosphereTint: '#0B1335',
      ),
      weather: ThemeWeather.foggy,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 20)),
      seasonalWeight: 0.2,
    );

    final ThemeEntity ramadan = ThemeEntity(
      id: 'thm_ramadan',
      slug: 'ramadan',
      displayName: 'Ramadan',
      parentId: null,
      tokens: const ThemeTokens(
        skyTop: '#1B0E36',
        skyBottom: '#3A1F66',
        ground: '#311B92',
        pathPrimary: '#D4AF37',
        pathShadow: '#7B5E0A',
        buildingPrimary: '#4527A0',
        buildingSecondary: '#311B92',
        nodeLocked: '#5E35B1',
        nodeAvailable: '#FFC107',
        nodeCompleted: '#FFD54F',
        bossGate: '#FF6E40',
        particleColor: '#FFE082',
        cloudColor: '#5E35B1',
        atmosphereTint: '#1B0E36',
      ),
      weather: ThemeWeather.cloudy,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 80)),
      seasonalWeight: 0.3,
    );

    final ThemeEntity eid = ThemeEntity(
      id: 'thm_eid',
      slug: 'eid',
      displayName: 'Eid',
      parentId: null,
      tokens: const ThemeTokens(
        skyTop: '#FFE0B2',
        skyBottom: '#FFF3E0',
        ground: '#66BB6A',
        pathPrimary: '#FFB74D',
        pathShadow: '#A3640B',
        buildingPrimary: '#FFCC80',
        buildingSecondary: '#FB8C00',
        nodeLocked: '#90A4AE',
        nodeAvailable: '#2E7D32',
        nodeCompleted: '#1B5E20',
        bossGate: '#D32F2F',
        particleColor: '#FFF176',
        cloudColor: '#FFFFFF',
        atmosphereTint: '#FFE0B2',
      ),
      weather: ThemeWeather.sunny,
      status: WorkflowState.published,
      updatedAt: now.subtract(const Duration(days: 70)),
      seasonalWeight: 0.3,
    );

    for (final ThemeEntity t in <ThemeEntity>[
      classicMeadow,
      winter,
      monsoon,
      night,
      ramadan,
      eid,
    ]) {
      _themes[t.id] = t;
    }
  }

  @override
  Future<List<ThemeEntity>> listThemes() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _themes.values
        .sorted((ThemeEntity a, ThemeEntity b) =>
            a.displayName.compareTo(b.displayName))
        .toList();
  }

  @override
  Future<ThemeEntity> getTheme(String id) async {
    final ThemeEntity? t = _themes[id];
    if (t == null) throw StateError('Theme not found');
    return t;
  }

  @override
  Future<ThemeEntity> upsertTheme(ThemeEntity theme) async {
    final String id = theme.id.isEmpty ? 'thm_${Ulid.generate()}' : theme.id;
    final ThemeEntity stored = theme.copyWith(id: id, updatedAt: DateTime.now());
    _themes[id] = stored;
    return stored;
  }

  @override
  Future<void> deleteTheme(String id) async {
    _themes.remove(id);
  }
}

final themeRepositoryProvider = Provider<ThemeRepository>((Ref ref) {
  return ThemeRepositoryImpl();
});
