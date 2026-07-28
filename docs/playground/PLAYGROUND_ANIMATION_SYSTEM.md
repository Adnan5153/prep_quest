# Playground — Animation System

> **Audience:** AI agents and developers who must add or tune motion in the Playground feature.
> **Purpose:** Define the animation philosophy, every reusable animation (nodes, buildings, paths, rewards, particles, camera), transition rules, and reduced-motion accessibility. Every animation in this document is implemented as a `Widget` under `widgets/animations/` (or as a painter) and reads its duration from `presentation/constants/playground_constants.dart`.
> **Related docs:** [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md), [Rendering Pipeline](./PLAYGROUND_RENDERING_PIPELINE.md), [UI Guidelines](./PLAYGROUND_UI_GUIDELINES.md), [Gameplay Flow](./PLAYGROUND_GAMEPLAY_FLOW.md).

---

## 1. Animation Philosophy

Playground motion is **purposeful, never decorative**. Every animation must answer: *"What state change is this animation communicating?"*

| Principle                                       | Implementation rule                                                                                                              |
|-------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------|
| **Animations are information, not ornament.**    | Every animation reveals, confirms, or guides. No animation exists solely to look pretty.                                       |
| **Motion is consistent across the feature.**     | All entrance animations use `Curves.easeOutCubic`. All exit animations use `Curves.easeInCubic`. All reward animations use `Curves.elasticOut`. |
| **Duration is short.**                          | Default duration is 240 ms for state changes, 800 ms for reveals, 1200 ms for celebrations. Anything longer must be justified.   |
| **Stagger is choreographed, not random.**        | Stagger delay = `80 ms × index`, capped at 5 elements. Beyond 5, group instead of stagger.                                       |
| **Reduced motion is a first-class state.**      | Every animation checks `MediaQuery.disableAnimations` and provides a static fallback.                                           |
| **Performance is non-negotiable.**              | Every animation runs through an explicit `AnimationController` or `Tween`, never via repeated `setState`.                     |

The motion language is shared across the entire feature so users build an intuition: "if it's a `Curves.elasticOut`, it's a reward."

---

## 2. Node Animations

Node animations communicate the four meaningful state transitions: `locked → unlocked`, `unlocked → inProgress`, `inProgress → completed`, and the boss variant.

### 2.1 `NodeGlowAnimation` — active pulse

- **Purpose:** Continuously signal "this is the next thing to do."
- **Used by:** `MapNode` for `unlocked`, `inProgress`, `boss` states.
- **Duration:** `1600 ms` loop (`PlaygroundDurations.nodeGlowCycle`).
- **Curve:** `Curves.easeInOutSine`.
- **Tween:** scale `1.0 → 1.06 → 1.0`, opacity halo `0.6 → 1.0 → 0.6`.
- **Pause on reduced motion.**

```dart
class NodeGlowAnimation extends StatefulWidget {
  final bool active;
  final Widget child;
  // ...
}
```

### 2.2 `UnlockAnimation` — locked → unlocked burst

- **Purpose:** Celebrate a freshly unlocked node.
- **Used by:** `MapNode` (status transition) and `BossGate`.
- **Duration:** `1200 ms` (`PlaygroundDurations.unlockBurst`).
- **Composition:** three coordinated tweens.
  1. Ring expansion: scale `0.6 → 1.2`, opacity `0.0 → 1.0 → 0.0`.
  2. Particle burst: 12 radial particles outward.
  3. Subject icon bounce: scale `1.0 → 1.15 → 1.0`.
- **Curve:** outer ring `Curves.easeOutBack`, icon bounce `Curves.elasticOut`.
- **Plays once.** Triggered by the controller after `completeLevel`.

```dart
UnlockAnimation(
  playing: status == NodeStatus.unlocked && justCompleted,
  child: PlaygroundNode(...),
)
```

### 2.3 Node state transition table

| From → To          | Animation                                                            | Duration | Curve              |
|--------------------|----------------------------------------------------------------------|----------|--------------------|
| `locked → unlocked` | `UnlockAnimation` (ring + particles + bounce)                       | 1200 ms  | `easeOutBack` + `elasticOut` |
| `unlocked → inProgress` | Ring color fades from `unlocked` to `inProgress` + label slide-up | 280 ms   | `easeOutCubic`     |
| `inProgress → completed` | Ring fades to `completed` + check badge pop + shine sweep         | 600 ms   | `easeOutCubic`     |
| any → `boss`       | Crown badge pop + accent halo                                         | 480 ms   | `elasticOut`       |
| completed node idle | Soft shine every 6 s                                                  | 1200 ms  | `easeInOutSine`    |

### 2.4 Implementation contract

- All node animations live inside `MapNode` or `PlaygroundNode`. Screens never animate nodes directly.
- Each animation is wrapped in a `RepaintBoundary` to keep cost local.
- `AnimationController` instances are owned by the node widget, never by the parent screen.

---

## 3. Building Animations

Buildings are mostly static, but three subtle animations signal engagement without becoming distracting.

### 3.1 `BuildingProgress` level-up pulse

- **Purpose:** Briefly celebrate a building's progress level increasing.
- **Duration:** `800 ms`.
- **Curve:** `Curves.easeOutBack` for the chip scale; `Curves.easeOutCubic` for the badge color.
- **Triggered by:** Riverpod `levelProgressProvider` emitting a new value for the building's subject.

### 3.2 Building idle parallax

- **Purpose:** Buildings "breathe" so the world feels alive.
- **Duration:** `4400 ms` loop.
- **Tween:** translate-Y `0 → 2 dp → 0`.
- **Curve:** `Curves.easeInOutSine`.
- **Paused on reduced motion.**

### 3.3 Building tap feedback

- **Purpose:** Confirm the tap.
- **Duration:** `120 ms`.
- **Tween:** scale `1.0 → 0.94 → 1.0` (Material press feedback).
- **Curve:** `Curves.easeOut`.

### 3.4 Boss entrance

- **Purpose:** Make boss buildings feel like a milestone.
- **Duration:** `900 ms`.
- **Composition:** magenta halo expand + crown badge pop + low-frequency Lottie.
- **Plays once** when the user first unlocks the boss node.

---

## 4. Path Animations

Path animations reveal the journey and celebrate progress.

### 4.1 `PathAnimation` — segment reveal

- **Purpose:** When a node completes, draw the segment from that node to the next.
- **Used by:** `AnimatedPath` widget.
- **Duration:** `800 ms` (`PlaygroundDurations.pathReveal`).
- **Curve:** `Curves.easeInOutCubic`.
- **Tween:** stroke length `0 → 1` via `Tween<double>` driving `PathMetric.getTangentForOffset`.
- **Paused on reduced motion.**

```dart
AnimatedPath(
  from: previousNode,
  to: nextNode,
  controller: _pathRevealController, // started by controller after completeLevel
)
```

### 4.2 `AnimatedPath` glow pulse

- **Purpose:** A subtle pulse on the active segment to draw the eye.
- **Duration:** `1800 ms` loop.
- **Tween:** glow opacity `0.4 → 0.8 → 0.4`.
- **Curve:** `Curves.easeInOutSine`.

### 4.3 Path dash animation (future segments)

- **Purpose:** The dashed segments subtly march to suggest "incoming."
- **Duration:** `1200 ms` loop.
- **Curve:** linear (`Curves.linear`).
- **Tween:** dash offset `0 → 12 dp`.
- **Paused on reduced motion.**

---

## 5. Reward Animations

Reward animations are the **loudest** in the feature. They are reserved for completion moments.

### 5.1 `ChestAnimation` — chest opening

- **Purpose:** Reveal the chest in three phases: closed → opening → open.
- **Used by:** `RewardChest`.
- **Total duration:** `1500 ms`.
- **Phases:**
  1. `0–600 ms`: lid lifts (`Curves.easeOutBack`).
  2. `600–1000 ms`: light beam + sparkles (`Curves.easeOutCubic`).
  3. `1000–1500 ms`: chest content floats up (`Curves.elasticOut`).
- **Triggered by:** controller after `level_completed_screen.dart` mounts.

### 5.2 `XpReward` and `CoinReward` float-up

- **Purpose:** Animated counters rise from the chest toward their respective HUD indicators.
- **Duration:** `1200 ms`.
- **Tween:** translate-Y `0 → -120 dp`; opacity `1.0 → 0.0`.
- **Curve:** `Curves.easeInCubic`.
- **Destination-aware:** the floating element follows a `Bezier` curve whose end point is the HUD indicator's position (`XpIndicator` or `CoinCounter`).

### 5.3 `RewardPopup` entrance

- **Purpose:** Compose all reward pieces into one orchestrated entrance.
- **Duration:** `1500 ms` total.
- **Composition:**
  1. `0–1500 ms`: chest scales `0.6 → 1.0` (`Curves.elasticOut`).
  2. `300–700 ms`: `XpReward` enters (`Curves.easeOutBack`).
  3. `500–900 ms`: `CoinReward` enters (`Curves.easeOutBack`).
- **Stagger delay:** `200 ms`.

### 5.4 Confetti / sparkle particles

- **Purpose:** Ambient celebration, not the primary feedback.
- **Duration:** `1800 ms`.
- **Composition:** 24 radial sparkles + 6 confetti rectangles falling under gravity.
- **Curve:** physics-based via `SpringSimulation` (no curve).

### 5.5 Reduced motion fallback

When `MediaQuery.disableAnimations == true`:

- Chest snaps open instantly; lid is in the open position.
- XP and Coin counters fade in over 200 ms (no float-up).
- Sparkles are disabled.

---

## 6. Particle Effects

Particle effects add ambient life to the world without distracting.

### 6.1 `Particles`

- **Purpose:** Ambient floating particles (pollen, fireflies).
- **Implementation:** `CustomPainter` driven by a `Ticker`.
- **Count:** 24 cap.
- **Duration:** `6000 ms` per cycle (each particle loops independently).
- **Curve:** smooth noise via `Curves.linear` modulating offset.

### 6.2 `Cloud`

- **Purpose:** Drifting clouds.
- **Count:** 6 cap.
- **Duration:** `12000 ms` per full horizontal traversal.
- **Curve:** `Curves.linear`.

### 6.3 Performance

- Cap particle counts globally. Never exceed.
- Throttle to 30 fps when `WidgetsBinding.instance.lifecycleState == AppLifecycleState.paused`.
- Reuse particle instances (pool of 24) — never allocate new particles per frame.

### 6.4 Reduced motion

Particles freeze in place; clouds pause. The world remains visible but does not move.

---

## 7. Camera Motion

The "camera" is the transform applied to the world by `PlaygroundCamera`.

### 7.1 Camera recenter

- **Trigger:** A node completes, or the user taps a node.
- **Duration:** `600 ms`.
- **Curve:** `Curves.easeInOutCubic`.
- **Tween:** translate to the new center node's position.
- **Reduced motion:** snaps instantly.

### 7.2 Zoom-in (boss preview)

- **Trigger:** Long-press on a boss node.
- **Duration:** `400 ms`.
- **Curve:** `Curves.easeOutCubic`.
- **Tween:** scale `1.0 → 1.15`.

### 7.3 Zoom-out

- **Trigger:** Dismiss the boss preview.
- **Duration:** `400 ms`.
- **Curve:** `Curves.easeInCubic`.
- **Tween:** scale `1.15 → 1.0`.

### 7.4 Pan following active node

- **Trigger:** The user is on `LevelScreen`; the camera subtly pans toward the active node when returning.
- **Duration:** `800 ms`.
- **Curve:** `Curves.easeInOutCubic`.

---

## 8. Transition Rules

### 8.1 Screen transitions

| From → To                                  | Transition                                                            |
|--------------------------------------------|------------------------------------------------------------------------|
| Playground → World Map                     | none (same scaffold; tab swap is instant).                            |
| World Map → Level                          | shared-axis transition (`flutter`'s `PageTransitionsTheme`).           |
| Level → Challenge                          | shared-axis on Y axis.                                                 |
| Challenge → Level Completed                | fade-through (the celebration needs its own focus).                   |
| Level Completed → World Map                | fade-through + scale-down on completion screen.                       |
| World Map → Bottom Sheet                   | standard `showModalBottomSheet` (240 ms easeOutCubic).                |
| World Map → Dialog                         | `showDialog` with `scale` + `fade` (280 ms easeOutBack).              |
| World Map → Reward Popup                   | `OverlayEntry` insertion (no route change). 420 ms elasticOut.        |

### 8.2 Bottom sheet rules

- Bottom sheets enter from below.
- Drag-down dismisses with `Curves.easeInCubic` 200 ms.
- Swiping down past 60% of height closes immediately.

### 8.3 Dialog rules

- Dialogs scale `0.92 → 1.0` and fade in.
- Tapping outside (on scrim) closes.
- Hardware back closes.

### 8.4 Hero transitions

- `XpIndicator` (HUD) is the hero target for `XpReward`.
- `CoinCounter` (HUD) is the hero target for `CoinReward`.
- The reward popup hosts the `Hero` source widget for each float.

---

## 9. Reduced Motion Accessibility

The Playground must respect the system "Reduce Motion" setting (`MediaQuery.disableAnimations`). Reduced motion is a first-class state.

### 9.1 Detection

```dart
final bool reduceMotion = MediaQuery.of(context).disableAnimations;
```

Every animation widget reads this and provides a static or instant fallback.

### 9.2 Fallback matrix

| Animation                  | Default                                | Reduced motion fallback                                       |
|----------------------------|-----------------------------------------|---------------------------------------------------------------|
| `NodeGlowAnimation`         | looping pulse                            | static ring at full opacity (no pulse).                       |
| `UnlockAnimation`           | ring + particles + bounce                | ring expands once over 200 ms; particles disabled.            |
| `PathAnimation`             | stroke draw over 800 ms                  | stroke appears instantly.                                      |
| `ChestAnimation`            | 1500 ms three-phase                      | chest snaps open in 100 ms; sparkles disabled.                |
| `XpReward` / `CoinReward`   | float-up to HUD                          | fade in over 200 ms in place.                                  |
| Particles                   | looping drift                            | frozen in current position.                                    |
| Clouds                      | looping drift                            | frozen.                                                        |
| Camera recenter             | 600 ms ease                              | instant snap.                                                  |
| Bottom sheet entrance       | 240 ms easeOutCubic                      | 80 ms linear fade.                                             |
| Dialog entrance             | 280 ms easeOutBack                       | 80 ms linear fade.                                             |
| Reward popup entrance       | 420 ms elasticOut                        | 100 ms linear fade.                                            |

### 9.3 Implementation pattern

Every animation widget exposes a `playing` boolean and uses `MediaQuery.disableAnimations` to gate the controller's start:

```dart
@override
void initState() {
  super.initState();
  final reduceMotion = MediaQuery.of(context).disableAnimations;
  if (widget.playing && !reduceMotion) {
    _controller.forward();
  }
}
```

For looping animations, the controller's repeat is also gated:

```dart
if (!reduceMotion) {
  _controller.repeat();
}
```

### 9.4 What reduced motion does not change

- **State semantics.** A completed node still looks completed.
- **Color tokens.** The dim "locked" gray is still the dim "locked" gray.
- **Layout.** All sizes remain identical.
- **Functionality.** Every interaction still works.

### 9.5 What reduced motion *does* change

- Pulse, glow, breathing — disabled.
- Float-up of rewards — replaced with fade-in.
- Stroke-draw animations — replaced with instant appearance.
- Elastic bounces — replaced with linear fade.
- Camera transitions — replaced with instant snap.

### 9.6 User preference fallback

If the OS does not expose "Reduce Motion" but the user enables a per-feature "Reduce Motion" toggle in `Settings`:

- A `playgroundReducedMotionProvider` (boolean) is read by every animation widget.
- This provider is independent of `MediaQuery.disableAnimations` so app settings override OS settings.

---

## 10. Animation Durations Reference

| Token                              | Value           | Used by                                              |
|------------------------------------|------------------|------------------------------------------------------|
| `PlaygroundDurations.tap`          | `120 ms`         | Press feedback.                                       |
| `PlaygroundDurations.state`        | `240 ms`         | Generic state transitions.                            |
| `PlaygroundDurations.dialog`       | `280 ms`         | Dialog entrance.                                      |
| `PlaygroundDurations.bottomSheet`  | `240 ms`         | Bottom sheet entrance.                                |
| `PlaygroundDurations.camera`       | `600 ms`         | Camera recenter.                                      |
| `PlaygroundDurations.pathReveal`   | `800 ms`         | Path-draw reveal.                                     |
| `PlaygroundDurations.unlockBurst`  | `1200 ms`        | `UnlockAnimation`.                                    |
| `PlaygroundDurations.chest`        | `1500 ms`        | `ChestAnimation`.                                     |
| `PlaygroundDurations.rewardPopup`  | `1500 ms`        | `RewardPopup` orchestration.                         |
| `PlaygroundDurations.nodeGlowCycle`| `1600 ms`        | `NodeGlowAnimation` loop.                            |
| `PlaygroundDurations.pathGlowCycle`| `1800 ms`        | Active segment glow pulse.                           |
| `PlaygroundDurations.particle`     | `6000 ms`        | Particle loop.                                       |
| `PlaygroundDurations.cloud`        | `12000 ms`       | Cloud traversal.                                      |

All durations are defined in `presentation/constants/playground_constants.dart`.

---

## 11. Animation Curves Reference

| Token                                  | Curve                | Used for                                                   |
|----------------------------------------|----------------------|------------------------------------------------------------|
| `PlaygroundCurves.state`               | `Curves.easeOutCubic`| Generic state transitions.                                  |
| `PlaygroundCurves.exit`                | `Curves.easeInCubic` | Dismiss / float-up.                                          |
| `PlaygroundCurves.emphasized`          | `Curves.easeOutBack` | Press / unlock entrance.                                    |
| `PlaygroundCurves.reward`              | `Curves.elasticOut`  | Reward popup, XP/coin floats, badge pop.                    |
| `PlaygroundCurves.breathe`             | `Curves.easeInOutSine` | Looping gentle motion (node glow, cloud).                 |
| `PlaygroundCurves.march`               | `Curves.linear`      | Dash march, particle drift.                                 |

---

## 12. Cross-Document Map

| If you want to…                                  | Open                                                                |
|--------------------------------------------------|---------------------------------------------------------------------|
| See which widget owns each animation             | [Widget Architecture](./PLAYGROUND_WIDGET_ARCHITECTURE.md)         |
| Understand the painter order                     | [Rendering Pipeline](./PLAYGROUND_RENDERING_PIPELINE.md)           |
| Adjust durations or curves                       | [UI Guidelines](./PLAYGROUND_UI_GUIDELINES.md)                     |
| See what triggers each animation                 | [Gameplay Flow](./PLAYGROUND_GAMEPLAY_FLOW.md)                     |
| Add a new animation (e.g. weather drift)         | [Future Expansion](./PLAYGROUND_FUTURE_EXPANSION.md)               |

---

**End of document.**