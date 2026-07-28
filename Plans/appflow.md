# BCS Booster AI — App Flow Guide

This document describes the end-to-end flow of the application, including which screens exist, who can access them, what each user can do on them, and how the experience progresses from onboarding to mastery.

---

## 1. User Roles

### 1.1 Free User

- Can access the basic learning experience
- Can complete the free daily quiz
- Can explore limited guidebook content and basic practice questions
- Can view the Playground map and unlock beginner levels
- Can access limited AI help depending on the MVP scope

### 1.2 Premium Subscriber

- Can unlock full guidebook content
- Can access premium mock tests and live test flow
- Can use AI Tutor, AI Exam Simulator, and Smart Prompt features
- Can access advanced weakness recommendations and deeper progress insights
- Can enjoy richer gamification rewards and premium-only challenges

### 1.3 Admin / Content Manager

- Can log in to the admin panel
- Can manage content, users, subscriptions, analytics, and leaderboard data
- Can create or update guidebook chapters, questions, and mock tests
- Can monitor AI usage and app performance

---

## 2. Main User Flow

### 2.1 First-time flow

1. User opens the app
2. Sees the Splash Screen
3. Goes through the Onboarding flow
4. Logs in with phone number and OTP
5. Completes profile setup
6. Enters the Playground experience as the main post-onboarding home area

### 2.2 Returning user flow

1. User opens the app
2. Splash screen checks their session
3. If logged in, they go directly to the Playground / Home experience
4. They continue from their current level, streak, and progress
5. They can jump into guidebook, quiz, mock tests, or AI features from there

---

## 3. Screen-by-Screen Flow

## 3.1 Splash Screen

- Who sees it: All users
- Purpose: Show branding and initialize the app
- What the user can do: Wait for loading to complete and be redirected

## 3.2 Onboarding Screens

- Who sees it: First-time users and users who have not completed onboarding
- Purpose: Introduce the app’s core value: learning, progress, and rewards
- What the user can do:
  - Swipe through onboarding slides
  - Tap “Get Started” or “Continue”
  - Understand the Playground-based learning concept

## 3.3 Login Screen

- Who sees it: Public users who are not logged in
- Purpose: Start authentication
- What the user can do:
  - Enter phone number
  - Tap “Send OTP”
  - Move to OTP verification

## 3.4 OTP Verification Screen

- Who sees it: Users who entered a phone number
- Purpose: Verify identity with one-time password
- What the user can do:
  - Enter the 6-digit code
  - Resend OTP if needed
  - Continue to profile setup or app home

## 3.5 Profile Setup Screen

- Who sees it: Newly logged-in users
- Purpose: Personalize the app based on exam track and profile
- What the user can do:
  - Enter name
  - Choose exam track: BCS, Bank, or Primary Teacher
  - Optionally enter district
  - Complete onboarding and continue into the app

## 3.6 Playground / World Map Screen

- Who sees it: All logged-in users, especially the primary home experience
- Purpose: Serve as the main map-based progression screen
- What the user can do:
  - View current level and XP progress
  - See unlocked and locked levels
  - Tap a level node to open a challenge or mission
  - Start reading, quiz, mini-challenge, or AI-based tasks
  - Unlock the next level after completing tasks
  - Track streaks, rewards, and progression

## 3.7 Home Dashboard

- Who sees it: Logged-in users
- Purpose: Provide a quick overview of daily progress and suggested next actions
- What the user can do:
  - View today’s quiz CTA
  - Continue learning from a recommended task
  - See streak and XP progress
  - Jump into guidebook, quiz, mock test, or AI modules

## 3.8 Guidebook Home Screen

- Who sees it: All logged-in users, with limited access for free users
- Purpose: Browse subjects and learning categories
- What the user can do:
  - Choose a subject
  - View subject cards and descriptions
  - Open chapters if unlocked
  - Tap into premium content if subscribed

## 3.9 Chapter List Screen

- Who sees it: All logged-in users
- Purpose: Show the list of chapters inside a subject
- What the user can do:
  - Browse chapter titles and summaries
  - See progress on each chapter
  - Open a chapter to read
  - Bookmark chapters

## 3.10 Chapter Reader Screen

- Who sees it: All users depending on content access
- Purpose: Let the user read guidebook content
- What the user can do:
  - Read Bangla-friendly study material
  - Bookmark the chapter
  - Ask AI for help or explanation
  - Continue to the next learning task from the chapter

## 3.11 Bookmarks Screen

- Who sees it: Logged-in users
- Purpose: Store saved study content for later access
- What the user can do:
  - View bookmarked chapters
  - Open saved content quickly
  - Remove bookmarks as needed

## 3.12 Search Screen

- Who sees it: Logged-in users
- Purpose: Search across guidebook content and questions
- What the user can do:
  - Search by topic, chapter, subject, or question keyword
  - Open the result directly

## 3.13 Question Bank Home Screen

- Who sees it: Logged-in users
- Purpose: Discover and filter available questions
- What the user can do:
  - Apply filters by exam track, subject, year, or difficulty
  - Browse questions
  - Open a question to practice

## 3.14 Question Detail / Practice Screen

- Who sees it: Logged-in users
- Purpose: Practice MCQs and review explanations
- What the user can do:
  - View the question and options
  - Choose an answer
  - See immediate feedback
  - Read the explanation
  - Ask AI Tutor for help

## 3.15 Daily Quiz Screen

- Who sees it: Free users and premium users
- Purpose: Offer a short daily challenge
- What the user can do:
  - Answer 20 questions
  - Submit quiz answers
  - See score and results
  - Earn XP or streak progress

## 3.16 Mock Test Hub

- Who sees it: Logged-in users
- Purpose: Show available mock tests and test status
- What the user can do:
  - View upcoming, active, and completed tests
  - Open a test if available
  - See premium-only test status

## 3.17 Mock Test Instructions / Exam Screen

- Who sees it: Premium users for premium tests
- Purpose: Start a timed mock test experience
- What the user can do:
  - Read instructions
  - Start the exam
  - Answer questions under time pressure
  - Flag questions for review
  - Submit the exam

## 3.18 Mock Test Result Screen

- Who sees it: Users who completed a mock test
- Purpose: Show performance results and summary
- What the user can do:
  - See score, percentile, and summary
  - Review answers
  - Continue to leaderboard or weakness analysis

## 3.19 Leaderboard Screen

- Who sees it: All users, with ranking data visible
- Purpose: Show rankings and progression comparison
- What the user can do:
  - View global or weekly rankings
  - See their own rank
  - Filter by track or category

## 3.20 Weakness Dashboard Screen

- Who sees it: Premium users and some free/limited access depending on MVP design
- Purpose: Show weak topics and improvement opportunities
- What the user can do:
  - View performance by topic
  - See recommendations for mini-tests or reading
  - Tap into a targeted practice path

## 3.21 AI Tutor Screen / Sheet

- Who sees it: Premium users, optionally free preview in MVP
- Purpose: Offer explanation and guidance after mistakes
- What the user can do:
  - Ask for an explanation in Bangla
  - Continue the conversation with one follow-up question
  - Get concise help tied to the current question or topic

## 3.22 AI Exam Simulator Setup Screen

- Who sees it: Premium users
- Purpose: Generate a custom mock exam
- What the user can do:
  - Choose track, subject, question count, and duration
  - Generate a new exam
  - Start the generated test

## 3.23 Smart Prompt Assistant Screen

- Who sees it: Premium users, optional free preview
- Purpose: Help users ask AI for study support in Bangla
- What the user can do:
  - Tap preset prompts
  - Get AI-generated help
  - Continue with follow-up study questions

## 3.24 Subscription / Paywall Screen

- Who sees it: Free users and users considering premium access
- Purpose: Show premium benefits and plans
- What the user can do:
  - View plans and pricing
  - Select a daily or weekly plan
  - Continue to billing flow
  - See demo billing on web

## 3.25 Billing / Manage Subscription Screen

- Who sees it: Users selecting or managing a subscription
- Purpose: Handle billing and subscription state
- What the user can do:
  - Confirm plan selection
  - Complete demo billing on web
  - Manage subscription status
  - Cancel if subscribed

## 3.26 Achievements / Rewards / Badges Screen

- Who sees it: All logged-in users
- Purpose: Celebrate milestones and progression
- What the user can do:
  - View earned badges and rewards
  - See current level and progress
  - Unlock new rewards based on actions

## 3.27 Profile Screen

- Who sees it: Logged-in users
- Purpose: Show personal information and account state
- What the user can do:
  - View profile details
  - Edit profile
  - Browse stats and achievements
  - Manage settings or subscription state

## 3.28 Settings Screen

- Who sees it: Logged-in users
- Purpose: Control app preferences
- What the user can do:
  - Change language
  - Change theme
  - Manage notification preferences
  - View privacy or support information

## 3.29 Admin Login Screen

- Who sees it: Admin users
- Purpose: Secure admin access
- What the user can do:
  - Log in as an administrator
  - Access the admin dashboard

## 3.30 Admin Dashboard Screen

- Who sees it: Admin users
- Purpose: Monitor business and app metrics
- What the user can do:
  - View DAU, subscribers, revenue, and usage stats
  - Navigate to management pages

## 3.31 Admin Content Management Screens

- Who sees it: Admin users
- Purpose: Manage app content
- What the user can do:
  - Create and update subjects, chapters, questions, and mock tests
  - Review and publish changes

## 3.32 Admin Leaderboard / Analytics Screens

- Who sees it: Admin users
- Purpose: Monitor rankings and AI usage
- What the user can do:
  - Review leaderboard status
  - View AI token usage and analytics data
  - Manage important app events

---

## 4. Screen Access Summary

| Screen             | Free User | Premium User | Admin |
| ------------------ | --------- | ------------ | ----- |
| Splash             | Yes       | Yes          | Yes   |
| Onboarding         | Yes       | Yes          | No    |
| Login / OTP        | Yes       | Yes          | Yes   |
| Profile Setup      | Yes       | Yes          | No    |
| Playground         | Yes       | Yes          | No    |
| Home Dashboard     | Yes       | Yes          | No    |
| Guidebook          | Limited   | Full         | No    |
| Questions          | Limited   | Full         | No    |
| Daily Quiz         | Yes       | Yes          | No    |
| Mock Tests         | Limited   | Full         | No    |
| Leaderboard        | Yes       | Yes          | No    |
| Weakness Dashboard | Limited   | Full         | No    |
| AI Tutor           | Limited   | Full         | No    |
| AI Simulator       | No        | Yes          | No    |
| Smart Prompt       | Limited   | Full         | No    |
| Subscription       | Yes       | Yes          | No    |
| Profile / Settings | Yes       | Yes          | No    |
| Admin Panel        | No        | No           | Yes   |

---

## 5. Core Experience Journey

### 5.1 Learning journey

- Start from the Playground map
- Open a level challenge
- Complete reading, quiz, or practice tasks
- Earn XP and unlock the next level
- Continue toward higher mastery

### 5.2 Motivation loop

- Daily quiz keeps streaks alive
- XP and rewards encourage continued engagement
- Premium features unlock deeper learning opportunities
- Achievements celebrate milestones and progress

### 5.3 Admin loop

- Admins create content and manage the product experience
- Analytics data feeds back into content planning and feature tuning

---

## 6. Design and Interaction Notes

- The app should feel like a game-like journey rather than a plain study app
- The Playground map should be the main visual and emotional center of the experience
- Each screen should provide clear next actions and visible progress
- Premium features should feel rewarding and clearly gated
- Admin flows should remain professional and efficient
