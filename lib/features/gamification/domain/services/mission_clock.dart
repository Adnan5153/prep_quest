/// Abstract clock so the missions pipeline can be tested with frozen
/// time. The production wiring uses `SystemMissionClock`.
abstract class MissionClock {
  DateTime now();
}

class SystemMissionClock implements MissionClock {
  const SystemMissionClock();

  @override
  DateTime now() => DateTime.now();
}