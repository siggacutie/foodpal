# Track 1: Premium UI Upgrade Implementation Plan

## Objective
Transform the FoodPal UI into a premium, production-quality experience with polished animations, consistent layout, and smart interactions.

## Phases

### Phase 1: Critical UI & Animation Foundation
1.  **Global Animation Constants:** Define standard durations and curves in lib/theme/app_theme.dart.
2.  **Nutrition Bottom Sheet Fix:** 
    - Make scrollable using SingleChildScrollView or ListView.
    - Add SafeArea to respect device bottom insets.
    - Slow down the opening animation (300-400ms) with a physics-inspired curve.

### Phase 2: Calendar System Full Redesign
1.  **Expandable Calendar UI:**
    - Replace the static date pill with a component that expands/collapses.
    - Implement top-anchored expand/collapse animations (fade + scale, 250-350ms).
2.  **Smooth Month Navigation:**
    - Use a PageView or ListView with inertia/momentum for month scrolling.
    - Ensure smooth month transitions.
3.  **UI Refinement:** Green accent theme, rounded cells, current/selected day highlighting.

### Phase 3: Daily Calorie Analysis & Input Refinement
1.  **Analysis Widget:**
    - Redesign top-right '735 kcal' to a circular progress widget with 'Goal' vs 'Consumed'.
    - Add 'Under goal' / 'Over goal' insights.
2.  **Smart Suggestions:**
    - Fix matching logic: only show when user input matches (partial matches allowed).
    - Add fade + slide animations for appearance/disappearance.
3.  **Add Food Flow:**
    - Implement top-of-list insertion logic in LogProvider or LogsPage.
    - Add fade + slide-down animations for new items.

### Phase 4: Micro-interactions & Polish
1.  **Input Cursor:** Implement a custom phasing/blinking cursor using AnimationController.
2.  **Card Tap Interaction:** 
    - Add GestureDetector with scale-down (0.97) and elevation change.
    - Ensure smooth return to normal.
3.  **Layout Audit:** Fix any remaining spacing, alignment, and clipping issues across all screens.

## Verification
- Manual verification of each animation's duration and curve.
- Device testing (simulator/real device) for bottom inset and responsiveness.
- Performance profiling to ensure jank-free rendering.
