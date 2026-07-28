# BCS Booster AI — UI/UX Design Guide

This document describes how each screen should look and feel for the BCS Booster AI app. The design direction is mobile-first, Bangla-friendly, playful, and game-like, with a strong Duolingo-inspired progression experience.

---

## 1. Core Design Vision

### Brand personality

- Bright, energetic, encouraging, and rewarding
- Friendly and motivating, not overly formal
- A learning app that feels like a game, not a traditional exam portal
- Clean and modern, with strong visual hierarchy

### Visual style

- Primary color: green (#0E7C4A)
- Secondary color: deep blue (#1B3B6F)
- Accent color: amber (#F5A623)
- Background: soft light surfaces with subtle gradients
- Use rounded cards, bold headers, progress indicators, and clear CTAs

### Typography

- Use Bangla-friendly fonts such as Noto Sans Bengali or Hind Siliguri
- Headings should feel bold and readable
- Body text should remain spacious and comfortable for long reading

### Motion philosophy

- Use light, smooth, and rewarding animations
- Micro-interactions should feel playful and encouraging
- Avoid heavy or distracting motion on low-end devices

---

## 2. Global UI System

### Layout rules

- Mobile-first spacing with generous padding
- Bottom navigation for mobile, sidebar for web/admin
- Each screen should have one primary action and one secondary action
- Cards should have soft elevation, rounded corners, and subtle shadows

### Reusable components

- Primary button: rounded pill, green gradient, strong shadow
- Secondary button: outlined or soft blue
- Progress card: circular or linear progress indicator
- Badge/chip: bright, compact, clearly labeled
- Locked content: dimmed card with a lock icon and premium badge

### Animation standards

- Entry animations: 250–400ms fade/slide-up
- Button press: 120–180ms scale-down/up
- Success feedback: 600–900ms bounce or confetti burst
- Loading states: subtle shimmer or pulse
- Transition style: smooth ease-out curves

---

## 3. Screen-by-Screen Design Blueprint

### 3.1 Splash Screen

How it should look:

- Full-screen branded background with a soft green-blue gradient
- Centered logo or app mascot with a bold title
- Subtle animated loading ring or progress bar
- Minimal text, calm and premium feel

Animation ideas:

- Logo fades in with a slight bounce
- Background glow pulses gently
- Loader rotates smoothly while app initializes

---

### 3.2 Onboarding Screens

How it should look:

- Full-screen illustration area with a large hero image or animated graphic
- A short, motivating headline in Bangla and English
- Three to four slides showing: guidebook learning, quiz streaks, AI support, and progression map
- Bold CTA button at the bottom: “Start Learning”

Animation ideas:

- Slide transitions between steps
- Cards animate in with staggered motion
- Progress dots gently scale on active state

---

### 3.3 Login & OTP Screen

How it should look:

- Clean, centered card layout on mobile
- Phone input field with a soft green border and large tap target
- OTP boxes should be large and easy to read
- Helpful copy like “Enter your phone number to continue”

Animation ideas:

- Input field focus causes a smooth border glow
- OTP digits appear with a quick pop animation
- Error state shakes slightly for invalid input

---

### 3.4 Profile Setup Screen

How it should look:

- Friendly step-by-step form with a progress header
- Name field, exam track selection chips, optional district field
- Large, bright selection chips for BCS, Bank, and Primary Teacher tracks
- A smooth visual flow that feels guided and lightweight

Animation ideas:

- Chip selection animates with a soft bounce or scale-up
- Form fields slide upward as the user progresses
- Continue button pulses once the form is ready

---

### 3.5 Playground / World Map Screen (Primary Experience)

How it should look:

- This is the home experience after onboarding
- A large hero section at the top showing:
  - user level
  - XP progress bar
  - daily streak
  - current mission badge
- The main visual is an interactive world-map-style layout
- Each level is shown as a glowing node or island-like point on the map
- Completed levels appear bright and active; locked levels appear dimmed with a lock icon
- Each node should feel like a mini quest zone

Animation ideas:

- Map nodes pop in one by one with a staggered entrance
- Completed nodes glow and pulse gently
- Unlocking a new level triggers a soft celebration burst and a progress bar fill
- Hover/tap on a node shows a smooth card expansion with rewards and challenge details
- On completion, add confetti or sparkle effects and a leveling-up animation

This screen should feel like the heart of the app and should be visually exciting from the first second.

---

### 3.6 Home Dashboard

How it should look:

- A welcoming overview screen with a progress summary card
- Quick actions such as “Continue Learning”, “Daily Quiz”, “AI Tutor”, “Mock Test”
- A streak card and XP card near the top
- Small cards for recent activity and recommendations

Animation ideas:

- Cards slide in from below with staggered timing
- Progress bars animate from left to right
- Buttons react with a subtle press effect

---

### 3.7 Guidebook Home Screen

How it should look:

- A grid of subject cards such as Bangladesh Affairs, International Affairs, Science, Math, and English
- Each card uses a strong color block with a small icon and short description
- Premium-only cards can be highlighted with a badge

Animation ideas:

- Cards appear with a slight upward motion
- Hover/tap causes a light lift and shadow increase
- Premium lock icon pulses once when the card is tapped

---

### 3.8 Chapter List Screen

How it should look:

- A vertical list of chapters, each with title, short summary, progress indicator, and bookmark icon
- Use compact progress bars and readable labels
- Strong hierarchy so the current chapter is easy to find

Animation ideas:

- Chapter rows slide in smoothly
- Progress fills animate when loaded
- Bookmark toggles show a small bounce effect

---

### 3.9 Chapter Reader Screen

How it should look:

- Clean reading experience with large font and strong line spacing
- A subtle top bar with chapter title and bookmark button
- Use highlighted sections, bullet points, and simple callout boxes
- Keep it calm and focused, not crowded

Animation ideas:

- Page transitions feel like a gentle slide
- Reading progress bar animates smoothly
- “Ask AI” button highlights with a soft pulse

---

### 3.10 Question Bank Screens

How it should look:

- A searchable list of questions with filters as chips
- Each question card should be compact but easy to read
- Answer choices should be large and tappable
- Correct/incorrect states should be clearly visible

Animation ideas:

- Card tap causes a subtle scale-up
- Correct answer flashes green and celebrates softly
- Wrong answer shakes slightly and shows an explanation card

---

### 3.11 Daily Quiz / Mock Test Screen

How it should look:

- Full-screen exam experience with timer, progress dots, and question title
- Option cards should be large and touch-friendly
- A clear header shows time left and current question number
- A review flag button should be visually clear but subtle

Animation ideas:

- Timer changes with a gentle pulse near the end
- Option selection animates with a smooth tap response
- Next question transition feels like a card slide
- End-of-test success screen uses a celebratory burst

---

### 3.12 Weakness Dashboard

How it should look:

- A dashboard with charts, progress cards, and recommended actions
- Weak areas shown as bright amber or red warning chips
- Strong areas shown as green success chips
- Minimal but polished layout with generous spacing

Animation ideas:

- Chart bars grow from zero to target values
- Trend lines fade in smoothly
- Recommended mini-test cards appear with staggered motion

---

### 3.13 AI Tutor Sheet

How it should look:

- Bottom sheet with a friendly conversation-style layout
- User question on one side, AI explanation in a glowing card on the other
- Short and concise Bangla explanation, easy to scan
- Follow-up input field at the bottom

Animation ideas:

- Sheet rises smoothly from the bottom
- AI response appears with a soft fade-in
- Typing effect can be used for a more conversational feel

---

### 3.14 AI Exam Simulator Setup Screen

How it should look:

- A premium-only setup screen with a polished card layout
- Options for track, subject, duration, and question count
- Large slider controls and selection chips
- A preview card showing what the generated mock exam will include

Animation ideas:

- Slider movement feels smooth and tactile
- Selection chips animate in with a light bounce
- “Generate Exam” button pulses once the form is complete

---

### 3.15 Smart Prompt Assistant Screen

How it should look:

- Chat-like interface with large prompt chips at the top
- A clean message bubble layout with user and AI responses
- Prompt buttons should be bright and easy to tap
- Keep the layout light and conversational

Animation ideas:

- Prompt chips appear with staggered motion
- AI responses appear as a smooth message bubble transition
- Loading states use a subtle typing shimmer

---

### 3.16 Subscription / Premium Paywall

How it should look:

- A premium-focused hero section with a bold headline
- Three plan cards: daily, weekly, and premium bundle
- Clear benefits and a strong CTA button
- For web, show a clearly labeled demo billing state

Animation ideas:

- Plan cards lift slightly when selected
- Success state uses a checkmark animation and soft glow
- Premium badge appears with a quick burst effect

---

### 3.17 Achievements & Rewards Screen

How it should look:

- A visually rich collection of badges, streaks, XP milestones, and rewards
- Use bright cards and celebratory icons
- Completed achievements should stand out with stronger color and shine

Animation ideas:

- Badges animate in as a grid with staggered timing
- Newly unlocked rewards use a pop and sparkle effect
- Level-up banner feels energetic and celebratory

---

### 3.18 Admin Panel Screens

How it should look:

- Sidebar-based web layout with a clean dashboard first view
- Metric cards for DAU, revenue, subscribers, AI usage, and leaderboard status
- Tables for content management and mock test scheduling
- Clear, structured, and data-focused UI

Animation ideas:

- Metrics cards fade in with slight upward motion
- Charts animate from zero to final values
- Table rows animate in smoothly for better readability

---

## 4. Suggested Motion Library

Use these motion patterns consistently across the app:

- Fade + slide-up for screens entering
- Scale-up for card selection
- Bounce for success and unlock moments
- Shimmer for loading
- Gentle pulse for active states and badges
- Confetti or sparkle burst for level-up and challenge completion

Recommended timings:

- Micro-interaction: 120–180ms
- Screen transition: 250–400ms
- Success celebration: 600–900ms

---

## 5. Design Notes for Maximum Appeal

To make the app feel more engaging:

- Keep the main playground map visually rich and rewarding
- Use frequent but tasteful celebration moments
- Make progress visible everywhere
- Use bright, encouraging states for success and progress
- Avoid too many heavy animations; use them to highlight moments of achievement

The overall experience should feel like a friendly study adventure with progression, rewards, and momentum.
