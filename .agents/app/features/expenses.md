# Feature: Expenses

## Overview
The expenses feature owns the **Add Transaction** flow, the **Edit Transaction** flow, and the **Log** screen. It acts as the primary interface for users to enter, review, and edit their raw transactions.

*Note: With the addition of the Insights feature, Expenses is no longer the ONLY feature reading transaction tables, but it remains the primary owner of creating and logging them.*

## Entry points
1. **Log Screen**: Reached via the first tab on the `BottomNavigationBar` in `ScaffoldWithNavBar`.
2. **Add Transaction**: Reached via the center FAB on the `BottomAppBar` in `ScaffoldWithNavBar`. The route is a **full-screen, outside-the-shell** route (`/expenses/add`) so the bottom nav is hidden while adding.
3. **Edit Transaction**: Reached by tapping any transaction row in `ExpenseLogScreen`. Pushes `/expenses/:id/edit` (outside the shell). The router passes `transactionId` to `AddExpenseScreen` which detects the edit mode internally.

## Files

| File | Purpose |
|------|---------|
| `data/expense_repository.dart` | Wraps `TransactionDao` + `CategoryDao`. Single entry point for this feature's DB operations. |
| `providers/expense_repository_provider.dart` | Auto-dispose Riverpod provider that constructs `ExpenseRepository`. |
| `providers/add_expense_controller.dart` | `@riverpod class AddExpenseController` — owns all transient form state for Add/Edit flow. |
| `providers/log_provider.dart` | State logic containing the Date Range filter, transaction feed, grouped transactions feed, and summary totals for the Log screen. |
| `providers/categories_provider.dart` | Streams categories filtered by Transaction Type for the category picker. |
| `view/expense_log_screen.dart` | The Log tab UI. A sliver-based list showing daily grouped transactions and a summary. Tapping a row navigates to `EditExpenseDestination`. |
| `view/add_expense_screen.dart` | Full-screen modal used for **both** Add and Edit flows. Accepts an optional `transactionId`; when non-null, pre-fills state from the existing transaction. Header toggle, large amount canvas, note/date/category chips. |
| `view/widgets/category_picker_sheet.dart` | Bottom sheet for selecting a category during the Add/Edit flow. |
| `view/widgets/category_icon.dart` | Helpers (`categoryIconData`, `categoryHexColor`) that map an icon name string to `IconData` and a color hex string to `Color`. Pure functions, no provider dependencies. |

> **Note:** The numpad widget (`NumpadWidget`) lives in `shared/widgets/numpad_widget.dart` — it is used by both the expenses and budget features.

## State models

### `AddExpenseState`
- `rawAmount: String` — raw digits as typed (e.g. `"1234"` = ₹12.34). Max 9 digits.
- `type: TransactionType` — expense or income toggle.
- `selectedCategoryId: int?` — null until user picks a category.
- `note: String` — optional transaction description.
- `transactedAt: DateTime?` — defaults to `DateTime.now()` at submit time.
- `submitting: bool`, `error: String?` — async submit state.

### `LogFilterState`
- `mode: LogFilterMode` — day, week, month, or year filter mode.
- `anchorDate: DateTime` — anchor used to calculate the date range.

### Key computed properties on `LogFilterState`
- `range` — `(DateTime from, DateTime to)` computed from `mode` + `anchorDate`.
- `canGoNext` — `true` when current anchor range has already ended (guard against future navigation).
- `isCurrent` — `true` when `now` falls inside the active range (controls "Current" button visibility).

## Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `logDateRangeProvider` | `@riverpod class LogDateRange` | Notifier holding `LogFilterState`. Exposes `setMode`, `previous`, `next`, `reset`. |
| `logTransactionsProvider` | `@riverpod Stream` | Live stream of `TransactionWithCategory` for the active date range. |
| `logGroupedTransactionsProvider` | `@riverpod Future` | Derived from `logTransactionsProvider`; groups by calendar day (descending). Returns `SplayTreeMap<DateTime, List<TransactionWithCategory>>`. |
| `logPeriodSummaryProvider` | `@riverpod Future` | Computes `(int incomePaise, int expensePaise)` totals for the active range. |

## Money rule
Amount is **always stored as `int` paise**. `rawAmount` is treated as whole rupees typed by the user and converted via the currency utils in `core/utils/currency_format_utils.dart` only at submit time.

## Navigation
- Entry to Add: `context.goNamed(AppRoutes.addExpense.name)` from `ScaffoldWithNavBar`'s FAB.
- Entry to Edit: `context.pushTo(EditExpenseDestination(tx.id))` from `_TransactionTile` in `ExpenseLogScreen`.
- Exit from Add/Edit: `context.pop()` on successful save or close button tap.

## Known TODOs
- `// TODO( 2026-07)`: Replace `defaultAccountId: 1` with a real account picker sheet.
- `expenseDetail` route (`/expenses/:id`) still returns a `_Placeholder` — not yet built.

## Last reviewed
`2026-06-15` — Updated to reflect edit-expense integration (reuses `AddExpenseScreen`), `numpad_widget` relocation to `shared/`, `category_icon.dart` widget added, and expanded provider table.
