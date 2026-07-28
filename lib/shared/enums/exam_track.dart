/// Supported exam tracks for Prep Quest learners.
///
/// Mirrors the catalog described in `Plans/BCS_Booster_AI_SRS (1).md`
/// and `Plans/appflow.md` (section 3.5). Used by the
/// authentication profile-completion flow and throughout the rest of
/// the application to filter content, leaderboards, and mock tests.
enum ExamTrack {
  bcs,
  bank,
  primaryTeacher,
  other;

  String get id {
    switch (this) {
      case ExamTrack.bcs:
        return 'bcs';
      case ExamTrack.bank:
        return 'bank';
      case ExamTrack.primaryTeacher:
        return 'primary_teacher';
      case ExamTrack.other:
        return 'other';
    }
  }

  String get displayName {
    switch (this) {
      case ExamTrack.bcs:
        return 'BCS';
      case ExamTrack.bank:
        return 'Bank';
      case ExamTrack.primaryTeacher:
        return 'Primary Teacher';
      case ExamTrack.other:
        return 'Other';
    }
  }

  static ExamTrack fromId(String? value) {
    if (value == null) return ExamTrack.other;
    for (final ExamTrack track in ExamTrack.values) {
      if (track.id == value) return track;
    }
    return ExamTrack.other;
  }
}
