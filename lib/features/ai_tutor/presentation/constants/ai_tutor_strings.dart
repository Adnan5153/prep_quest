/// All user-facing strings used across the AI Tutor feature.
///
/// Centralised so translations and copy edits happen in one place.
class AiTutorStrings {
  const AiTutorStrings._();

  // ---------------------------------------------------------------------------
  // Hub
  // ---------------------------------------------------------------------------

  static const String hubTitle = 'AI Tutor';
  static const String hubSubtitle =
      'Get contextual help with hints, explanations, flashcards, and study plans.';

  static const String hubActionHint = 'Ask for a hint';
  static const String hubActionHintSubtitle =
      'Nudge your thinking without spoiling the answer';
  static const String hubActionExplain = 'Explain an answer';
  static const String hubActionExplainSubtitle =
      'Walk through why the correct answer is correct';
  static const String hubActionSimplify = 'Simplify a topic';
  static const String hubActionSimplifySubtitle =
      'Plain-English breakdown of any concept';
  static const String hubActionSummary = 'Summarise a lesson';
  static const String hubActionSummarySubtitle =
      'Five-bullet recap you can read in 60 seconds';
  static const String hubActionFlashcards = 'Generate flashcards';
  static const String hubActionFlashcardsSubtitle =
      'Spaced-repetition deck for any topic';
  static const String hubActionStudyPlan = 'Build a study plan';
  static const String hubActionStudyPlanSubtitle =
      'A balanced day-by-day schedule';
  static const String hubActionQuestions = 'Generate practice questions';
  static const String hubActionQuestionsSubtitle =
      '5–10 fresh questions on any topic';
  static const String hubActionChat = 'Open AI chat';
  static const String hubActionChatSubtitle = 'Free-form conversation with the tutor';
  static const String hubActionHistory = 'Conversation history';
  static const String hubActionHistorySubtitle =
      'Pick up where you left off';

  static const String sectionQuickActions = 'Quick actions';
  static const String sectionRecentSessions = 'Recent sessions';
  static const String sectionRecentPrompts = 'Recent prompts';

  // ---------------------------------------------------------------------------
  // Generator — hint
  // ---------------------------------------------------------------------------

  static const String hintTitle = 'Hint';
  static const String hintFieldQuestion = 'Question text';
  static const String hintFieldAnswer = 'Your current guess (optional)';
  static const String hintGenerate = 'Generate hint';
  static const String hintLoading = 'Crafting a hint…';
  static const String hintEmptyTitle = 'No hint yet';
  static const String hintEmptySubtitle =
      'Type a question and we will craft a hint that points you in the right direction.';

  // ---------------------------------------------------------------------------
  // Generator — explanation
  // ---------------------------------------------------------------------------

  static const String explanationTitle = 'Explain the answer';
  static const String explanationFieldQuestion = 'Question';
  static const String explanationFieldCorrectAnswer = 'Correct answer';
  static const String explanationFieldYourAnswer = 'Your answer (optional)';
  static const String explanationGenerate = 'Explain';
  static const String explanationLoading = 'Walking through the answer…';

  // ---------------------------------------------------------------------------
  // Generator — simplify
  // ---------------------------------------------------------------------------

  static const String simplifyTitle = 'Simplify a topic';
  static const String simplifyFieldTopic = 'Topic';
  static const String simplifyFieldGrade = 'Grade level (optional)';
  static const String simplifyGenerate = 'Simplify';
  static const String simplifyLoading = 'Translating to plain English…';

  // ---------------------------------------------------------------------------
  // Flashcards
  // ---------------------------------------------------------------------------

  static const String flashcardsTitle = 'Flashcards';
  static const String flashcardsFieldTopic = 'Topic';
  static const String flashcardsFieldCount = 'Card count';
  static const String flashcardsFieldDifficulty = 'Difficulty';
  static const String flashcardsGenerate = 'Generate deck';
  static const String flashcardsLoading = 'Building your deck…';
  static const String flashcardsShowAnswer = 'Show answer';
  static const String flashcardsHideAnswer = 'Hide answer';
  static const String flashcardsDifficultyEasy = 'Easy';
  static const String flashcardsDifficultyMedium = 'Medium';
  static const String flashcardsDifficultyHard = 'Hard';
  static const String flashcardsEmptyTitle = 'No deck yet';
  static const String flashcardsEmptySubtitle =
      'Pick a topic and tap generate to build a spaced-repetition deck.';

  // ---------------------------------------------------------------------------
  // Study plan
  // ---------------------------------------------------------------------------

  static const String studyPlanTitle = 'Study plan';
  static const String studyPlanFieldSubject = 'Subject';
  static const String studyPlanFieldDays = 'Days ahead';
  static const String studyPlanFieldMinutes = 'Minutes per day';
  static const String studyPlanGenerate = 'Build plan';
  static const String studyPlanLoading = 'Drafting your schedule…';
  static const String studyPlanTotal = 'Total minutes';
  static const String studyPlanEmptyTitle = 'No plan yet';
  static const String studyPlanEmptySubtitle =
      'Enter a subject and we will draft a balanced day-by-day plan.';

  // ---------------------------------------------------------------------------
  // Generated questions
  // ---------------------------------------------------------------------------

  static const String questionsTitle = 'Practice questions';
  static const String questionsFieldTopic = 'Topic';
  static const String questionsFieldCount = 'Question count';
  static const String questionsFieldDifficulty = 'Difficulty';
  static const String questionsGenerate = 'Generate questions';
  static const String questionsLoading = 'Composing fresh questions…';
  static const String questionsEmptyTitle = 'No questions yet';
  static const String questionsEmptySubtitle =
      'Pick a topic and we will compose a fresh practice set.';

  // ---------------------------------------------------------------------------
  // Summary
  // ---------------------------------------------------------------------------

  static const String summaryTitle = 'Lesson summary';
  static const String summaryFieldLessonId = 'Lesson ID';
  static const String summaryFieldLessonTitle = 'Lesson title (optional)';
  static const String summaryGenerate = 'Summarise';
  static const String summaryLoading = 'Summarising…';

  // ---------------------------------------------------------------------------
  // Chat
  // ---------------------------------------------------------------------------

  static const String chatTitle = 'AI chat';
  static const String chatSubtitle =
      'Ask anything — follow-ups stay in this conversation.';
  static const String chatInputHint = 'Ask the tutor…';
  static const String chatSend = 'Send';
  static const String chatVoice = 'Voice input';
  static const String chatAttach = 'Attach';
  static const String chatAttachTooltip = 'Attach lesson / question';
  static const String chatEmptyTitle = 'Start a conversation';
  static const String chatEmptySubtitle =
      'Ask a question, request a hint, or ask for a plain-English explanation.';
  static const String chatErrorMessage =
      'The tutor could not respond right now. Try again.';

  // ---------------------------------------------------------------------------
  // History
  // ---------------------------------------------------------------------------

  static const String historyTitle = 'Conversations';
  static const String historySubtitle =
      'Pick up where you left off or revisit past explanations.';
  static const String historyPromptsTitle = 'Recent prompts';
  static const String historyEmptyTitle = 'No conversations yet';
  static const String historyEmptySubtitle =
      'Start a chat or use a quick action to see it appear here.';

  // ---------------------------------------------------------------------------
  // Errors / loading / retry
  // ---------------------------------------------------------------------------

  static const String retry = 'Retry';
  static const String dismiss = 'Dismiss';
  static const String loading = 'Thinking…';
  static const String errorTitle = 'Something went wrong';
  static const String errorSubtitle =
      'We could not reach the tutor. Check your connection and try again.';
  static const String favoriteAdd = 'Save prompt';
  static const String favoriteRemove = 'Unsave prompt';
  static const String delete = 'Delete conversation';
  static const String deleteConfirmTitle = 'Delete conversation?';
  static const String deleteConfirmMessage =
      'This conversation will be removed from your history.';
}
