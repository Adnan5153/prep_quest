/// User-visible strings used across the application.
///
/// As localization is wired in, these constants act as the English
/// fallback until the ARB files / intl pipeline go live.
class AppStrings {
  const AppStrings._();

  // ---------------------------------------------------------------------------
  // Application
  // ---------------------------------------------------------------------------

  static const String appName = 'Prep Quest';
  static const String appTagline = 'Your smart BCS prep companion';

  // ---------------------------------------------------------------------------
  // Widget Builder
  // ---------------------------------------------------------------------------

  static const String widgetBuilderTitle = 'Widget Builder';

  static const String widgetBuilderSubtitle =
      'Compose Flutter widgets visually and preview them live.';

  static const String widgetBuilderPreview = 'Preview';
  static const String widgetBuilderWidget = 'Widget';
  static const String widgetBuilderLabel = 'Label';
  static const String widgetBuilderPreviewLabel = 'Preview Label';
  static const String widgetBuilderSelectWidget = 'Select Widget';

  // ---------------------------------------------------------------------------
  // Widget Names
  // ---------------------------------------------------------------------------

  static const String primaryButton = 'Primary Button';
  static const String outlinedButton = 'Outlined Button';
  static const String card = 'Card';
  static const String badgeChip = 'Badge Chip';
  static const String progressBar = 'Progress Bar';
  static const String customAppBar = 'Custom App Bar';
  static const String customBottomNavigation = 'Custom Bottom Navigation';
  static const String customCheckbox = 'Custom Checkbox';
  static const String comingSoon = 'Coming Soon';
  static const String categoryChip = 'Category Chip';
  static const String customDivider = 'Custom Divider';
  static const String customDrawer = 'Custom Drawer';
  static const String customDropdown = 'Custom Dropdown';
  static const String customNavigationRail = 'Custom Navigation Rail';

  // ---------------------------------------------------------------------------
  // Bookmarks
  // ---------------------------------------------------------------------------

  static const String bookmarksTitle = 'Bookmarks';
  static const String bookmarksEmpty = 'No bookmarks yet';
  static const String bookmarksEmptySubtitle =
      'Tap the bookmark icon on any question, lesson, AI response, or note to save it here.';
  static const String bookmarksEmptyFiltered = 'No matching bookmarks';
  static const String bookmarksError = 'Could not load bookmarks';
  static const String bookmarksSyncDone = 'Bookmarks synced';
  static const String bookmarksOfflineBanner =
      'Showing offline bookmarks — connect to sync';
  static const String bookmarksAdded = 'Bookmark saved';
  static const String bookmarksRemoved = 'Bookmark removed';
  static const String bookmarksCleared = 'Bookmarks cleared';
  static const String bookmarksSearchHint = 'Search bookmarks...';
  static const String bookmarksFilterTitle = 'Filter bookmarks';
  static const String bookmarksSortNewest = 'Newest first';
  static const String bookmarksSortOldest = 'Oldest first';
  static const String bookmarksSortAlpha = 'Alphabetical';
  static const String bookmarksRetryCta = 'Try again';
  static const String bookmarksBrowseContent = 'Browse content';
  static const String bookmarksClearFilterCta = 'Clear filter';
  static const String bookmarkAddTooltip = 'Bookmark this';
  static const String bookmarkRemoveTooltip = 'Remove bookmark';
  static const String bookmarkTypeQuestion = 'Questions';
  static const String bookmarkTypeLesson = 'Lessons';
  static const String bookmarkTypeAi = 'AI';
  static const String bookmarkTypeNote = 'Notes';


  // ---------------------------------------------------------------------------

  static const String search = 'Search';
  static const String more = 'More';
  static const String subtitle = 'Subtitle';
  static const String pageContentArea = 'Page Content Area';
  static const String pageContent = 'Page Content';

  // ----- SnackBar -----
  static const String snackBarActionRetry = 'Retry';
  static const String snackBarActionUndo = 'Undo';
  static const String snackBarActionDismiss = 'Dismiss';
  static const String snackBarActionOk = 'OK';
  static const String snackBarCloseTooltip = 'Close notification';
  static const String snackBarSemanticLabel = 'Notification';

  static const String snackBarSuccessTitle = 'Success';
  static const String snackBarErrorTitle = 'Something went wrong';
  static const String snackBarWarningTitle = 'Heads up';
  static const String snackBarInfoTitle = 'Heads up';
  static const String snackBarNotificationTitle = 'New notification';

  // ---------------------------------------------------------------------------
  // Widget Builder Options
  // ---------------------------------------------------------------------------

  static const String appBarOptions = 'App Bar Options';
  static const String showLeadingAvatar = 'Show Leading Avatar';
  static const String showAccentStripe = 'Show Accent Stripe';

  // ---------------------------------------------------------------------------
  // Drawer Preview
  // ---------------------------------------------------------------------------

  static const String playground = 'Playground';
  static const String guidebook = 'Guidebook';
  static const String questionBank = 'Question Bank';
  static const String mockTests = 'Mock Tests';
  static const String leaderboard = 'Leaderboard';
  static const String subscription = 'Subscription';
  static const String settings = 'Settings';
  static const String logout = 'Logout';

  // ---------------------------------------------------------------------------
  // Common
  // ---------------------------------------------------------------------------

  static const String bcs = 'BCS';
  static const String bank = 'Bank';
  static const String primaryTeacher = 'Primary Teacher';
  static const String english = 'English';
  static const String mathematics = 'Mathematics';
  static const String premium = 'Premium';
  static const String free = 'Free';
  static const String signInPrompt = 'Sign in to start';
  static const String homeXpCardTitle = 'Experience';
  static const String homeStreakCardTitle = 'Daily streak';
  static const String homeDailyGoalTitle = 'Daily missions';
  static const String homeContinueLearningTitle = 'Continue learning';
  static const String homeContinueLearningCta = 'Open category';
  static const String homeQuickActionQuiz = 'Daily quiz';
  static const String homeQuickActionLessons = 'Lessons';
  static const String homeQuickActionBookmarks = 'Bookmarks';
  static const String homeQuickActionNotes = 'Notes';
  static const String homeRecentActivityTitle = 'Recent activity';
  static const String homeRecentActivityEmpty = 'No activity yet';
  static const String homePremiumBannerTitle = 'Unlock Prep Quest Premium';
  static const String homePremiumBannerSubtitle =
      'Boss challenges, advanced analytics, and unlimited mocks.';
  static const String homePremiumBannerCta = 'Upgrade';
  static const String section = 'Section';
  static const String or = 'OR';

  static const String customRadio = 'Custom Radio';

  // ---------------------------------------------------------------------------
  // Bottom App Bar / Quick Actions
  // ---------------------------------------------------------------------------

  static const String quickActions = 'Quick Actions';
  static const String quickActionsSubtitle = 'Jump straight to what matters.';
  static const String continueLearning = 'Continue Learning';
  static const String dailyQuiz = 'Daily Quiz';
  static const String quickActionGuidebook = 'Guidebook';
  static const String mockTest = 'Mock Test';
  static const String aiTutor = 'AI Tutor';
  static const String bookmarks = 'Bookmarks';
  static const String weakTopics = 'Weak Topics';
  static const String profile = 'Profile';
  static const String notifications = 'Notifications';
  static const String notificationTooltip = 'Open notifications';
  static const String quickActionsTooltip = 'Open quick actions';

  // ---------------------------------------------------------------------------
  // Global Search
  // ---------------------------------------------------------------------------

  static const String searchHint = 'Search lessons, topics, questions…';
  static const String searchRecent = 'Recent searches';
  static const String searchTrending = 'Trending now';
  static const String searchClearHistory = 'Clear';
  static const String searchEmptyResults = 'No matches yet';
  static const String searchEmptyHint =
      'Try different keywords or browse another category.';
  static const String searchErrorMessage =
      'Search is unavailable right now. Please try again.';
  static const String searchFilterTitle = 'Filter by category';
  static const String searchHistoryCleared = 'Search history cleared';

  static const String categoryAll = 'All';
  static const String categoryLessons = 'Lessons';
  static const String categoryQuestions = 'Questions';
  static const String categoryTopics = 'Topics';
  static const String categoryBooks = 'Books';
  static const String categoryAiHistory = 'AI History';

  // ---------------------------------------------------------------------------
  // Notes System
  // ---------------------------------------------------------------------------

  static const String notesTitle = 'My Notes';
  static const String notesEmpty = 'No notes yet';
  static const String notesEmptySubtitle =
      'Capture what you learn. Save personal thoughts, lesson highlights, and AI explanations in one place.';
  static const String notesEmptyFiltered = 'No notes match your filters';
  static const String notesEmptySearch = 'No notes match your search';
  static const String notesError = 'Could not load your notes';
  static const String notesSearchHint = 'Search notes...';
  static const String notesSortNewest = 'Newest first';
  static const String notesSortOldest = 'Oldest first';
  static const String notesSortAlpha = 'Alphabetical';
  static const String notesSortFavorites = 'Favorites first';
  static const String notesSortPinned = 'Pinned first';
  static const String notesCreateCta = 'Create note';
  static const String notesEditCta = 'Edit note';
  static const String notesSaveCta = 'Save';
  static const String notesDeleteCta = 'Delete';
  static const String notesShareCta = 'Share';
  static const String notesPinCta = 'Pin to top';
  static const String notesUnpinCta = 'Unpin';
  static const String notesFavoriteCta = 'Mark as favorite';
  static const String notesUnfavoriteCta = 'Remove from favorites';
  static const String notesPinnedFilter = 'Pinned';
  static const String notesFavoritesFilter = 'Favorites';
  static const String notesHighlightsFilter = 'Highlights';
  static const String notesAiFilter = 'AI Notes';
  static const String notesPersonalFilter = 'Personal';
  static const String notesFilterTitle = 'Filter notes';
  static const String notesSortTitle = 'Sort notes';
  static const String notesRetryCta = 'Try again';
  static const String notesBrowseCta = 'Browse lessons';
  static const String notesClearFilterCta = 'Clear filters';
  static const String notesTitleHint = 'Note title';
  static const String notesContentHint = 'Start writing your note...';
  static const String notesCategoryHint = 'Category';
  static const String notesTagsHint = 'Tags (comma separated)';
  static const String notesAttachedLessonHint = 'Attached lesson';
  static const String notesAttachedQuestionHint = 'Attached question';
  static const String notesAttachedBookmarkHint = 'Attached bookmark';
  static const String notesSourceFeature = 'notes';
  static const String notesCreated = 'Note created';
  static const String notesUpdated = 'Note updated';
  static const String notesDeleted = 'Note deleted';
  static const String notesPinned = 'Pinned to top';
  static const String notesUnpinned = 'Removed from pinned';
  static const String notesFavorited = 'Added to favorites';
  static const String notesUnfavorited = 'Removed from favorites';
  static const String notesHighlightSaved = 'Highlight saved as note';
  static const String notesAiSaved = 'AI response saved as note';
  static const String notesSharedTitle = 'Share note';
  static const String notesDeleteTitle = 'Delete note?';
  static const String notesDeleteBody =
      'This note will be permanently removed. This cannot be undone.';
  static const String notesDeleteConfirm = 'Delete';
  static const String notesDeleteCancel = 'Cancel';
  static const String notesContentLabel = 'Content';
  static const String notesMetadataLabel = 'Details';
  static const String notesTagsLabel = 'Tags';
  static const String notesCreatedLabel = 'Created';
  static const String notesUpdatedLabel = 'Updated';
  static const String notesAttachmentsLabel = 'Attachments';
  static const String notesEmptyTags = 'No tags';
  static const String notesEmptyAttachments = 'No attachments';
  static const String notesTypePersonal = 'Personal';
  static const String notesTypeHighlight = 'Highlight';
  static const String notesTypeAi = 'AI Note';
  static const String notesCreateTitle = 'Create note';
  static const String notesEditTitle = 'Edit note';
  static const String notesDetailTitle = 'Note';
  static const String notesRecentSection = 'Recent notes';
  static const String notesPinnedSection = 'Pinned notes';
  static const String notesFavoritesSection = 'Favorites';
  static const String notesAllSection = 'All notes';
  static const String notesValidationTitleRequired = 'Please enter a title';
  static const String notesValidationContentRequired = 'Please write some content';
  static const String notesValidationTitleTooLong = 'Title must be under 120 characters';
  static const String notesValidationContentTooLong = 'Content must be under 10000 characters';
  static const String notesShareMessagePrefix = 'Note from Prep Quest:';
  static const String notesLinkCopied = 'Link copied';
  static const String notesColorDefault = 'Default';
  static const String notesColorYellow = 'Yellow';
  static const String notesColorGreen = 'Green';
  static const String notesColorBlue = 'Blue';
  static const String notesColorPink = 'Pink';
  static const String notesColorPurple = 'Purple';
  static const String notesPaletteTitle = 'Note color';
  static const String notesCategoryPersonal = 'Personal';
  static const String notesCategoryStudy = 'Study';
  static const String notesCategoryReview = 'Review';
  static const String notesCategoryInsight = 'Insight';
  static const String notesCategoryQuestion = 'Question';
  static const String notesCategoryAi = 'AI';
  static const String notesAttachmentLesson = 'Lesson';
  static const String notesAttachmentQuestion = 'Question';
  static const String notesAttachmentBookmark = 'Bookmark';
}
