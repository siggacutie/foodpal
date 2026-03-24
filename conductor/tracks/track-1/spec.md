# Track 1: Premium UI Upgrade Specification

## Overview
Fix and upgrade the existing FoodPal UI to a production-quality experience with smooth animations, clean layout, and intelligent behavior.

## Requirements

### 1. Critical Bug Fixes
- **Bottom Overflow:** The nutrition bottom sheet must be vertically scrollable and respect device safe areas (bottom inset).
- **Layout Consistency:** Fix all spacing, alignment, and clipping issues. Ensure consistent padding and responsive layout.

### 2. Calendar System Redesign
- **Interaction:** Smoothly expanding/collapsing calendar anchored to the date.
- **Animation:** Top-anchored expansion, Fade + Scale (250-350ms), Apple-like ease-in-out curve.
- **Scrolling:** Smooth month navigation (swipe/scroll) with momentum and animated transitions.
- **UI:** Polished green accent theme, current day highlighting, rounded date cells, clean spacing.
- **Performance:** Optimize rendering to eliminate lag.

### 3. Daily Calorie Analysis Widget
- **Redesign:** Replace text '735 kcal' with a compact analysis widget in the top right.
- **Data:** Show total consumed vs. daily goal (e.g., 735 / 2000 kcal).
- **Visual:** Circular progress ring or progress bar.
- **Insight:** Add 'Under goal' or 'Over goal' text labels.
- **Animation:** Smooth progress fill on load.

### 4. Smart Food Suggestions
- **Logic:** Only show suggestions when user input matches. Support partial matches.
- **Animation:** Fade + slide up on appearance, fade out on disappearance.

### 5. Add Food Flow
- **Interaction:** Automatically insert new item at the TOP of the list after 'thinking' animation.
- **Data:** Use placeholder nutrition data for new items.
- **Animation:** Fade in + slide down from top, smoothly pushing existing items.

### 6. Micro-interactions & Motion
- **Input Cursor:** Phasing/blinking cursor (smooth fade in/out, ~1s cycle).
- **Card Interactions:** Scale down (0.97-0.98) on tap, smooth return, subtle elevation/shadow change.
- **Bottom Sheet/Popup:** Slower opening (300-400ms), smooth ease-out (physics feel/overshoot).

### 7. Global Animation System
- **Standard:** 250-400ms duration, smooth easing (non-linear).
- **Scope:** Applied consistently to all UI transitions (bottom sheet, calendar, list, suggestions, navbar).
