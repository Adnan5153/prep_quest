import '../entities/event_entity.dart';

abstract class EventRepository {
  Future<List<EventEntity>> listEvents();
  Future<EventEntity> upsertEvent(EventEntity event);
  Future<void> deleteEvent(String id);
}
