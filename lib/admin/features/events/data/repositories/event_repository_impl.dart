import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ulid.dart';
import '../../../../shared/enums/workflow_state.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/event_repository.dart';

class EventRepositoryImpl implements EventRepository {
  EventRepositoryImpl() {
    _seed();
  }

  final Map<String, EventEntity> _events = <String, EventEntity>{};

  void _seed() {
    final DateTime now = DateTime.now();
    final EventEntity winterArc = EventEntity(
      id: 'evt_winter_2026',
      slug: 'winter-arc-2026',
      displayName: 'Winter Arc 2026',
      kind: EventKind.season,
      startsAt: DateTime(2026, 1, 1),
      endsAt: DateTime(2026, 2, 15),
      scope: <String, dynamic>{'verticals': <String>['BCS', 'BANK']},
      payload: <String, dynamic>{
        'theme': 'thm_winter',
        'bonusMultiplier': 1.25,
      },
      lifecycle: EventLifecycle.scheduled,
      updatedAt: now.subtract(const Duration(days: 2)),
      bannerAssetId: 'ast_bcs_cover',
      summary: 'Two-month winter season with bonus rewards.',
    );
    final EventEntity ramadan = EventEntity(
      id: 'evt_ramadan',
      slug: 'ramadan-2026',
      displayName: 'Ramadan 2026',
      kind: EventKind.holiday,
      startsAt: DateTime(2026, 2, 28),
      endsAt: DateTime(2026, 3, 28),
      scope: <String, dynamic>{'verticals': <String>['BCS']},
      payload: <String, dynamic>{
        'theme': 'thm_ramadan',
        'dailyBonus': true,
      },
      lifecycle: EventLifecycle.scheduled,
      updatedAt: now.subtract(const Duration(days: 5)),
      summary: 'Ramadan nightly challenges.',
    );
    final EventEntity leaderboard = EventEntity(
      id: 'evt_weekly_race',
      slug: 'weekly-leaderboard',
      displayName: 'Weekly Leaderboard Race',
      kind: EventKind.tournament,
      startsAt: now.subtract(const Duration(days: 2)),
      endsAt: now.add(const Duration(days: 5)),
      scope: <String, dynamic>{'global': true},
      payload: <String, dynamic>{
        'tiers': <String>['bronze', 'silver', 'gold'],
        'rewardTableId': 'rwd_weekly',
      },
      lifecycle: EventLifecycle.live,
      updatedAt: now.subtract(const Duration(hours: 4)),
      summary: 'Top scorers win premium trials.',
    );
    _events[winterArc.id] = winterArc;
    _events[ramadan.id] = ramadan;
    _events[leaderboard.id] = leaderboard;
  }

  @override
  Future<List<EventEntity>> listEvents() async {
    await Future<void>.delayed(const Duration(milliseconds: 60));
    return _events.values.toList()
      ..sort((EventEntity a, EventEntity b) => a.startsAt.compareTo(b.startsAt));
  }

  @override
  Future<EventEntity> upsertEvent(EventEntity event) async {
    final String id = event.id.isEmpty ? 'evt_${Ulid.generate()}' : event.id;
    final EventEntity stored = event.copyWith(id: id, updatedAt: DateTime.now());
    _events[id] = stored;
    return stored;
  }

  @override
  Future<void> deleteEvent(String id) async {
    _events.remove(id);
  }
}

final eventRepositoryProvider = Provider<EventRepository>((Ref ref) {
  return EventRepositoryImpl();
});
