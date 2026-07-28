import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/enums/workflow_state.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/event_entity.dart';

final eventsListProvider = FutureProvider<List<EventEntity>>((Ref ref) {
  return ref.watch(eventRepositoryProvider).listEvents();
});

class EventsController {
  const EventsController(this.ref);

  final Ref ref;

  Future<void> create({
    required String name,
    required String slug,
    required EventKind kind,
    required DateTime startsAt,
    required DateTime endsAt,
  }) async {
    await ref.read(eventRepositoryProvider).upsertEvent(
          EventEntity(
            id: '',
            slug: slug,
            displayName: name,
            kind: kind,
            startsAt: startsAt,
            endsAt: endsAt,
            scope: const <String, dynamic>{'global': true},
            payload: const <String, dynamic>{},
            lifecycle: EventLifecycle.scheduled,
            updatedAt: DateTime.now(),
          ),
        );
    ref.invalidate(eventsListProvider);
  }
}

final eventsControllerProvider = Provider<EventsController>(
  (Ref ref) => EventsController(ref),
);
