# BCS Booster AI — Agent Prompt

Use this prompt with your AI coding agent to build the BCS Booster AI application.

---

You are a senior Flutter + Firebase full-stack engineer. Build a production-quality MVP for BCS Booster AI, an exam-preparation app for BCS, bank, and primary teacher recruitment candidates in Bangladesh.

## 1. Project Goal

Build a mobile-first Flutter application with a Flutter Web version for judges/admins. The experience should be centered around a Duolingo-inspired playground map, where users progress through a series of levels on an interactive world map. Each level should feel like a mini learning quest, combining reading, quizzes, challenges, and rewards, while keeping the app modern, polished, Bangla-friendly, and suitable for a bootcamp/demo presentation.

## 2. Core Product Vision

The app should help users:

- study structured guidebook content
- practice questions from a question bank
- attempt free daily quizzes and premium mock tests
- receive AI-generated explanations and exam simulations
- unlock premium features through a subscription flow
- track performance through a weakness dashboard
- grow through levels, XP, badging, and rewards
- use an admin panel to manage content and analytics
- enjoy a playful, game-like learning experience that feels fun, rewarding, and addictive in a positive way
- enter a "Playground" experience where they see a map of levels and must complete challenges inside each level to progress
- treat the Playground as the primary post-onboarding home experience, with the map as the main entry point for daily learning and progression

## 3. Platforms

- Primary target: Android app
- Secondary target: Flutter Web build
- One shared codebase should support both

## 4. Main User Roles

- Free User
- Premium Subscriber
- Admin / Content Manager

## 5. Must-Build Features

Implement the following features in the MVP:

### A. Authentication and onboarding

- Splash screen
- Onboarding carousel
- Phone number login with OTP
- Profile setup with exam track selection
- Basic settings screen

### B. Guidebook

- Subject list screen
- Chapter list screen
- Chapter reader with Bangla text support
- Bookmarking
- Premium gating for full content

### C. Question Bank

- Searchable/filterable question bank
- Question detail screen with options, answer, and explanation
- Practice mode with feedback

### D. Daily Quiz and Mock Tests

- Free daily quiz of 20 questions
- Mock test hub
- Premium live test flow with timer and auto-submit
- Result summary and leaderboard integration

### E. AI Modules

- AI Tutor: explain wrong answers in concise Bangla
- AI Exam Simulator: generate a custom mock exam
- Smart Prompt Assistant: preset Bangla prompts with AI assistance

### F. Subscription and Monetization

- Premium paywall
- Daily and weekly plan selection
- bdapps-style billing flow
- Demo billing flow for Flutter Web
- Unsubscribe flow

### G. Weakness Tracker

- Accuracy, attempts, and time analysis
- Weak-topic recommendations
- Mini-test suggestions

### H. Gamification

- XP, level, hearts, badges, rewards
- Progress UI and achievements screen

### I. Admin Panel

- Admin login
- Dashboard with business metrics
- Content management for guidebook and questions
- Mock test scheduling
- AI usage analytics
- Leaderboard control

## 6. UI/UX Requirements

The app should look like this:

- Mobile-first, clean, and modern
- Bangla-first experience with English support
- Green/blue/amber visual theme
- Duolingo-inspired aesthetics: bright, energetic, playful, encouraging, and reward-driven
- A strong game-like progression feel with levels, streaks, XP bars, badges, and celebration moments
- A dedicated Playground screen where users see multiple levels and unlock challenges inside each one
- Each level should contain bite-sized learning tasks such as reading, quizzes, mini challenges, AI tutor prompts, and short exam-style exercises
- Strong cards, progress indicators, premium badges, and clear CTAs
- Bottom navigation for mobile
- Sidebar-based admin layout for web
- Smooth loading states and empty states
- Good accessibility and large touch targets
- Proper Bangla font rendering

## 7. Technical Stack

Use the following stack unless a better stack is already available:

- Flutter
- Riverpod for state management
- go_router for navigation
- dio for networking
- hive for caching
- flutter_secure_storage for auth tokens
- google_fonts for typography
- fl_chart for charts
- lottie for lightweight animations
- Firebase for backend services

## 8. Backend Requirements

Use Firebase backend services:

- Firebase Authentication for phone OTP
- Firestore for database
- Cloud Functions for AI proxy, subscription webhooks, leaderboard processing, and admin logic
- Firebase Cloud Messaging for notifications if possible

## 9. Database / Collections

Create the following Firestore collections or equivalent tables:

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

Each collection should include fields suitable for the feature and should be normalized for easy querying.

## 10. Backend Files / Modules to Create

Create backend/API logic for:

- auth service
- user profile service
- guidebook service
- question bank service
- quiz/test service
- leaderboard service
- weakness tracker service
- AI proxy functions
- subscription webhook handler
- admin content service
- analytics service
- notification service

## 11. Architecture Expectations

Organize the codebase using a feature-first structure such as:

- lib/core
- lib/features/auth
- lib/features/guidebook
- lib/features/question_bank
- lib/features/mock_test
- lib/features/weakness_tracker
- lib/features/ai_tutor
- lib/features/ai_simulator
- lib/features/smart_prompt
- lib/features/subscription
- lib/features/gamification
- lib/features/admin
- lib/shared

## 12. Important Constraints

- Do not expose AI API keys in the client
- All AI requests must go through backend proxy functions
- Premium features must be properly gated
- Web build must show a clearly labeled demo billing flow instead of real carrier billing
- Bangla content must render correctly and stay readable
- Keep performance good on mobile networks
- Make the UI functional and demo-ready, not just visually incomplete

## 13. Deliverables

Deliver:

1. A working Flutter project structure
2. Core screens and flows for the MVP
3. Firebase backend setup and schema
4. AI proxy endpoints and admin analytics support
5. Subscription and premium gating logic
6. A simple but polished UI for the main app and admin panel
7. Clear instructions for running the app locally

## 14. Implementation Approach

Build in phases:

1. Project scaffolding and theme
2. Auth, onboarding, profile, settings
3. Guidebook and question bank
4. Quiz and mock test flow
5. Weakness tracker
6. AI tutor, simulator, smart prompt
7. Subscription and premium gating
8. Gamification
9. Admin panel
10. Testing and deployment prep

## 15. Final Instruction

Do not just create placeholder screens. Implement real functionality where possible, use clean architecture, and make the app feel like a real product. If you must simplify, prioritize the MVP features listed above and clearly mark what is mock/demo data versus real wired functionality.
