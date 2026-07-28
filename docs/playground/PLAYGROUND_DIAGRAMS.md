# Playground Architecture Flowcharts

This file collects Mermaid diagrams that describe the structure and runtime behaviour of the Playground feature. Each block is fenced with `mermaid` so it can be rendered by any Mermaid-compatible viewer (GitHub, VS Code with the Mermaid extension, Notion, etc.).

## 1. PlaygroundScreen — Root Stack Composition

```mermaid
flowchart TB
    Scaffold["Scaffold.body\nLayoutBuilder"]

    subgraph RootStack["Root Stack (fit: expand)"]
        direction TB
        Map["Positioned.fill\nPlaygroundMap"]
        Particles["Positioned.fill\nIgnorePointer +\nPlaygroundParticleLayer"]
        HUD["Positioned top\nPlaygroundTopBar"]
        Nav["Positioned bottom\nCustomBottomNavigation"]
    end

    Scaffold --> RootStack
```

## 2. PlaygroundMap — Internal Stack & Scroll View

```mermaid
flowchart TB
    PB["RepaintBoundary\n+ ClipRect"]

    subgraph MapStack["Map internal Stack (fit: expand)"]
        direction TB
        Bg["Positioned.fill\nPlaygroundBackground (sky)"]
        AtmFixed["Positioned.fill\n_atmosphericOverlay (fixed cloud)"]
        AtmWorld["Positioned.fill\natmosphericDecorations (world cloud)"]
        Scroll["Positioned.fill\nPlaygroundScrollView"]
        Legend["Positioned bottom\nPlaygroundLegend"]
    end

    subgraph ScrollInner["ScrollView inner Stack"]
        direction TB
        Path["_buildPathLayer"]
        Bld["_buildBuildingsLayer"]
        Dec["_buildDecorationsLayer"]
        Part["_buildParticleLayer"]
        Nodes["_buildNodesLayer"]
    end

    PB --> MapStack
    AtmWorld --> Scroll
    Scroll --> ScrollInner
    Path --> Bld --> Dec --> Part --> Nodes
```

## 3. Camera Focus Initialization

```mermaid
flowchart LR
    A["PlaygroundScreen.build"] --> B["LayoutBuilder"]
    B --> C["WorldLayout.build\nworldWidth = viewport"]
    C --> D["PlaygroundMap"]
    D --> E["PlaygroundScrollView.initState"]
    E --> F["postFrameCallback\nfocusTarget"]
    F --> G["camera.snapTo\n(viewport, content)"]
    G --> H["ScrollController.jumpTo"]
    H --> I["World content centered"]
```

## 4. Vertical Scrolling Flow

```mermaid
flowchart LR
    Touch["User drag\n(vertical)"] --> Scroll["SingleChildScrollView\n(BouncingScrollPhysics)"]
    Scroll --> Ctrl["ScrollController.offset"]
    Ctrl --> Handler["_handleScrollChanged"]
    Handler --> Cam["PlaygroundCamera.setTranslation"]
    Cam --> Notify["notifyListeners"]
    Notify --> CamHandler["_handleCameraChanged"]
    CamHandler --> Jump["ScrollController.jumpTo\n(if changed externally)"]
```

## 5. Atmospheric Cloud Layering

```mermaid
flowchart TB
    subgraph BottomLayer["Below world content"]
        Sky["PlaygroundBackground (sky)"]
    end

    subgraph Atmosphere["Atmospheric overlay (fixed, viewport-locked)"]
        FixedCloud["_AtmosphericOverlay (manual Cloud)"]
        WorldCloud["atmosphericDecorations\n(world-layout Cloud)"]
    end

    subgraph WorldLayer["Scrollable world"]
        Path["Path"]
        Bld["Buildings"]
        Dec["Decorations (trees, bushes, etc.)"]
        Nodes["Nodes"]
    end

    subgraph Foreground["Foreground"]
        Particles["PlaygroundParticleLayer"]
        HUD["PlaygroundTopBar"]
        Nav["CustomBottomNavigation"]
    end

    Sky --> FixedCloud
    FixedCloud --> WorldCloud
    WorldCloud --> Path
    Path --> Bld --> Dec --> Nodes
    WorldLayer --> Particles
    Particles --> HUD
    HUD --> Nav
```

## 6. Bottom Navigation Tab Flow

```mermaid
flowchart LR
    User["User taps tab"] --> Nav["CustomBottomNavigation.onTap"]
    Nav --> Handler["_onTabSelected(index)"]
    Handler --> Decision{"index ==\nPlayground tab?"}
    Decision -- Yes --> NoOp["No-op\n(already on Playground)"]
    Decision -- No --> Router["context.goNamed\n(AppRoutes.playground)"]
    Router --> Re["Push /playground route"]
    Re --> Nav
```