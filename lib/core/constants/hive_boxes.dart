/// Names of local [Hive] boxes used by the application.
///
/// Centralizing box names avoids typo-driven data corruption when opening
/// or closing boxes from feature code.
class HiveBoxes {
  const HiveBoxes._();

  static const String userProfile = 'user_profile_box';
  static const String guidebookCache = 'guidebook_cache_box';
  static const String questionBankCache = 'question_bank_cache_box';
  static const String preferences = 'preferences_box';
  static const String gamificationCache = 'gamification_cache_box';
}
