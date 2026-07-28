/// Cadence at which a mission resets.
enum MissionCadence { daily, weekly, monthly }

/// Lifecycle of a single mission.
enum MissionStatus { locked, available, inProgress, completed, claimed, expired }

/// Coarse category used for icon + filter resolution.
enum MissionCategory {
  quiz,
  lesson,
  streak,
  exploration,
  social,
  energy,
  mixed,
}