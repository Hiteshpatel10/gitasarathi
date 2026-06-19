# Feature: Insights

## Overview
The Insights feature provides visual summaries and data aggregation of the user's transactions. It lives on the second tab of the main application shell and offers a view into spending/income totals, a bar chart across the selected period, and a categorized breakdown of where money went — all filterable by Day, Week, Month, or Year.

## Entry point
The user reaches the screen via the "Insights" icon on the `BottomNavigationBar` in `ScaffoldWithNavBar`. It is rendered as a branch of the `StatefulShellRoute` in `app_router.dart`.

---

## Files

| File | Purpose |
|------|---------|
| `data/insights_repository.dart` | Wraps `TransactionDao` to fetch date-filtered transaction streams. Single DB entry point for this feature. |
| `providers/insights_repository_provider.dart` | Auto-dispose Riverpod provider that constructs `InsightsRepository`. |
| `providers/insights_provider.dart` | All state logic: filter notifier, transaction feed, summary totals, daily/weekly/monthly/yearly chart bars, and category breakdown aggregates. |
| `view/insights_screen.dart` | Main UI: `CustomScrollView` with filter bar, hero section (net/income/expense), proportion bar, bar chart, and category breakdown list. |

---

## State models

### `InsightsFilterState`
- `mode: InsightsFilterMode` — day, week, month, or year.
- `anchorDate: DateTime` — drives the `range` computation.
- `range` — `(DateTime from, DateTime to)` derived from `mode` + `anchorDate`.
- `canGoNext` — `true` when the anchor range has fully elapsed (guards future navigation).
- `isCurrent` — `true` when `now` falls inside the active range.

### `CategoryInsight`
- `category: CategoriesTableData`
- `amountPaise: int`
- `percentage: double` — fraction of total expense spend.
- `transactions: List<TransactionWithCategory>` — sorted newest-first.

### `ChartBarData`
- `label: String` — short axis label (e.g. "M", "T", "5", "J").
- `amountPaise: int`
- `heightFactor: double` — 0.0–1.0 fraction of the tallest bar.

---

## Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `insightsDateRangeProvider` | `@riverpod class InsightsDateRange` | Notifier holding `InsightsFilterState`. Exposes `setMode`, `previous`, `next`, `reset`. |
| `insightsTransactionsProvider` | `@riverpod Stream<List<TransactionWithCategory>>` | Live stream of all transactions (income + expense) for the active range. |
| `insightsSummaryProvider` | `@riverpod Future<(int incomePaise, int expensePaise)>` | Totals derived from `insightsTransactionsProvider`. |
| `insightsCategoryBreakdownProvider` | `@riverpod Future<List<CategoryInsight>>` | Expenses grouped by category, sorted by largest amount. Provides data for the proportion bar and category list. |
| `insightsDailyChartProvider` | `@riverpod Future<List<ChartBarData>>` | Chart bars for the selected mode: 7 bars (week), N bars by day-of-month (month), 1 bar (day), 12 bars by month (year). |

---

## Chart bucketing logic

| Mode | Buckets | Label |
|------|---------|-------|
| Day | Single bar (total for that day) | Weekday abbreviation (e.g., "Mon") |
| Week | 7 bars (Mon–Sun by `weekday` 1–7) | M T W T F S S |
| Month | N bars (1 per day of month) | Day number shown every 5th day |
| Year | 12 bars (1 per month by `month` 1–12) | J F M A M J J A S O N D |

Height factor is always `amountPaise / maxAmountPaise` across buckets; 0.0 if no spend.

---

## Navigation
- Entry: Tapping the 2nd tab in the bottom navigation bar.
- Exit: Tapping another tab.

---

## DB Rules
As per `AGENTS.md` and architecture rules, the Insights feature does not import the `ExpenseRepository`. It accesses data via its own `InsightsRepository`, which directly uses `core/database/daos`.

---

## Last reviewed
`2026-06-15` — Expanded to reflect actual provider types, `InsightsFilterState` model, `CategoryInsight` + `ChartBarData` models, chart bucketing logic table, and full files table.
