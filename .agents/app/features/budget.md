# Feature: Budget

## Purpose

Lets the user set spending limits — either for a specific category or across all spending — over a recurring time window (daily, weekly, monthly, yearly). Each budget tracks actual spend against the limit for the current period, and preserves a version history so that editing the amount never rewrites past records. The user can step backward through previous periods and see what they actually spent vs what the limit was at that time.

---

## Surface area

- **Screens:**
  - `BudgetListScreen` — shows all active budgets (overall + category) as cards.
  - `BudgetDetailScreen` — single budget, current period progress, period stepper to view history.
  - `AddBudgetScreen` — multi-step wizard for creating a new budget.
  - `EditBudgetSheet` — bottom sheet to update the amount of an existing budget.

- **Entry points:**
  - Bottom nav → Budgets tab.
  - `BudgetListScreen` → "+" button → `AddBudgetScreen`.
  - `BudgetListScreen` → tap card → `BudgetDetailScreen`.
  - `BudgetDetailScreen` → edit icon → `EditBudgetSheet`.

---

## Data

- **Tables read:** `budgets`, `budget_versions`, `categories`, `transactions`
- **Tables written:** `budgets` (`archived_at` for soft delete), `budget_versions`
- **DAOs used:** `BudgetDao`, `TransactionDao` (read-only, for spend calculation)
- **Cross-feature data:**
  - Category list (name, colour, emoji) sourced via `core/categories` — never imported directly from the categories feature.
  - Transactions for spend totals sourced via `core/transactions` — filtered by date range and optionally by `category_id`.

---

## Files

| File | Purpose |
|------|---------|
| `data/budget_repository.dart` | Single entry point for all budget DB operations. Wraps `BudgetDao` + `TransactionDao`. Also owns the static `computePeriod` method (pure logic). |
| `providers/budget_repository_provider.dart` | Auto-dispose Riverpod provider constructing `BudgetRepository`. |
| `providers/budget_list_provider.dart` | `@riverpod Stream<List<BudgetWithLatestVersion>>` — drives `BudgetListScreen`. |
| `providers/budget_detail_provider.dart` | `@riverpod Stream<BudgetWithLatestVersion?>` — drives `BudgetDetailScreen`. |
| `providers/budget_period_provider.dart` | `@riverpod Future<BudgetPeriod?>` — pure period computation derived from `budgetDetailProvider`. Takes `budgetId` + `periodOffset`. |
| `providers/budget_spend_provider.dart` | Manual `StreamProvider.family<int, _SpendKey>` (not codegen — DateTime family param restriction). Reactive sum of expense paise within a period window. |
| `providers/active_budget_version_provider.dart` | Manual `StreamProvider.family<BudgetVersionsTableData?, ActiveVersionKey>` (DateTime family param restriction). Fetches the version active at `periodEnd`. |
| `providers/category_budgets_total_provider.dart` | `@riverpod Future<int>` — sum of latest amounts across all active category budgets (paise). Used in `AddBudgetScreen` for the overall-budget warning. |
| `providers/add_budget_controller.dart` | `@riverpod class AddBudgetController` — owns wizard state machine and submit logic. |
| `view/add_budget_screen.dart` | Multi-step creation wizard. |
| `view/budget_detail_screen.dart` | Single budget detail with period stepper. |
| `view/budget_list_screen.dart` | List of all active budgets. |
| `view/edit_budget_sheet.dart` | Bottom sheet for editing an existing budget's amount. |

---

## Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `budgetListProvider` | `Stream<List<BudgetWithLatestVersion>>` | All active (non-archived) budgets joined with their latest version. Auto-dispose. |
| `budgetDetailProvider(budgetId)` | `Stream<BudgetWithLatestVersion?>` | Single budget with its latest version. Auto-dispose. |
| `budgetPeriodProvider(budgetId, periodOffset)` | `Future<BudgetPeriod?>` | Current or offset period dates (pure computation via `BudgetRepository.computePeriod`). Auto-dispose. |
| `budgetSpendProvider` | `StreamProvider.family<int, _SpendKey>` | Reactive expense sum (paise) for a given budget + period window. `_SpendKey = ({int budgetId, int? categoryId, DateTime periodStart, DateTime periodEnd})`. Manual, not codegen. |
| `activeBudgetVersionProvider` | `StreamProvider.family<BudgetVersionsTableData?, ActiveVersionKey>` | Version row active at `periodEnd`. `ActiveVersionKey = ({int budgetId, DateTime periodEnd})`. Manual, not codegen. |
| `categoryBudgetsTotalProvider` | `Future<int>` | Sum of latest amounts across all active category budgets. Auto-dispose. |
| `addBudgetControllerProvider` | `@riverpod class` | Wizard state machine (`AddBudgetState` + `AddBudgetStep`). Auto-dispose. |

> **Note:** `budgetSpendProvider` and `activeBudgetVersionProvider` are declared as manual `StreamProvider.family` (not `@riverpod`) because `riverpod_generator` does not support `DateTime` as a family parameter.

---

## State machine (`AddBudgetScreen`)

```
start
  └─► pickType          (overall / category)
        ├─► [category]  pickCategory
        │     └─► pickTimeFrame → setAmount → saving ──► done
        └─► [overall]   pickTimeFrame → setAmount → saving ──► done
                                                        └─► error (duplicate check failed)
```

> **v1 change:** The `pickStartAnchor` step was removed. All period types now skip directly from `pickTimeFrame` to `setAmount`. Anchors are read from Settings at submit time via `SettingsRepository`.

Transitions are linear — no back-branching except the system back gesture, which calls `stepBack()`. `saving` does two writes in a DB transaction: `INSERT INTO budgets` then `INSERT INTO budget_versions`. On unique-constraint failure (duplicate category or duplicate overall), `DuplicateBudgetException` surfaces an error on `setAmount` and stays.

---

## Decisions

- **Edit `valid_from` timing:** `valid_from = DateTime.now()`. Current period is split — spend before the edit is judged against the old amount, spend after against the new. No smoothing across the period.
- **Delete strategy:** Soft delete via `archived_at` column on `budgets`. Active budgets are `WHERE archived_at IS NULL`. Archived budgets remain readable in `BudgetDetailScreen` history but are hidden from `BudgetListScreen`. `budget_versions` rows are never deleted.
- **Period anchor for weekly/monthly/yearly:** Sourced from `SettingsRepository` (week_start, month_start, year_start keys) at submit time, not captured in the wizard. This means changing the global setting affects all budgets created with that period type.
- **Pace indicator:** Deferred to v2. Not in scope for v1.

## Open questions / TODOs

None — all decisions resolved as of Jun 2026.

---

## Last reviewed

`2026-06-13` — Initial draft. Schema, versioning logic, overall vs category split, creation wizard state machine defined.
`2026-06-13` — All three open questions resolved. Soft delete added to schema, `valid_from = today` confirmed, pace indicator moved to v2.
`2026-06-15` — Updated files table, provider table, and state machine to match actual implementation. `pickStartAnchor` step removed; anchor now sourced from Settings. Manual `StreamProvider.family` caveats for DateTime documented.