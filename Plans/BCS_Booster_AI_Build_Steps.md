# BCS Booster AI — Build Steps Guide

This document converts the SRS into a practical implementation roadmap for building BCS Booster AI.

## 1. Project Setup

### 1.1 Create the base project

- Create a Flutter project with support for:
  - Android app build
  - Flutter Web build
- Use one shared codebase for both targets.
- Set up Git repository and branch strategy.

### 1.2 Install required tools

- Flutter SDK
- Android Studio / Android SDK
- VS Code with Flutter and Dart extensions
- Firebase CLI
- Node.js (for Cloud Functions if used)
- Git
- Optional: FVM for Flutter version management

### 1.3 Define the initial architecture

- Use feature-first folder structure.
- Choose state management: Riverpod (recommended).
- Use go_router for navigation.
- Use dio for API calls.
- Use hive for local caching.
- Use flutter_secure_storage for auth tokens.

---

## 2. Foundation and App Shell

### 2.1 Build the app shell

- Create splash screen
- Create onboarding flow
- Create login/OTP screens
- Create home dashboard shell
- Create a dedicated Playground/world-map screen with level nodes and progress states
- Make the Playground screen the primary post-onboarding entry point for daily learning
- Create bottom navigation for mobile
- Create web/admin shell for desktop

### 2.2 Add the design system

- Set up theme colors based on the SRS:
  - Primary: #0E7C4A
  - Secondary: #1B3B6F
  - Accent: #F5A623
- Add typography using Bangla-friendly fonts such as Noto Sans Bengali or Hind Siliguri.
- Create reusable UI components:
  - cards
  - buttons
  - progress bars
  - badges
  - locked content widgets
  - AI message bubbles

### 2.3 Configure localization

- Add Bangla and English support.
- Prepare ARB files for strings.
- Ensure text scaling remains stable on mobile.

---

## 3. Authentication and User Profile

### 3.1 Implement auth flow

- Phone number input
- OTP verification
- Session persistence
- Protected routes for logged-in users

### 3.2 Implement profile setup

- Capture full name
- Capture exam track (BCS / Bank / Primary Teacher)
- Capture district if needed
- Save profile to backend

### 3.3 Add settings

- Edit exam track/profile
- Notification preferences
- Language preference

---

## 4. Core Learning Modules

### 4.1 Guidebook module

- Create subject catalog screens
- Create chapter list screen
- Create chapter reader screen
- Render Bangla content correctly
- Add bookmark support
- Add premium gating for full chapters

### 4.2 Question bank module

- Create searchable/filterable list of questions
- Add question details screen
- Add answer and explanation display
- Add practice mode with feedback

### 4.3 Free daily quiz module

- Create 20-question quiz flow
- Limit to one quiz per day for free users
- Add result summary and scoring

---

## 5. Mock Tests and Leaderboard

### 5.1 Build mock test flow

- Create mock test hub screen
- Create pre-test instructions screen
- Create timed test-taking screen
- Add question navigation and review flags
- Add auto-submit behavior
- Add result screen

### 5.2 Build leaderboard flow

- Store test results in backend
- Calculate ranking per exam track
- Publish leaderboard results
- Show own rank and global rank list

### 5.3 Add premium gating

- Make live mock tests premium-only
- Keep the free daily quiz available

---

## 6. Weakness Tracker

### 6.1 Collect analytics data

- Track accuracy by category
- Track attempts and time spent
- Store performance history

### 6.2 Build dashboard

- Show subject-wise performance
- Show trend charts
- Show weakest categories

### 6.3 Generate recommendations

- Auto-create mini-tests for weak categories
- Suggest relevant guidebook chapters

---

## 7. AI Features

### 7.1 Set up backend proxy

- Create backend endpoints for:
  - explanation generation
  - simulator exam generation
  - smart prompt assistance
- Never call the LLM directly from the client.
- Log every AI request and response metadata for admin analytics.

### 7.2 Implement AI Tutor

- Trigger explanation after wrong answer
- Generate short Bangla explanation
- Show explanation in a dedicated sheet
- Allow one follow-up question
- Gate behind premium subscription

### 7.3 Implement AI Exam Simulator

- Create simulator setup screen
- Accept track, subjects, duration, question count
- Generate MCQs as structured JSON
- Validate output server-side before showing it to the user
- Run with same timer/submit logic as mock tests

### 7.4 Implement Smart Prompt Assistant

- Create preset Bangla prompt buttons
- Map buttons to hidden system prompts
- Pass current chapter/question context
- Render AI output in a response view

---

## 8. Subscription and Monetization

### 8.1 Prepare bdapps integration

- Obtain bdapps sandbox/production credentials
- Implement subscription plan UI
- Add daily and weekly plan options
- Create billing confirmation screen
- Create success/failure handling

### 8.2 Implement web demo billing flow

- For Flutter Web, show a clearly labeled simulated billing step.
- Ensure the rest of the premium flow is testable without a real carrier bill.

### 8.3 Implement subscription state handling

- Unlock premium features after webhook confirmation
- Show subscription status in profile/subscription screen
- Add visible unsubscribe control
- Log subscribe/unsubscribe/renewal events

---

## 9. Gamification Layer

### 9.1 Implement core gamification data

- XP
- Level
- Hearts/lives
- Badges
- Reward store items

### 9.2 Add progression logic

- Award XP for reading, practice, tests, daily streaks
- Unlock new levels and content
- Regenerate hearts over time

### 9.3 Add UI and analytics

- Show level progress bar and milestones
- Display badges and achievements
- Log all gamification events for admin analytics

---

## 10. Admin Panel

### 10.1 Create admin authentication

- Admin login
- Role-based access if possible

### 10.2 Build admin dashboard

- DAU
- active subscribers
- churn
- revenue
- AI token usage and cost

### 10.3 Build content management tools

- CRUD guidebook chapters
- CRUD questions and answer keys
- Schedule and publish mock tests
- Manage leaderboard verification and publishing

---

## 11. Backend and Data Model

### 11.1 Set up backend services

- Firebase Firestore for app data
- Firebase Authentication for phone OTP
- Cloud Functions for API proxy and webhook handling
- Firebase Cloud Messaging for notifications

### 11.2 Prepare core collections

- users
- subscriptions
- subjects
- chapters
- questions
- mock_tests
- test_attempts
- ai_tutor_logs
- weakness_profiles
- gamification_state

### 11.3 Add analytics logging

- Log test attempts
- Log AI usage
- Log subscription events
- Log gamification events

---

## 12. Testing and Quality Assurance

### 12.1 Functional testing

- Test onboarding and auth
- Test guidebook access and premium gating
- Test quiz flow
- Test mock test flow
- Test AI tutor flow
- Test simulator flow
- Test subscription flow

### 12.2 Device and browser testing

- Test on Android phones
- Test responsive behavior on tablet/web
- Test Bangla rendering
- Test low-connectivity behavior

### 12.3 Security testing

- Confirm no API keys are exposed in app
- Validate admin authorization
- Check secure storage usage

---

## 13. Deployment Plan

### 13.1 Android deployment

- Generate signing keys
- Configure app identity and package name
- Build release APK/AAB
- Publish through bdapps distribution route

### 13.2 Web deployment

- Build Flutter Web app
- Deploy to a hosting platform
- Provide a public URL for judges/admin review

### 13.3 Backend deployment

- Deploy Firebase functions
- Configure environment variables
- Connect AI provider credentials securely
- Test webhook endpoints

---

## 14. MVP Delivery Checklist

### Must-have for first build

- [ ] Authentication and onboarding
- [ ] Guidebook
- [ ] Question bank
- [ ] Free daily quiz
- [ ] One full mock test flow
- [ ] AI Tutor
- [ ] AI Simulator
- [ ] Smart Prompt Assistant
- [ ] Subscription and unsubscribe flow
- [ ] Admin content management and analytics

### Recommended next after MVP

- [ ] Full weakness tracker dashboard
- [ ] Notifications
- [ ] Bookmarks
- [ ] Gamification polish
- [ ] Advanced admin roles

---

## 15. Suggested Build Order

1. Set up project, architecture, and design system
2. Build auth, onboarding, and profile
3. Build guidebook and question bank
4. Build free quiz and mock test flow
5. Build leaderboard and analytics storage
6. Build AI tutor and AI simulator backend proxy
7. Build smart prompt assistant
8. Integrate bdapps subscription flow
9. Build admin panel and telemetry screens
10. Test, fix bugs, and deploy
