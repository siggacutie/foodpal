# Plan: Premium UI and Polished Interactions

Design and implement a premium, modern mobile UI for FoodPal with smooth animations, high-quality motion design, and refined visual hierarchy.

## Objective
Enhance the FoodPal user experience by introducing iOS-level smooth animations, a refined "soft UI" aesthetic, and interactive components like a nutrition detail bottom sheet and a themed calendar date selector.

## Key Files & Context
- `lib/models/log_entry.dart`: Update to include comprehensive nutrition data.
- `lib/providers/log_provider.dart`: Update sample data and add state for the selected date.
- `lib/screens/logs_page.dart`: Update the main log interface, add tap handlers, and refine the add-meal input.
- `lib/widgets/log_widgets.dart`: Update `LogItem` to be interactive.
- `lib/widgets/nutrition_bottom_sheet.dart`: (New) Implement the detailed nutrition view.
- `lib/widgets/bottom_nav_bar.dart`: Refine with smooth animations and a gliding indicator.
- `lib/widgets/date_selector.dart`: (New) Replace the static date pill with an interactive themed selector.
- `lib/theme/app_theme.dart`: Ensure consistent premium styling.

## Implementation Steps

### Phase 1: Models & Data
1.  **Update `LogEntry` & `NutritionInfo`:**
    - Modify `LogEntry` in `lib/models/log_entry.dart` to include a `NutritionInfo` object.
    - `NutritionInfo` will store protein, carbs, fats, fiber, sugar, sodium, and serving size.
2.  **Update `log_provider.dart`:**
    - Add `selectedDateProvider` (using `StateProvider<DateTime>`).
    - Populate `logsProvider` and `searchResultsProvider` with detailed sample nutrition data.

### Phase 2: Nutrition Detail Bottom Sheet
1.  **Create `lib/widgets/nutrition_bottom_sheet.dart`:**
    - Implement `NutritionBottomSheet` using `showModalBottomSheet`.
    - Apply `BackdropFilter` for background blur.
    - Design a premium layout:
        - Header: Food name (bold, large), Time logged (subtle).
        - Primary: Calories (dominant).
        - Macronutrients: Animated circular progress rings or progress bars for Protein (blue), Carbs (orange), Fats (red/yellow).
        - Micronutrients: Secondary section for Fiber, Sugar, Sodium.
        - Actions: Edit and Delete buttons (minimalist).
2.  **Update `LogItem` in `lib/widgets/log_widgets.dart`:**
    - Wrap the item in a `GestureDetector`.
    - Trigger the nutrition bottom sheet on tap.
    - Add a subtle press-down animation for tactile feedback.

### Phase 3: Date Selector Upgrade
1.  **Create `lib/widgets/date_selector.dart`:**
    - Implement an interactive date selector that replaces the `PillButton`.
    - On tap, open the themed calendar UI.
2.  **Themed Calendar:**
    - Use `showDatePicker` with a custom `DatePickerTheme` matching `AppTheme.primaryAccent`.
    - Ensure smooth expand/fade animations when opening.
3.  **Integrate with `LogsPage`:**
    - Update the top bar to use the new `DateSelector`.
    - Ensure selecting a date updates the `selectedDateProvider`.

### Phase 4: Navbar & Input Polish
1.  **Refine `AppBottomNavBar`:**
    - Implement a "gliding" indicator (pill shape) that moves behind the icons when switching tabs.
    - Use `AnimatedContainer` or `Stack` with `AnimatedPositioned` for the gliding effect.
    - Apply iOS-style spring easing to transitions.
2.  **Enhance Add Meal Input:**
    - Change the "+" button color to `AppTheme.primaryAccent`.
    - Add a scale animation (`AnimatedScale`) to the button on tap/interaction.

### Phase 5: Microinteractions & Visual Refinement
1.  **Global Animations:**
    - Ensure all transitions (bottom sheets, tab switching, date picker) use fluid, slightly slowed-down easing (Apple-like).
2.  **Visual Hierarchy:**
    - Audit all cards and containers for consistent corner radii ($24.0$+) and soft shadows.
    - Refine typography weights for better legibility and premium feel.
3.  **Haptic Feedback:**
    - Add `HapticFeedback.lightImpact()` to key interactions (tapping logs, nav bar items, buttons).

## Verification & Testing
1.  **Visual Inspection:**
    - Verify background blur on bottom sheets.
    - Check macronutrient progress bar animations on open.
    - Ensure the gliding navbar indicator is smooth and fluid.
2.  **Interaction Testing:**
    - Tap on food items: verify the bottom sheet slides up smoothly.
    - Tap on date: verify the calendar opens and updates the log.
    - Swipe down to dismiss bottom sheet: verify velocity-based closing.
3.  **Performance:**
    - Ensure animations are jank-free (60fps/120fps).
