# Playground — Design Aesthetic

> **The definitive visual design philosophy for the Playground.**
> Every widget, animation, painter, screen, and component must align with this document.
> Treat it as a long-term design specification, not a one-time style guide.
> This document defines the artistic language that every other Playground document must follow.

---

## Table of Contents

1. Introduction
2. Core Design Philosophy
3. Design Vision
4. Player Emotional Journey
5. Visual Identity
6. World Theme
7. Environmental Storytelling
8. World Scale
9. Map Composition
10. Regional Composition
11. Terrain Philosophy
12. Map Flow Grammar
13. Learning Path Philosophy
14. Node Design Philosophy
15. Node Spacing System
16. Milestone Philosophy
17. Building Philosophy
18. Decoration Philosophy
19. Environmental Clustering
20. Reward Philosophy
21. HUD Philosophy
22. Progression Psychology
23. Visual Hierarchy
24. Visual Rhythm
25. World Navigation Language
26. Depth & Layering
27. Atmospheric Depth
28. Camera Philosophy
29. Camera Storytelling
30. Color Language
31. Shape Language
32. Spacing Principles
33. Lighting Principles
34. Shadow Philosophy
35. Painter Artistic Rules
36. Animation Philosophy
37. Motion Principles
38. Motion Hierarchy
39. Animation Frequency
40. Reward Cinematography
41. Microinteraction Philosophy
42. Iconography Philosophy
43. Typography Philosophy
44. Biome Consistency Rules
45. Accessibility Considerations
46. Dark Theme Philosophy
47. Responsive Design Philosophy
48. Performance-aware Visual Design
49. Future Expansion Rules
50. Design Rules
51. Design Review Checklist
52. Things That Must Never Be Done
53. Closing Note

---

## 1. Introduction

The Playground is the emotional center of PrepQuest. It is the world the player inhabits between lessons, the place where progress becomes visible and learning becomes an environment. This document defines the aesthetic that every Playground surface must preserve: a handcrafted, living world that rewards curiosity and celebrates growth.

The Playground is not a list, a menu, or a dashboard. It is a **traveling world**. Every visual decision should answer one question: *does this feel like a place the player wants to be?*

This document is timeless. It is intended to remain valuable as the product evolves over years. It does not prescribe implementation, frameworks, or tooling. It prescribes **intent, taste, and discipline**.

---

## 2. Core Design Philosophy

The Playground is guided by seven non-negotiable principles. Whenever a decision is ambiguous, these principles settle it.

1. **Organic over geometric.** Curves replace grids. Variation replaces symmetry. Nature replaces machinery.
2. **Playful over corporate.** The world smiles. Learning feels inviting, not bureaucratic.
3. **Warm over cold.** Light is golden, shadows are soft, color is welcoming.
4. **Clean over cluttered.** Every element earns its place. Silence in composition is as deliberate as presence.
5. **Premium over flashy.** Restraint reads as quality. Effects serve the story.
6. **Whimsical without becoming childish.** Wonder is allowed; cartoonishness is not.
7. **Friendly while highly readable.** Charm supports comprehension; charm never obscures it.

If a feature cannot be expressed in this language, it does not belong in the Playground.

---

## 3. Design Vision

The player should feel that they are **traveling through an educational adventure**, not navigating an interface. The world behaves like a hand-painted atlas: every region has personality, every path invites curiosity, every milestone feels earned.

The Playground should evoke the same emotional response as flipping through the pages of a beautifully illustrated children's encyclopedia — or stepping into the painted landscapes of Studio Ghibli. Wonder is the destination. Learning is the journey.

---

## 4. Player Emotional Journey

The Playground must orchestrate a deliberate emotional arc during a single session:

| Moment | Feeling |
|---|---|
| **Arrival** | Calm recognition. The world greets the player; the active objective is obvious. |
| **Glance** | Curiosity. The eye wanders to nearby points of interest before settling on the task. |
| **Engagement** | Focus. The active node draws the eye; surrounding ambience deepens immersion. |
| **Completion** | Satisfaction. A reward appears that feels meaningful rather than mechanical. |
| **Anticipation** | Motivation. The next destination is visible, framed, and desirable. |
| **Departure** | Comfort. The player leaves wanting to return. |

Every visual, motion, and composition decision should support at least one of these emotional beats.

---

## 5. Visual Identity

The Playground reads as a **hand-illustrated fantasy countryside** rendered with modern color discipline.

- **Genre cue.** Soft fantasy with countryside warmth — never modern, never dystopian, never minimal-corporate.
- **Lineage.** Painted illustration traditions: watercolour skies, ink contours, painterly textures.
- **Tone.** Optimistic, contemplative, gently magical.
- **Density.** Medium. Enough detail to feel inhabited; enough breathing room to feel calm.
- **Personality.** A small, kind world that takes the player seriously.

---

## 6. World Theme

The default biome is a **rolling meadow at golden hour**. It carries the canonical Playground look:

- Open sky with drifting clouds.
- Distant mountains framing the horizon.
- A meandering river that crosses the world like a quiet spine.
- Clusters of trees that suggest forests without overwhelming them.
- A sense of gentle elevation change, even on a flat plane.

Additional biomes (forest, desert, snow, volcanic) are extensions of this identity, not replacements for it. They must share the same lighting language, the same shape vocabulary, and the same emotional warmth.

---

## 7. Environmental Storytelling

The world tells small stories the player never has to read:

- A bridge exists because a river needed crossing.
- A flag stands where a milestone was reached.
- Trees gather where the path bends, framing it like an audience.
- Clouds linger near the top of the world where the sky lives.
- Mountains guard the edges, marking the boundary between known and unknown.
- A flowering bush near an academy implies that knowledge nurtures growth.

No decoration is random. Every element implies narrative context. Even when the player does not consciously notice, the world reads as inhabited.

---

## 8. World Scale

The world must feel **spacious without feeling empty**.

- **Vertical expansion dominates.** Width is fixed; height grows. The player scrolls *down into* the world, not across a sprawl.
- **Each step is a region.** A node is not a dot — it is the center of a small place, with its own surrounding decorations.
- **The horizon recedes.** Mountains and clouds exist to make the world feel larger than the screen.
- **Density is rhythmic.** Crowded near nodes, sparse between them. Quiet pauses between active regions are essential.
- **Scale is internally consistent.** A tree should look like a tree relative to a building; a flag should look like a flag relative to a mountain. Nothing breaks proportion to look "bigger".

---

## 9. Map Composition

The map is composed like an illustration, not laid out like a grid.

- **Anchored focal points.** Nodes are anchors; everything around them frames them.
- **Layered depth.** Background → terrain → path → midground → foreground → HUD.
- **Asymmetric balance.** Visual weight is distributed unevenly for organic feel; symmetry only appears intentionally as a moment of ceremony (boss gates, milestones).
- **Path as spine.** The progression path is the visual rhythm that ties regions together.
- **Foreground silence.** Decoration density must never compete with the active node for attention.

---

## 10. Regional Composition

Every node is the center of a **miniature region** with four concentric zones:

1. **Interaction zone** — the node itself and the immediate path leading to it. Always unobstructed.
2. **Decorative zone** — surrounding trees, bushes, and minor landmarks. Supports the interaction zone.
3. **Atmospheric zone** — clouds, distant mountains, and haze. Frames the region with depth.
4. **Transition zone** — quiet space that blends this region into the next. Holds the world's breath.

Each zone must blend into the next without seams. A region never feels cut off; it dissolves into its neighbor.

---

## 11. Terrain Philosophy

Terrain should feel **sculpted by hand, not generated**.

- Contours are gentle, never stepped.
- Edges feather softly into the path.
- Ground tones shift in warm bands, never flat fills.
- No straight boundaries. Terrain reads as natural even when simplified.
- Subtle elevation variation prevents the world from feeling like a flat plane painted with grass.

---

## 12. Map Flow Grammar

The progression path is the **grammar of the world** — the syntax the player learns to read by traveling.

- **Naturally winding hiking trail.** The path must resemble a route through countryside, not a road on a blueprint.
- **No mathematical S-curves.** The eye instantly detects algorithmic alternation. Each bend must vary in radius, direction, amplitude, and spacing.
- **Handcrafted variety.** Every segment carries its own character: a tight bend around a tree, a long arc through a meadow, a gentle dip toward a river.
- **Boss regions expand.** Approach to a boss widens visually — the world opens up, the path breathes, the player feels the ceremony of arrival.
- **Curves lead the eye.** Path geometry is also a navigational tool: a bend toward the horizon tells the player where the next destination lies.

---

## 13. Learning Path Philosophy

The path is the protagonist of the world.

- **Curves, never diagonals.** The path bends, arcs, and sways like a hiking trail.
- **Handcrafted variety.** Each segment has its own curvature, its own direction change, its own breath.
- **The active segment glows softly.** It draws attention without shouting.
- **Completed segments recede gracefully.** They remain visible as a memory, but cede focus.
- **Locked segments hint without teasing.** They promise future journey, never punish the player.
- **Wide loops near bosses.** Boss approaches deserve ceremony: the path widens, the world opens up.

---

## 14. Node Design Philosophy

Nodes are **destinations, not pins**.

- Each node carries the weight of its lesson. Visual treatment must reflect its importance: regular, reward, milestone, or boss.
- Nodes always sit on the path — never floating beside it.
- Spacing varies intentionally: tighter between peers, more breathing room before milestones, expansive approach to bosses.
- The active node is unmistakable: it must draw the eye instantly and reward the gaze with rich detail.
- Completed nodes wear a quiet badge of completion. They are proud, not boastful.

---

## 15. Node Spacing System

Distance between nodes is a **language of importance**.

- **Regular lessons** sit at comfortable, even pacing — close enough to feel continuous, far enough to breathe.
- **Rewards** introduce slightly larger breathing space, marking "you have arrived somewhere".
- **Milestones** open the world dramatically. Spacing widens; decoration enriches; the player feels the gravity of arrival.
- **Boss nodes** receive ceremonial separation. The path approaches slowly, the surrounding world quiets, and the destination stands alone.
- Spacing communicates progression importance **before** the player reads any label.

---

## 16. Milestone Philosophy

Milestones are **ceremonial pauses**.

- They mark transitions in the journey, not just checkpoints.
- They feel like arriving at a place, not clicking a button.
- A milestone node anchors a building or landmark that gives the region identity.
- Visual weight increases dramatically: more decoration, more space, more atmosphere.
- Milestones should feel **memorable** — the kind of place the player remembers returning to.

---

## 17. Building Philosophy

Buildings are **landmarks, not icons**.

- Each building type carries its own architectural personality (academy, library, future expansions) but shares the same material vocabulary.
- Buildings anchor the eye and ground the world; they should never feel pasted on.
- They scale with importance: academy buildings rise taller than utility structures.
- Color, lighting, and shadow tie them into the surrounding terrain.
- Buildings influence their surroundings: an academy invites trees and quiet; a library invites bridges and rivers.

---

## 18. Decoration Philosophy

Decoration is **atmosphere, not filler**.

- Trees grow in small groves, never alone.
- Bushes cluster around tree bases, as in nature.
- Clouds live high; mountains live at the edges.
- Flags appear at milestones, not arbitrarily.
- A river runs continuously between two anchors; a bridge appears exactly where it must.
- Decoration density breathes: dense near nodes, sparse between them.
- Decoration must never block the active node or the path.

---

## 19. Environmental Clustering

Decoration is **grammar, not noise**. The world obeys a clustering language:

- **Trees naturally cluster.** A grove of three to five reads as a place; a single tree reads as lost.
- **Bushes grow around tree bases**, suggesting undergrowth and time.
- **Buildings influence surrounding decorations.** An academy pulls in trees and quiet; a library pulls in rivers and bridges.
- **Flags belong near landmarks** — never in empty meadow.
- **Bridges appear only where rivers cross paths.** A bridge without a river is meaningless; a river without a bridge is half-finished.
- **Cloud density increases with elevation.** Higher regions feel higher; lower regions stay clear and inviting.

Clustering is what separates an inhabited world from a scattered illustration.

---

## 20. Reward Philosophy

Rewards must feel **earned and meaningful**.

- The reward reveal is a moment of celebration, not a notification.
- Rewards are presented as objects: chests, orbs, tokens — things the player possesses.
- Animation supports the reveal: rising, glowing, settling. Never explosive or jarring.
- The reward should leave a memory. The player should be able to recall what they received.
- Larger milestones deserve larger rewards, both visually and emotionally.

---

## 21. HUD Philosophy

The HUD is **a quiet companion, not the foreground**.

- HUD elements live at the edges, never the center.
- The player should be able to read their status in a glance, then return their attention to the world.
- HUD chrome uses the same warm tones as the world, with reduced contrast, so it feels embedded rather than overlaid.
- No HUD element should compete with an active node for visual attention.
- Touch targets are generous; feedback is immediate; animations are minimal but never absent.

---

## 22. Progression Psychology

The Playground must turn progression into motivation without pressure.

- **Visible forward motion.** The next destination is always within sight or implied.
- **Earned satisfaction.** Completed paths stay visible; the player sees how far they have come.
- **Locked regions as anticipation.** Locked areas are framed, never hidden. They promise future adventure.
- **No artificial scarcity.** Rewards and unlocks feel generous within the player's effort.
- **Calm urgency.** Time-sensitive elements (daily missions, energy) exist but never dominate the world visually.

---

## 23. Visual Hierarchy

Visual attention must always know where to go.

1. The **active node** holds primary focus.
2. The **immediate path** supports it.
3. **Adjacent regions** provide context.
4. **Decoration and atmosphere** fill the rest.
5. **HUD** stays at the perimeter, supporting without intruding.

Every design choice should be evaluable against this hierarchy: does this element raise or lower attention where it should?

---

## 24. Visual Rhythm

The world is composed with **musical rhythm**.

- **Alternating quiet and dense regions.** Open sky follows a grove; a wide clearing precedes a milestone.
- **Pacing between ordinary nodes, milestones, boss regions, and reward zones.** The journey feels like chapters, not a continuous line.
- **Visual beats.** Active nodes mark downbeats; transitions between them are upbeats; ambient motion fills the rests.
- **Rhythm supports long scrolling without fatigue.** Repetition without variation tires the eye; variation without rhythm disorients it.

The world should feel like a composition that breathes.

---

## 25. World Navigation Language

The player's eyes travel through the world on **invisible rails** laid by the design.

- **Primary visual anchors** are active nodes, current milestones, and immediate rewards. The eye always returns here.
- **Secondary visual anchors** are nearby landmarks — buildings, distinctive trees, memorable terrain — that give the player bearings.
- **Tertiary visual anchors** are background elements — distant mountains, sky gradients, cloud formations — that frame the journey.
- **Curves naturally lead attention.** A path bending toward a mountain invites the eye to follow.
- **Landmarks guide subtly.** A flag, a bridge, or a glowing window tells the player where something interesting lives without signposting it.

The world teaches navigation by showing, never by labeling.

---

## 26. Depth & Layering

The world must feel **three-dimensional even when rendered in two**.

- **Background** is soft and atmospheric.
- **Terrain** carries mid-tone warmth.
- **Midground** holds the path and its anchors.
- **Foreground** carries the closest decoration and the player's interactive elements.
- **Parallax** — wherever used — is subtle and supportive, never theatrical.
- **Shadows** are soft, directional, and tied to a consistent light source.

---

## 27. Atmospheric Depth

Distance must read as **distance**, not as emptiness.

- **Subtle haze with increasing distance.** Far objects desaturate slightly; near objects stay vivid.
- **Background mountains soften progressively.** Their contours feather into the sky.
- **Cloud opacity varies by elevation.** Higher clouds feel more present; lower clouds feel more like weather.
- **Depth cues remain gentle.** No element should feel hidden behind fog; depth whispers, it does not shout.

Atmospheric depth is the difference between a flat illustration and a world.

---

## 28. Camera Philosophy

The camera frames the world like a cinematographer, not a viewport.

- The camera **centers the active node**, not the world itself.
- Transitions are smooth, never abrupt.
- The player always understands where they are relative to their goal.
- The world extends visibly in both directions of the path, so progress feels directional.
- Zoom is reserved for moments of focus; default framing is wide and welcoming.

---

## 29. Camera Storytelling

The camera **directs** the player's experience.

- **Opening animation frames the active node.** The world does not boot into a wall of UI; it opens on a destination.
- **Camera movement preserves spatial awareness.** Even while moving, the player always knows where they are.
- **Transitions reveal nearby destinations without disorienting the player.** A pan that hints at the next milestone is more powerful than a pan that exposes the whole journey.
- **Camera follows emotional arc.** Calm motion during exploration; deliberate motion during milestones; ceremonial motion during boss reveals.
- **The camera is the player's companion.** It never makes the player feel watched, never breaks the spell of inhabiting the world.

---

## 30. Color Language

Color is **emotional, not decorative**.

- The palette is anchored by warm earth tones, soft greens, sky blues, and accent gold.
- Each color carries semantic weight: green for completion, amber for in-progress, gray for locked, gold for premium.
- Saturation is controlled. Colors support the mood; they do not shout.
- Dark mode is a parallel world, not an inversion: same emotional tone, same warmth, different lighting.
- Color contrast always respects readability. Decorative saturation never compromises legibility.

---

## 31. Shape Language

Shapes carry meaning.

- **Curves** for organic elements (path, terrain, trees, clouds).
- **Rounded rectangles** for surfaces and cards.
- **Sharp angles** reserved for emphasis (boss gates, achievement markers).
- **Repeated motifs** create unity: a shared corner radius, a shared stroke language, a shared silhouette grammar.

A shape that does not belong to this vocabulary will feel foreign.

---

## 32. Spacing Principles

Space is a design element, not absence.

- **Breathing room around focal points.** Active nodes must never feel crowded.
- **Rhythmic variation.** Distances between nodes vary intentionally; uniform spacing reads as mechanical.
- **Negative space earns attention.** Empty sky or quiet ground makes the next destination feel more meaningful.
- **Alignment is invisible.** When elements do align, the alignment should feel natural, not grid-driven.

---

## 33. Lighting Principles

Light carries narrative.

- A consistent **directional light source** (warm, high, slightly off-axis) defines the world's mood.
- **Highlights** are gentle, never blown out.
- **Shadows** are soft, slightly cool, and imply elevation without harshness.
- **Glows** are reserved for active states, rewards, and milestones. They draw attention through warmth, not brightness.
- **Ambient particles** add atmosphere without distracting from primary content.

---

## 34. Shadow Philosophy

Shadows suggest depth, not weight.

- Shadows are **soft and short**.
- They imply elevation, never oppress.
- They are colored, not pure black — keeping the world warm.
- A shadow should always be evaluable: *what does this shadow tell me about the object's place in the world?*

---

## 35. Painter Artistic Rules

Painters are **the illustrators of the Playground**, not just rendering utilities.

- **Handcrafted illustrations, not geometric graphics.** Every shape must suggest natural imperfection.
- **Flowing curves.** Favor organic arcs and sweeps; avoid rigid polygons.
- **No rigid symmetry.** Slight variation reads as life; perfect symmetry reads as machine.
- **No mechanical repetition.** Each instance of a shape must feel slightly different from the next.
- **Texture over flat fill.** Surfaces should imply material — bark, leaf, stone, water — even when simplified.
- **Painter discipline.** Geometry suggests natural imperfection; imperfection suggests lived-in space; lived-in space suggests home.

A painter that violates these rules produces a Playground that feels illustrated by a computer.

---

## 36. Animation Philosophy

Motion is **language**.

- Every animation conveys meaning: arrival, attention, completion, transition.
- Animations are **short enough** to feel responsive and **long enough** to feel intentional.
- Idle motion (clouds, trees, particles, glows) keeps the world alive without becoming noisy.
- Celebrations are earned and rare; they should feel like moments, not routines.
- Reduced motion is a first-class state, not an afterthought. The world remains beautiful without movement.

---

## 37. Motion Principles

- **Ease, never linear.** All motion uses curves that feel natural.
- **Anticipation before action.** Elements that move into place first hint at their arrival.
- **Follow-through on rest.** Elements settle slightly past their target and ease back.
- **Stagger by importance.** When multiple elements animate together, the most important moves first.
- **No animation should require the player's full attention.** Motion supports the world; it does not become the world.

---

## 38. Motion Hierarchy

Motion has a **clear priority stack**:

1. **Primary motion** belongs to the active node. Pulse, glow, ring, or beacon — the eye finds it immediately.
2. **Secondary motion** belongs to the path. Active segments flow; completed segments stay still; locked segments remain quiet.
3. **Ambient motion** belongs to decorations. Clouds drift, trees sway, particles rise, water flows.
4. **HUD motion** remains minimal. Updates fade in; transitions are short; chrome never dances.

No decorative animation may compete with gameplay motion.

---

## 39. Animation Frequency

Rhythm matters even in idle motion.

- **Idle animations remain slow.** Movement that demands attention is not idle.
- **Looping animations avoid synchronized repetition.** Two trees swaying in lockstep look mechanical; staggered phases look alive.
- **Randomized offsets create a living world.** Each instance of an animated element should feel slightly out of step with its neighbors.
- **Particles feel atmospheric, not decorative.** Particle density rises and falls with the scene; particles never feel like glitter.

A world whose idle motion is unreadable is a world trying too hard.

---

## 40. Reward Cinematography

A reward is **a small ceremony**. The world cooperates to deliver it.

- **Reveal resembles opening treasure.** Light gathers; the object rises; the world acknowledges the moment.
- **Camera, particles, glow, and UI cooperate.** Each plays a role; none overshadows the others.
- **Rewards settle calmly after celebration.** The reveal is the climax; the rest is rest.
- **Large celebrations reserved for meaningful achievements.** Routine unlocks feel quiet; major unlocks feel grand.
- **Memory over flash.** The player should remember the moment long after the animation ends.

---

## 41. Microinteraction Philosophy

Every interaction is a **conversation**, never a command.

- **Every tap acknowledges the player.** Pressed states are visible, immediate, and tactile.
- **Hover and press states remain subtle.** Affordances appear, never shout.
- **Selection feedback feels tactile.** Surfaces depress, glow, or shift slightly — not flash.
- **Interactions reinforce delight without distraction.** A satisfying microanimation on a completed lesson should feel like a smile, not a fireworks show.
- **Disabled states remain humane.** Locked interactions hint at future availability, never at punishment.

---

## 42. Iconography Philosophy

Icons must feel **of the world**, not stamped on it.

- **Icons feel rounded.** Sharp system icons feel imported; rounded glyphs feel native.
- **Avoid overly sharp system icons.** When borrowing platform conventions, soften them to match the Playground's shape language.
- **Icons support readability, not decoration.** An icon earns its presence by clarifying.
- **Illustrative consistency is maintained.** Every icon shares silhouette weight, stroke language, and corner grammar.
- **Iconography reinforces identity.** The icons a player taps most often become part of how they remember the world.

---

## 43. Typography Philosophy

Typography is the **voice** of the Playground.

- **Warm, approachable, and highly readable.** Type should feel like the player is reading a friendly guide, not a terms-of-service document.
- **Hierarchy remains consistent.** Titles, subtitles, labels, and metadata follow the same scale and weight language across every screen.
- **Labels never overpower landmarks.** When type sits inside the world, it supports the world; it does not dominate it.
- **Decorative fonts are prohibited.** Whimsy lives in color, illustration, and motion — not in letterforms.
- **Text scaling respects the world.** Larger text reflows gracefully; nothing breaks composition.
- **Type pairs with tone.** A milestone's title carries weight; a decoration's label whispers; a HUD value is precise.

---

## 44. Biome Consistency Rules

Future biomes must **inherit, not replace**.

- **Composition principles stay identical.** Layering, hierarchy, rhythm, navigation language, and spacing rules apply everywhere.
- **Only terrain, vegetation, architecture, and atmosphere change.** A snow biome has snow; a desert biome has sand; the way the world is composed does not change.
- **Lighting language remains consistent.** One directional sun, warm tones, soft shadows — applied to every biome.
- **Visual hierarchy never changes.** Active node > path > region > atmosphere > HUD, in every biome.
- **Biomes share the same emotional contract.** Each biome is the same Playground with different weather.

---

## 45. Accessibility Considerations

Beauty is meaningless if it excludes.

- **Color is never the only signal.** Locked, completed, and active states combine color, shape, and text.
- **Contrast ratios** meet or exceed platform standards for text and meaningful UI elements.
- **Touch targets** are large and forgiving.
- **Motion** respects the player's preference. Reduced-motion mode preserves narrative without animating.
- **Text scaling** is supported across HUD, cards, and labels.
- **Audio cues** are optional companions, never required to understand the world.
- **Semantics** label every meaningful region so screen readers narrate the journey.

---

## 46. Dark Theme Philosophy

Dark mode is not an inversion. It is **a parallel world at twilight**.

- The same shapes, the same composition, the same emotional warmth.
- Sky deepens; terrain cools slightly; glows intensify to compensate.
- Shadows soften; ambient particles become slightly more visible.
- The player's eye must follow the same path; nothing should suddenly disappear or bloom.

---

## 47. Responsive Design Philosophy

The world must feel intentional on every device.

- **Phone** is the canonical experience. Every region must read clearly here first.
- **Tablet** offers more room for atmosphere without losing focus.
- **Desktop** widens the experience but never dilutes it; the world stays centered, not stretched.
- **Resize is graceful.** Layouts adapt by adjusting breathing room, not by abandoning composition.
- The active node and its surroundings remain in focus on every breakpoint.

---

## 48. Performance-aware Visual Design

Beauty must respect the device.

- Visual richness is layered so that detail emerges with capability, never at the cost of frame rate.
- Repaint boundaries isolate animated regions.
- Painter caching is mandatory for repeated geometry.
- Effects (blur, glow, gradient) are used deliberately, where they earn their cost.
- Performance is part of the aesthetic. A smooth world is more beautiful than a feature-rich but janky one.

---

## 49. Future Expansion Rules

When the Playground grows, it must grow in the same language.

- New biomes follow the lighting, shape, and color grammar of the existing world.
- New node types extend the visual hierarchy, not override it.
- New rewards reuse the existing reward vocabulary before introducing new ones.
- New animations enter the motion language, not as one-offs.
- New interactive surfaces (sheets, dialogs) feel like part of the world, not interruptions of it.

---

## 50. Design Rules

These rules apply to every component that enters the Playground.

1. The active node is the most important thing on screen. Nothing competes with it.
2. The path is always visible and always legible.
3. Every decoration implies a reason for existing.
4. Color, shape, and motion together communicate state — never color alone.
5. Spacing is intentional. Density has rhythm.
6. Typography supports hierarchy; it never decorates.
7. Animations are short, curved, and meaningful.
8. Surfaces respect depth. Shadows imply elevation, not weight.
9. Empty space is a deliberate choice.
10. Dark mode is a parallel world, not an inversion.
11. Reduced motion is a first-class experience.
12. Performance is part of the aesthetic.
13. Decorations cluster; nothing exists alone.
14. Curves lead the eye; straight lines do not.
15. Idle motion lives in decorations, not in primary content.

---

## 51. Design Review Checklist

Every Playground feature must satisfy this checklist before implementation is considered complete. Each item is a gate, not a suggestion.

### Composition

- [ ] The active node is the unmistakable visual focus.
- [ ] The path is visible, continuous, and legible at every scroll position.
- [ ] The feature respects the layered depth model (background → terrain → path → midground → foreground → HUD).
- [ ] The feature belongs to a recognizable region with the four concentric zones (interaction, decorative, atmospheric, transition).
- [ ] No decoration or landmark crowds the active node or the immediate path.

### Visual Hierarchy

- [ ] Every element can be classified into one of the five hierarchy tiers (active node > path > region > decoration > HUD).
- [ ] No element raises its tier without explicit justification.
- [ ] Visual weight is asymmetrically balanced unless the moment is ceremonial.

### Readability

- [ ] All text meets contrast standards for both light and dark themes.
- [ ] Color is never the sole carrier of state information.
- [ ] Icons are readable at their minimum rendered size.
- [ ] Active, completed, and locked states are distinguishable without color.

### Spacing & Rhythm

- [ ] Spacing between elements varies intentionally (never uniform unless silence is the point).
- [ ] Density alternates between quiet and rich regions.
- [ ] The feature introduces or reinforces, never breaks, the world's rhythm.
- [ ] Negative space is used deliberately to elevate focus.

### Depth & Lighting

- [ ] Atmospheric depth is consistent: distant elements desaturate, clouds vary by elevation, mountains soften.
- [ ] All shadows are soft, short, and colored (never pure black).
- [ ] Every element obeys the single directional light source.
- [ ] Highlights and glows are warm and gentle, never blown out.

### Animation & Motion

- [ ] Every animation conveys meaning (arrival, attention, completion, transition).
- [ ] Motion belongs to its correct tier (primary > secondary > ambient > HUD).
- [ ] Idle motion is slow, staggered, and atmospheric.
- [ ] Celebrations are reserved for meaningful moments.
- [ ] The feature degrades gracefully under reduced-motion preference.

### Accessibility

- [ ] Touch targets meet platform minimums with generous padding.
- [ ] Text scaling reflows without breaking composition.
- [ ] Semantics label every meaningful region.
- [ ] State information uses color, shape, and text together.
- [ ] Audio is optional, never required to understand the world.

### Responsiveness

- [ ] The feature reads clearly on phone (canonical experience).
- [ ] Tablet and desktop widen the experience without diluting it.
- [ ] The world never stretches horizontally to fill wide screens.
- [ ] Resize behavior is graceful.

### Performance

- [ ] Animated regions are isolated by repaint boundaries.
- [ ] Repeated geometry uses painter caching.
- [ ] Effects (blur, glow, gradient) earn their cost.
- [ ] The feature holds the target frame budget on a mid-tier device.

### Consistency with the Aesthetic

- [ ] The feature obeys all seven core principles in §2.
- [ ] The feature obeys all 15 design rules in §50.
- [ ] The feature introduces no new shape, color, motion, or typographic vocabulary without extending the existing language.
- [ ] The feature preserves the emotional contract: the player continues to inhabit a world, not an interface.

---

## 52. Things That Must Never Be Done

The Playground must never:

- Look like a list, a grid, or a dashboard.
- Stretch the world horizontally to fill wide screens.
- Render the path as straight lines or predictable S-curves.
- Scatter decorations randomly or use them as filler.
- Rely on color alone to communicate state.
- Use harsh contrast, neon saturation, or pure black shadows.
- Celebrate progress with intrusive animations or sound.
- Hide locked content; the player must always see what is ahead.
- Animate the world in a way that demands the player's attention.
- Trade clarity for cleverness.
- Break the lighting language for any single element.
- Treat accessibility as a final-layer compromise.
- Use rigid symmetry where organic variation is expected.
- Animate decoration or HUD elements faster than gameplay content.
- Use decorative fonts in titles, labels, or in-world text.
- Introduce a biome that breaks the shared emotional contract.
- Place a bridge where there is no river, or a river without a meaningful source and destination.
- Reduce the active node's visual dominance for any reason.
- Treat empty space as wasted space; empty space is a design element.
- Ship a feature that fails any item in the Design Review Checklist (§51).

---

## 53. Closing Note

The Playground is a world. Every component is a citizen of that world. New features are not additions to a screen — they are additions to a place. The player does not navigate the Playground; they **inhabit** it.

If a future decision feels uncertain, return to the seven principles in §2. If it still feels uncertain, ask whether the proposed change makes the world feel more like a place the player wants to be. If the answer is no, the change is wrong.

When the work is finished, walk through the Design Review Checklist in §51. Every box must be checked. If a box cannot be checked, the work is not finished.

The world is the player. The player is the world. Protect that bond.
