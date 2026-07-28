# BCS Booster AI — Widget Design Guide

This document provides a widget-by-widget design guide for the BCS Booster AI app based on the structure defined in [Plans/codebase_structure.json](Plans/codebase_structure.json). The goal is to make every widget feel visually cohesive, attractive, and aligned with a playful, game-like learning experience inspired by Duolingo.

---

## 1. Design Direction

### Visual identity

- Bright, energetic, encouraging, and reward-driven
- Mobile-first and touch-friendly
- Strong game-like progression feel with levels, XP, badges, and celebration moments
- Clean and modern, with Bangla-friendly typography

### Core colors

- Primary Green: #0E7C4A
- Secondary Blue: #1B3B6F
- Accent Amber: #F5A623
- Neutral Background: #F7FAFC or soft light surfaces
- Success: #22C55E
- Warning: #F59E0B
- Error: #EF4444

### Shape language

- Rounded corners for cards and buttons
- Soft elevation with subtle shadows
- Pill-shaped CTAs and chips
- Glowing or highlighted states for active/progress elements

### Motion language

- Smooth scale-up on tap
- Gentle bounce on success or unlock
- Fade/slide transitions for entry and navigation
- Soft shimmer for loading and suspense states

---

## 2. Authentication & Onboarding Widgets

### 2.1 login_button

- Style: rounded primary CTA button with green gradient
- Use bold white text and a small icon if helpful
- Add subtle hover/tap glow and scale animation
- Make it feel like a “start mission” button

### 2.2 otp_input

- Style: individual OTP boxes with rounded corners and bright focus state
- Active box should show a stronger border and soft glow
- Keep each box large enough for thumb-friendly interaction
- On error, animate with a light shake

### 2.3 phone_text_field

- Style: rounded input field with leading icon and soft border
- Focused state should show a green-blue outline and subtle inner glow
- Keep spacing generous and text clear for Bangla input

### 2.4 resend_timer

- Style: compact amber chip or button
- Use friendly copy such as “Resend OTP”
- When active, show a calm pulse effect

### 2.5 onboarding_card

- Style: large full-width card with illustration, title, and supporting text
- Use a soft gradient background and bold headline
- Include one strong CTA at the bottom
- The card should feel like a story panel rather than a static slide

### 2.6 page_indicator

- Style: simple dot indicators with active/inactive states
- Active dot should be brighter and slightly larger
- Add a smooth scale transition between pages

### 2.7 skip_button

- Style: lightweight text button or subtle chip
- Use a calm, non-blocking appearance
- Keep it easy to tap and visually understated

---

## 3. Home & Dashboard Widgets

### 3.1 header_card

- Style: hero card with a strong top section and clear summary content
- Use a soft gradient background and a bold heading
- Add small mission-style iconography
- Should feel like a “player status” panel

### 3.2 xp_card

- Style: compact progress card with a circular or linear XP meter
- Use bright green for completed progress and amber for current focus
- Add a gentle sparkle animation when XP increases

### 3.3 streak_card

- Style: energetic card for daily streak count
- Use a flame or streak icon with bold typography
- Make it feel like a reward and motivation panel

### 3.4 daily_goal_card

- Style: progress-focused card with mission summary
- Show progress and next reward in a simple way
- Use a soft, encouraging tone with clear subtext

### 3.5 quick_action_grid

- Style: grid of rounded action tiles with icons and labels
- Each tile should have a distinct accent color
- Active tiles should slightly lift on tap
- The grid should feel like a game menu

### 3.6 continue_learning_card

- Style: card that highlights the next lesson or challenge
- Use a progress preview and a clear primary CTA
- Keep it visually inviting and motivational

### 3.7 recent_activity

- Style: compact activity feed with small status dots and short labels
- Use color-coded status chips for completed, in-progress, and unlocked states
- It should feel lightweight and rewarding rather than technical

### 3.8 premium_banner

- Style: bold banner with premium benefits and CTA
- Use a premium-style glow or gradient and a strong accent color
- Make it feel like an unlock prompt rather than a sales block

---

## 4. Guidebook Widgets

### 4.1 subject_card

- Style: bold subject card with icon, title, and short description
- Use a color-blocked background to make each subject distinct
- Add a slight lift on tap and a soft shadow
- Premium subjects may include a glowing badge

### 4.2 chapter_card

- Style: rounded list card with chapter title, summary, and progress state
- Use a clear completion indicator and optional bookmark icon
- Completed chapters should feel satisfying and polished

### 4.3 chapter_progress

- Style: slim progress bar with a bright green fill
- Use soft animation when loading or updating
- Keep it subtle and easy to understand

### 4.4 premium_lock

- Style: dimmed version of the normal card with a lock icon and premium badge
- Keep the lock area visually soft and not too harsh
- The premium badge should feel like a reward gate

### 4.5 bookmark_button

- Style: circular icon button with a filled state when bookmarked
- On toggle, use a quick pop or bounce animation
- Keep it small but noticeable

---

## 5. Question Bank Widgets

### 5.1 question_card

- Style: compact card showing the question text, topic, and difficulty
- Use strong text hierarchy and subtle elevation
- Add a progressive state: not started, attempted, reviewed, correct

### 5.2 question_option

- Style: large rounded option tile with clear text and icon support
- Selected state should have stronger border and color fill
- Correct answer should feel green and bright; wrong answer should feel warm and clear

### 5.3 explanation_card

- Style: supportive informational card with a subtle accent background
- Use a friendly, concise explanation tone with a small AI or spark icon
- It should feel like a tutor helping the learner, not a textbook note

### 5.4 practice_result_card

- Style: success or review card with score summary and next-step CTA
- Use celebratory styling on success and calm guidance on fail states
- Keep it confident and motivating

### 5.5 filter_bottom_sheet

- Style: rounded modal sheet with filter chips and clear action buttons
- Use a modern and soft appearance with accessible spacing
- Selected filters should be highlighted like game upgrades

### 5.6 search_bar

- Style: pill-shaped search field with icon and clear focus state
- Focused state should brighten and slightly expand
- It should feel fast and lightweight

---

## 6. Quiz & Mock Test Widgets

### 6.1 answer_option

- Style: large, elevated choice card that feels like a mission choice
- Selected state should scale slightly and show bold accenting
- Use green for correct, amber for review, and red for incorrect

### 6.2 question_card

- Style: central challenge card with the question and supporting meta information
- Keep it prominent, bold, and uncluttered
- Add subtle animation when switching questions

### 6.3 question_progress

- Style: progress indicator using dots, bars, or a circular meter
- A current question should feel active and highlighted
- Completed questions should appear filled and calm

### 6.4 quiz_timer

- Style: countdown card with strong typography and urgent but not alarming color
- Near the end, use a stronger pulse or glow to signal urgency

### 6.5 result_summary_card

- Style: celebratory score card with summary stats and next-step CTA
- Use bright success colors and a clear reward tone
- Great place for a subtle confetti or sparkle animation

### 6.6 mock_test_card

- Style: mission card for test availability, duration, and status
- Premium tests can use stronger accent and badge styling
- Use clear action labels like “Start” or “Locked”

### 6.7 question_navigation

- Style: tappable question grid with status colors
- Active question: bright and highlighted
- Flagged question: amber accent
- Completed question: green accent

### 6.8 question_palette

- Style: compact palette showing answer states across the test
- Use intuitive colors and strong contrast for quick scanning

---

## 7. Settings & Profile Widgets

### 7.1 settings_tile

- Style: rounded card with an icon, title, subtitle, and chevron
- Keep the layout calm and polished
- Good use of soft shadows and subtle contrast

### 7.2 settings_switch_tile

- Style: modern toggle card with a clean on/off state
- Use soft motion and bright highlight when enabled
- Keep it intuitive and premium-feeling

### 7.3 profile_avatar

- Style: circular avatar with a soft ring and optional level badge
- Make it feel personal and polished
- Use a subtle glow for the active profile state

### 7.4 profile_header

- Style: hero card showing level, XP, and achievement summary
- This should feel like a player profile dashboard
- Use a mixture of bright accents and structured data blocks

### 7.5 profile_badges

- Style: modular badge grid with earned/locked states
- Earned badges should glow and feel rewarding
- Locked badges should be muted but still visible

### 7.6 profile_statistics_card

- Style: stat blocks with icons and numeric values
- Keep them compact, readable, and slightly game-like
- Good place for progress bars or small radial indicators

### 7.7 profile_menu_tile

- Style: compact row or card with clear label and icon
- Keep consistent spacing and a friendly, modern feel

---

## 8. Subscription & Premium Widgets

### 8.1 plan_card

- Style: premium-style card with highlighted border and reward-style iconography
- Selected plan should lift and glow more strongly
- Use a featured plan treatment for the best-value option

### 8.2 feature_comparison

- Style: simple comparison rows with check icons and clear labels
- Use a clean, modern layout and strong hierarchy
- Keep it visually reassuring and easy to scan

### 8.3 premium_banner

- Style: bold unlock banner with CTA and a bright accent background
- Make it feel like a reward gate or special mission unlock

---

## 9. AI Widgets

### 9.1 ai_chat_bubble

- Style: rounded message bubble with a soft gradient and spark icon
- AI responses should feel friendly and clear
- Use a slightly different color from user messages for contrast

### 9.2 ai_typing_indicator

- Style: lightweight shimmer or bouncing dots
- Keep it subtle and clean
- Great place for a tiny “thinking” animation

### 9.3 exam_settings_card

- Style: polished settings card with grouped controls and a strong CTA
- Use a clean form-like layout with clear spacing and visual sections

---

## 10. Playground & Gamification Widgets

### 10.1 level_card

- Style: quest-like card with title, status, XP reward, and challenge hint
- Completed levels should glow; locked levels should feel dimmed but inviting

### 10.2 map_node

- Style: glowing circular or island-style node on the map
- Active nodes should pulse; completed nodes should shine
- Add a small icon or label for clarity

### 10.3 progress_path

- Style: connected line or path between nodes
- Active segments should be brighter and more visible
- It should feel like a journey across a map

### 10.4 locked_level

- Style: muted card or node with a lock icon and soft shadow
- Avoid making it feel dead or negative; make it feel like a challenge to unlock

### 10.5 challenge_tile

- Style: mission card with objective, reward, and CTA
- Use a clear “quest” treatment and bright progress hint

### 10.6 boss_gate

- Style: dramatic gate or checkpoint card for major milestones
- Use a stronger silhouette and a reward-like visual treatment

### 10.7 level_reward_dialog

- Style: centered reward modal with sparkle, XP, and reward summary
- Add celebration motion and a strong CTA such as “Claim Reward”

---

## 11. Admin Widgets

### 11.1 admin_sidebar

- Style: clean vertical navigation with icons and bold labels
- Use a professional but still modern visual language
- Keep the active item highlighted with a strong accent

### 11.2 analytics_chart

- Style: modern charts with bright graph lines and soft card containers
- Use color-coded series and subtle animation on load

### 11.3 chart_card

- Style: compact metric card with title, value, and mini chart or trend line
- Keep data crisp and visually readable

### 11.4 stat_card

- Style: data card with bold number and supporting label
- Should feel like a dashboard metric rather than a generic card

### 11.5 dashboard_card

- Style: summary card for key system metrics
- Use a calm but professional color palette with bright accents

### 11.6 search_bar

- Style: compact admin search field with stronger contrast and clear focus states

### 11.7 pagination_widget

- Style: simple page controls with rounded buttons
- Keep it minimal and functional

### 11.8 confirmation_dialog

- Style: modal with clear title, summary, and action buttons
- Use calm, trustworthy visuals and strong CTA hierarchy

---

## 12. Core Shared Widgets Design Guide

These widgets are reusable building blocks for the entire app and should follow the same visual system and motion language.

### 12.1 adaptive_layout

- Style: responsive container that rearranges children based on screen size
- Should feel fluid and balanced on mobile, tablet, and desktop
- Use generous spacing and clear breakpoints

### 12.2 animated_card

- Style: elevated card with subtle motion feedback on hover/tap
- Use a gentle scale-up and shadow increase for interactivity
- Great for feature highlights and reward content

### 12.3 app_bottom_sheet

- Style: rounded bottom sheet with soft corners and a clear drag handle
- Use calm background tint and strong content spacing
- Good for AI tutor, filters, and quick actions

### 12.4 app_logo

- Style: simple branded mark with strong visual recognition
- Keep it bold, polished, and easy to display in splash and header areas

### 12.5 app_name

- Style: text-based brand identity that pairs with the logo
- Use bold, readable typography with the app’s green-blue brand feel

### 12.6 app_snackbar and app_toast

- Style: lightweight feedback surfaces for success, info, and error states
- Use soft rounded corners, clear icons, and concise text
- Success toasts should feel encouraging; error toasts should be clear but not alarming

### 12.7 app_version

- Style: small informational footer text
- Keep it subtle and understated, in a muted secondary color

### 12.8 avatar and profile_avatar

- Style: circular avatar with a polished border and optional badge
- Use a friendly, personal appearance with subtle depth
- The active profile state can include a glowing ring

### 12.9 brand_header

- Style: branded header block for screens and sections
- Use a strong title, short subtitle, and optional accent icon
- Should feel like a game mission header

### 12.10 cached_image and network_image_widget

- Style: image containers with consistent loading and fallback states
- Use rounded corners and soft placeholders
- Keep image presentation polished and consistent

### 12.11 category_chip and tag_chip

- Style: compact chips for categories, skill tags, or labels
- Use bright but readable color accents
- Active chips should feel highlighted like unlocked abilities

### 12.12 coming_soon

- Style: friendly placeholder card with a soft illustration or icon and reassuring text
- Make it feel lightweight and positive rather than empty or unfinished

### 12.13 custom_appbar and custom_sliver_appbar

- Style: top navigation with title, actions, and a calm visual hierarchy
- Keep it modern and approachable, with soft elevation and clear spacing

### 12.14 custom_bottom_navigation and custom_navigation_rail

- Style: bottom nav or side nav for app navigation
- Active item should be highlighted with green-blue accent and a soft glow
- Keep touch targets generous and icons intuitive

### 12.15 custom_checkbox, custom_radio, and custom_switch

- Style: interactive controls with clear selected and unselected states
- Use strong visual feedback and smooth motion
- The selected state should feel satisfying and game-like

### 12.16 custom_drawer and custom_scaffold

- Style: structured layout surfaces for navigation and page content
- Use clear sections, spacing, and visual separation
- Support a polished mobile and web experience

### 12.17 custom_dropdown, custom_search_field, custom_textfield, and custom_slider

- Style: form input controls with rounded surfaces and a clear focus state
- Active states should show a stronger border and soft glow
- Keep them simple, readable, and touch-friendly

### 12.18 dashed_divider, dotted_divider, and custom_divider

- Style: subtle separators between sections
- Use faint coloring and consistent spacing
- Avoid being too heavy; they should support structure without distracting

### 12.19 debug_banner

- Style: small development badge in a corner of the UI
- Keep it subtle and non-invasive, in a muted warning color

### 12.20 empty_state, empty_widget, no_data_widget, and no_internet

- Style: friendly empty or error placeholders with icon, title, and support text
- Keep them visually helpful and encouraging, never harsh or blank
- Add a calm CTA where useful

### 12.21 error_banner, error_state, error_widget, and network_error_widget

- Style: clear error communication surfaces with warning color and concise explanation
- Use accessible contrast and a calm, recoverable tone

### 12.22 fullscreen_loader, loading_overlay, loading_widget, and shimmer_loader

- Style: polished loading surfaces with a soft shimmer or pulse effect
- Keep the motion subtle and satisfying
- Use them to maintain a premium feel during network or content loading

### 12.23 glass_card and glass_container

- Style: translucent elevated surfaces with a soft frosted look
- Use for premium panels, overlays, and glowy sections
- Keep the effect subtle so content remains readable

### 12.24 gradient_text

- Style: text with a bold color gradient for emphasis
- Use sparingly for hero titles, highlights, or reward labels
- Make it feel energetic and fresh

### 12.25 image_placeholder and placeholder visuals

- Style: clean fallback for missing images with a soft background and icon
- Keep it polished and consistent with the app’s card style

### 12.26 page_footer, page_header, section_header, and title_with_action

- Style: section framing UI for content grouping
- Use clear title hierarchy and optional action buttons
- Keep each section visually tidy and modular

### 12.27 premium_badge

- Style: compact premium marker with a strong accent and soft glow
- Make it feel like a reward unlock or special access status

### 12.28 primary_button and secondary_button

- Style: strong action buttons with rounded shape and visible contrast
- Primary button should feel like a mission start; secondary should feel supportive and calm
- Use hover/tap elevation and color transitions

### 12.29 rounded_container

- Style: reusable rounded content wrapper for cards, panels, and blocks
- Use consistent corners and background tone
- Great for building a consistent card system

### 12.30 safe_area_wrapper

- Style: layout shell that respects mobile safe areas
- Keep it invisible and reliable, with no visual noise

### 12.31 status_chip

- Style: compact badge for statuses such as active, locked, premium, or new
- Use color-coded states to communicate meaning clearly

### 12.32 streak_card

- Style: motivational stat card for daily streaks and engagement
- Use warm color tones and a bold number or icon
- Make it feel rewarding rather than purely informative

### 12.33 xp_progress_bar

- Style: progress indicator for level advancement and XP growth
- Use a bright fill state, smooth animation, and subtle glow
- It should feel like a game progress meter

---

## 13. Game, Playground, Quiz, and Reader Widgets

### 13.1 playground widgets

- Style: quest-style UI with glowing nodes, level cards, and progress paths
- Use a map-like hierarchy and celebratory unlock states
- Should feel like a world map of learning missions

### 13.2 quiz widgets

- Style: challenge-oriented UI with bold question surfaces and responsive answer choices
- Make each question feel like a level challenge
- Keep feedback states fast, readable, and motivational

### 13.3 reader widgets

- Style: calm reading panels with large text, soft spacing, and a premium reading feel
- Add a subtle AI assist CTA and a clear bookmark action
- Keep the experience focused and immersive

### 13.4 premium widgets

- Style: reward-style cards and unlock surfaces with stronger accent colors
- Make premium content feel special and aspirational

### 13.5 ai widgets

- Style: conversational, friendly, and slightly magical
- Use soft bubble shapes, subtle spark icons, and lightweight loading effects

---

## 14. Design Rules for Consistency

- Keep the same rounded card style across the app
- Reuse the same color system for success, progress, neutral, and premium states
- Use iconography that feels playful and slightly game-like
- Avoid overly flat visuals; use subtle depth and glow
- Every interactive widget should have motion feedback
- Make progress and rewards visible at all times

---

## 15. Final Design Goal

The widgets should make the app feel like a polished, game-inspired study adventure. Every part of the interface should communicate progress, achievement, and motivation while remaining clean, readable, and attractive for both learners and judges.
