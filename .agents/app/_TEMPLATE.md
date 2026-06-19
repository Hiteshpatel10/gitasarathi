# Feature: <Name>

Copy this file to `.agents/features/<feature_name>.md` when you create a new feature. Fill in each section. Keep it under one page.

---

## Purpose

One paragraph: what this feature does for the user. Not how — what.

## Surface area

- **Screens:** list the screens this feature owns.
- **Entry points:** how the user gets here (nav routes, deep links, notifications).

## Data

- **Tables read:** which Drift tables.
- **Tables written:** which Drift tables.
- **DAOs used:** list DAO classes.
- **Cross-feature data:** any data sourced from elsewhere and how (always through `core/`, never sibling features).

## Providers

List the main providers and what each represents. Mark `keepAlive` ones explicitly. Example:

- `expenseListProvider` — `Stream<List<Expense>>`, current month, auto-dispose.
- `expenseFiltersProvider` — `ExpenseFilters`, user-set filters, auto-dispose.
- `filteredExpensesProvider` — derived from the two above.

## State machine (if any)

If the feature has a multi-step flow (add expense, onboarding, etc.), sketch the states and transitions in 5–10 lines. Skip if N/A.

## Open questions / TODOs

Anything unresolved. Each item should have an owner and a rough date.

## Last reviewed

`YYYY-MM-DD` — short note on what changed.
