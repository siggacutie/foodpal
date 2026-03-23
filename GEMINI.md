# FoodPal Project Context

## Overview
FoodPal is a high-end, AI-powered health and calorie tracker. The core philosophy is "Complexity hidden by Simplicity." It should feel as easy to use as a minimalist To-Do list app.

## Tech Stack
- **Framework:** Flutter (Dart)
- **State Management:** Provider or Riverpod (AI choice for clean architecture)
- **AI Integration:** Gemini API for image-to-nutrition analysis and personalized planning.

## Core Features
- **Logs Page:** A clean, list-based interface for daily food entries. Includes a prominent Camera Icon for AI food recognition.
- **Analytics Tab:** A split view showing raw data (numbers/tables) and "AI Insights" (natural language summaries of health trends).
- **AI Planner:** A conversational interface where users get proactive dietary advice and meal plans.

## Design & Aesthetic (CRITICAL)
- **Primary Style Reference:** Refer to `./logs.png` for the layout, spacing, and typography.
- **Visual Language:** Ultra-minimalist. Use plenty of whitespace, rounded corners ($24.0$ or higher), and subtle soft shadows.
- **Consistency:** All tabs (Analytics, Planner) must share the same "To-Do List" card-based aesthetic found in the logs page.
- **Color Palette:** Professional and clean (e.g., Soft Whites, Slate Greys, and a single accent color like Mint Green or Calm Blue).

## Development Rules
- Always use high-quality Flutter widgets.
- Keep business logic (calculations, AI calls) separate from the UI code.
- Ensure all screens are responsive for different mobile screen sizes.