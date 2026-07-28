/// All user-facing strings used across the Review feature.
///
/// Centralised so translations and copy edits happen in one place.
class ReviewStrings {
  const ReviewStrings._();

  static const String screenTitle = 'Review';
  static const String screenSubtitle =
      'Revisit your past attempts, learn from mistakes, and reinforce your strengths.';

  static const String filterAll = 'All';
  static const String filterCorrect = 'Correct';
  static const String filterIncorrect = 'Incorrect';
  static const String filterBookmarked = 'Bookmarks';
  static const String filterRecent = 'Recent';

  static const String sectionCorrect = 'Correctly answered';
  static const String sectionIncorrect = 'Needs review';
  static const String sectionBookmarked = 'Bookmarked';
  static const String sectionRecent = 'Recent attempts';

  static const String detailTitle = 'Question Detail';
  static const String aiExplanationTitle = 'AI Insight';
  static const String aiExplanationCta = 'Get deeper explanation';
  static const String aiExplanationLoading = 'Crafting a deeper explanation…';
  static const String aiExplanationError =
      'Could not generate an AI explanation right now.';

  static const String questionLabel = 'Question';
  static const String yourAnswer = 'Your answer';
  static const String correctAnswer = 'Correct answer';
  static const String skipped = 'Skipped';
  static const String explanation = 'Explanation';

  static const String bookmarkAdd = 'Bookmark question';
  static const String bookmarkRemove = 'Remove bookmark';

  static const String retry = 'Retry';
  static const String emptyTitle = 'Nothing to review yet';
  static const String emptySubtitle =
      'Complete a quiz and your attempts will appear here for review.';
  static const String emptyFilteredTitle = 'No questions match this filter';
  static const String emptyFilteredSubtitle =
      'Switch filters or attempt a quiz to populate this section.';

  static const String errorTitle = 'Could not load reviews';
  static const String errorSubtitle =
      'Check your connection and try again in a moment.';

  static const String statsTotal = 'Total attempts';
  static const String statsAccuracy = 'Accuracy';
  static const String statsBookmarks = 'Bookmarks';
  static const String statsTimeSpent = 'Time spent';

  static const String sessionLabel = 'Session';
  static const String attemptedAgo = 'Attempted';
  static const String quizLabel = 'Quiz';
}