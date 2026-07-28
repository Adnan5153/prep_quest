# BCS Booster AI — Step-by-Step Agent Implementation Plan

Copy this file into your AI agent and let it build the app module by module.

---

You are building BCS Booster AI, a Flutter app with Firebase backend and AI-powered study features.

## Phase 1 — Project Setup

1. Create a new Flutter project.
2. Enable support for:
   - Android
   - Flutter Web
3. Set up the project structure with feature-first folders.
4. Add the following dependencies:
   - flutter_riverpod
   - go_router
   - dio
   - google_fonts
   - flutter_secure_storage
   - hive
   - intl
   - flutter_localizations
   - fl_chart
   - lottie
   - cached_network_image
5. Create a clean base theme with the brand colors from the SRS:
   - primary: #0E7C4A
   - secondary: #1B3B6F
   - accent: #F5A623
6. Set up Bangla-friendly fonts and localization support.
7. Create the app shell with:
   - splash screen
   - onboarding
   - home dashboard
   - mobile bottom navigation
   - web/admin shell

## Phase 2 — Authentication and Profile

8. Implement phone number login and OTP verification flow.
9. Store auth state securely.
10. Create onboarding profile setup screen.
11. Capture:

- full name
- exam track
- district (optional)

12. Create settings screen for profile editing and preferences.
13. Add protected routes for logged-in users.

## Phase 3 — Playground & Level-Based Learning Experience

14. Create a Playground screen that feels like a game map with multiple levels and distinct level nodes.
15. Make the Playground the primary post-onboarding experience and the main entry point for daily learning, so users start from the map and enter challenges from there.
16. Design each level as a progress-based challenge area represented by a map node, where users must complete tasks to unlock the next stage.
17. Make each level contain small learning challenges such as:

- read a chapter
- answer a quiz question
- solve a mini challenge
- use the AI tutor
- complete a short mock-test task

17. Add a Duolingo-inspired visual style: bright colors, progress bars, streaks, celebration animations, and rewarding feedback.
18. Show XP gain, level completion, and unlock states clearly after each challenge.
19. Make the experience feel playful and motivating, not like a traditional exam app.

## Phase 4 — Guidebook Module

20. Create the guidebook home screen with subject cards.
21. Create a subject chapter list screen.
22. Create the chapter reader screen with Bangla-rendered content.
23. Add bookmarking support.
24. Implement premium gating so full chapters are locked for free users.
25. Add a search screen for guidebook and question bank content.

## Phase 4 — Question Bank Module

26. Create the question bank home screen with filters for exam type, year, and subject.
27. Create a question list screen.
28. Create a question detail/practice screen with:

- options
- correct answer
- explanation

29. Add instant feedback for practice mode.
30. Make sure question content is readable and styled well.

## Phase 5 — Free Quiz and Mock Test Flow

31. Create the free daily quiz flow with 20 questions.
32. Limit free users to one quiz per day.
33. Create a mock test hub with countdown and test status.
34. Create a premium mock test flow with:

- instructions screen
- timed exam UI
- review flags
- auto-submit
- result summary

35. Add leaderboard result storage and display.

## Phase 6 — Weakness Tracker

30. Create a data model for test attempts and category performance.
31. Track:

- accuracy
- attempts
- time spent

32. Create a weakness dashboard with charts.
33. Generate weak-category recommendations.
34. Create recommended mini-test and reading suggestions.

## Phase 7 — AI Features

35. Create backend endpoints for AI proxy calls:

- explanation generation
- simulator question generation
- smart prompt assistance

36. Never call the LLM directly from the client.
37. Implement AI Tutor:

- appears after wrong answer
- gives short Bangla explanation
- supports one follow-up question
- is premium-gated

38. Implement AI Dynamic Exam Simulator:

- setup screen
- configurable track, subject, duration, and question count
- AI-generated MCQ paper
- validation of the generated JSON on the backend

39. Implement Smart Prompt Assistant with preset Bangla prompts.

## Phase 8 — Subscription Flow

40. Create premium paywall and plan selection UI.
41. Add daily and weekly subscription options.
42. Create subscription confirmation and success screens.
43. Add a demo billing experience for Flutter Web.
44. Implement subscription state management and premium unlock logic.
45. Add a visible unsubscribe option for active subscribers.
46. Log all subscription events.

## Phase 9 — Gamification

47. Create gamification state models for:

- XP
- level
- hearts
- badges
- rewards

48. Award XP for reading, practicing, and completing tests.
49. Implement level progression and unlock logic.
50. Show achievements and rewards UI.
51. Log all gamification events.

## Phase 10 — Admin Panel

52. Create admin login.
53. Build admin dashboard with metrics:

- DAU
- active subscribers
- churn
- revenue
- AI token usage

54. Create content management screens for:

- guidebook chapters
- questions and answer keys

55. Create mock test scheduler UI.
56. Create leaderboard review/publish flow.
57. Create AI analytics and admin logs views.

## Phase 11 — Backend and Database

58. Set up Firebase Authentication for phone OTP.
59. Set up Firestore database with collections such as:

- users
- subscriptions
- subjects
- chapters
- questions
- mock_tests
- test_attempts
- answers
- ai_tutor_logs
- weakness_profiles
- gamification_state
- achievements
- rewards
- leaderboard_entries
- admin_logs
- analytics_events

60. Create Cloud Functions for:

- AI proxy requests
- subscription webhook handling
- leaderboard processing
- analytics logging

61. Add role-based access for admin users where possible.
62. Ensure secure storage of secrets and environment variables.

## Phase 12 — Testing and QA

63. Test all core flows end to end.
64. Verify Bangla rendering and responsive behavior.
65. Test premium gating and subscription behavior.
66. Test AI flows with fallback handling for lag or failure.
67. Test the admin panel and content management screens.
68. Prepare the app for Android release and Flutter Web demo deployment.

## Final Requirements

69. Build the MVP in a clean, modular, maintainable way.
70. Prefer real functionality over dummy placeholders.
71. Keep the app polished enough for demo and evaluation.
72. If something is too large to implement fully, prioritize the main MVP features first and clearly separate demo/mock data from real backend integration.
