# Feature: Settings

## Purpose
Lets the user configure global app preferences: display currency, theme mode, and budget-cycle anchor days (week start, month start, year start). These settings are persisted in the `app_settings` SQLite table and are consumed by both the budget feature (for period computation anchors) and core providers (currency, theme).

---

## Entry point
Bottom nav → Settings tab (4th tab in `ScaffoldWithNavBar`).

---

## Files

| File | Purpose |
|------|---------|
| `data/settings_repository.dart` | Wraps `SettingsDao`. Exposes typed watch/get/set methods for each setting key. |
| `providers/settings_providers.dart` | Riverpod providers: manual `Provider` for the repo, `StreamProvider`s for each setting, and a combined `budgetDefaultsProvider`. |
| `view/settings_screen.dart` | Full settings UI: General section (theme, currency) + Budget Cycles section (week/month/year start). Each tile opens a bottom-sheet grid picker. |

---

## Setting keys (`SettingsKeys`)

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `budget_week_start` | `int` (1–7) | `1` (Monday) | Day of week budget weeks begin. ISO weekday: 1=Mon, 7=Sun. |
| `budget_month_start` | `int` (1–31) | `1` | Day of month budget months begin. |
| `budget_year_start` | `int` (1–12) | `1` (January) | Month number budget years begin. |
| `default_currency` | `String` | `'USD'` | Currency code. Used by `selectedCurrencyProvider` in core. |
| `theme_mode` | `String` | `'system'` | One of `'system'`, `'light'`, `'dark'`. |

---

## Providers

| Provider | Type | Purpose |
|----------|------|---------|
| `settingsDaoProvider` | `Provider<SettingsDao>` | Supplies the DAO. Not auto-dispose (keeps DAO stable). |
| `settingsRepositoryProvider` | `Provider<SettingsRepository>` | Supplies the repository. Not auto-dispose. |
| `weekStartProvider` | `StreamProvider<int>` | Reactive week-start anchor (1–7). |
| `monthStartProvider` | `StreamProvider<int>` | Reactive month-start anchor (1–31). |
| `yearStartProvider` | `StreamProvider<int>` | Reactive year-start anchor (1–12). |
| `defaultCurrencyProvider` | `StreamProvider<String>` | Reactive currency code string. |
| `themeModeProvider` | `StreamProvider<String>` | Reactive theme mode string. |
| `budgetDefaultsProvider` | `FutureProvider<BudgetDefaults>` | Combines week/month/year into a single `BudgetDefaults` object. Used by budget feature at submit time. |

> **Note:** These providers use manual `StreamProvider` / `Provider` declarations (not `@riverpod` codegen) because `settings_providers.dart` pre-dates the codegen pattern for this repo. If ever refactored, convert to `@riverpod`.

---

## Cross-feature consumption

- **Budget feature** (`add_budget_controller.dart`): reads `settingsRepositoryProvider` directly at submit time to get `weekStart`, `monthStart`, `yearStart` anchors.
- **Core** (`selected_currency_provider.dart`): watches `defaultCurrencyProvider` / `settingsRepositoryProvider` to drive the app-wide currency formatter.
- **Core** (`app_main` / `MaterialApp`): watches `themeModeProvider` to set `ThemeMode`.

> Settings providers are the **only** exception to the feature-isolation rule: core providers are allowed to read from `settingsRepositoryProvider` because settings are global app state, not feature state.

---

## UI components

- `_SectionHeader` — uppercase section label.
- `_CycleTile` — tappable list tile showing current value; opens a bottom sheet.
- `_CurrencyTile` — variant of `_CycleTile` for `CurrencyConfig` objects.
- `_ThemeModeTile` — variant of `_CycleTile` for theme mode strings.
- `_GridOptionsPickerSheet<T>` — generic grid-based bottom-sheet picker. Accepts any `List<T>`, a `labelBuilder`, and an `onSelected` callback. Used for all three cycle pickers, the currency picker, and the theme picker.

---

## Known TODOs

None.

---

## Last reviewed

`2026-06-15` — Initial draft. Reflects actual implementation as of this date.
