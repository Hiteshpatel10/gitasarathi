# Conventions

## Naming

| Kind                  | Pattern                          | Example                              |
|-----------------------|----------------------------------|--------------------------------------|
| File                  | `snake_case.dart`                | `expense_list_provider.dart`         |
| Class                 | `PascalCase`                     | `ExpenseRepository`                  |
| Provider function     | `camelCase`, describes the data  | `expensesThisMonth`                  |
| Provider class        | `PascalCase`, `Notifier` suffix  | `AddExpenseController`               |
| Drift table           | `PascalCase` plural              | `Expenses`, `Categories`             |
| Drift row (generated) | singular                         | `Expense`, `Category`                |
| DAO                   | `<Entity>Dao`                    | `ExpenseDao`                         |
| Repository            | `<Feature>Repository`            | `ExpenseRepository`                  |
| Screen                | `<Name>Screen`                   | `ExpenseLogScreen`                   |
| Widget (private)      | prefix `_`                       | `_ExpenseTile`                       |

**Provider names describe data, not action.** `expensesThisMonth`, not `getExpensesThisMonth`. `addExpenseController`, not `expenseAdder`.

## Riverpod patterns

### Read-only computed value

```dart
@riverpod
Future<int> totalSpentThisMonth(TotalSpentThisMonthRef ref) async {
  final expenses = await ref.watch(expensesThisMonthProvider.future);
  return expenses.fold(0, (sum, e) => sum + e.amountPaise);
}
```

### Streaming data from Drift

```dart
@riverpod
Stream<List<Expense>> expensesThisMonth(ExpensesThisMonthRef ref) {
  final repo = ref.watch(expenseRepositoryProvider);
  return repo.watchCurrentMonth();
}
```

### Mutable controller (replaces Cubit)

```dart
@riverpod
class AddExpenseController extends _$AddExpenseController {
  @override
  AddExpenseState build() => const AddExpenseState.initial();

  Future<void> submit() async {
    state = state.copyWith(submitting: true);
    final repo = ref.read(expenseRepositoryProvider);
    await repo.add(state.toExpense());
    state = const AddExpenseState.initial();
  }
}
```

### keepAlive — use sparingly

Only for things that should outlive any single screen: the database, the auth session, app config. Everything else stays auto-dispose.

```dart
@Riverpod(keepAlive: true)
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}
```

## Drift patterns

### Tables

- One table per file in `core/database/tables/`.
- `id` is `IntColumn` with `autoIncrement()`.
- Foreign keys use `references(Table, #id)`.
- Money columns end in `Paise` and are `IntColumn`. Never `RealColumn` for money.
- Dates are `DateTimeColumn`. Drift stores them as ISO strings — no Unix-timestamp hacks.

### DAOs

- One DAO per aggregate (Expense, Category, Budget). Not one per table.
- DAO methods return `Future<T>` for one-shot queries, `Stream<T>` for live data.
- Custom SQL goes in DAOs only, behind a typed method.

### Migrations

- Bump `schemaVersion` for every change.
- Write the migration step. Test it on a real device's data before merging.
- Never edit a past migration. Always add a new one.

## Repository pattern

The repository is a thin layer between providers and DAOs. It exists to:
1. Keep providers free of Drift knowledge.
2. Compose multiple DAOs when needed.
3. Be the swap point if storage ever changes.

```dart
class ExpenseRepository {
  ExpenseRepository(this._dao);
  final ExpenseDao _dao;

  Stream<List<Expense>> watchCurrentMonth() => _dao.watchByDateRange(...);
  Future<void> add(Expense e) => _dao.insert(e);
}
```

Provided as auto-dispose:

```dart
@riverpod
ExpenseRepository expenseRepository(ExpenseRepositoryRef ref) {
  return ExpenseRepository(ref.watch(databaseProvider).expenseDao);
}
```

## Money handling

All money is `int paise` in storage and in domain logic.

```dart
// core/utils/money.dart
int rupeesToPaise(double rupees) => (rupees * 100).round();
double paiseToRupees(int paise) => paise / 100;
String formatPaise(int paise) => '₹${(paise / 100).toStringAsFixed(2)}';
```

**Convert at the UI boundary only.** A `TextField` collects rupees → convert to paise before storing. A widget displays paise → format to `₹X.YZ` for display. Everything in between is paise.

## Async UI

Use `AsyncValue.when` for loading/error/data. Don't manually track `isLoading` booleans in widget state.

```dart
final expenses = ref.watch(expensesThisMonthProvider);
return expenses.when(
  data: (list) => ExpenseList(list),
  loading: () => const LoadingView(),
  error: (e, st) => ErrorView(error: e),
);
```

## Widget rules

- `ConsumerWidget` by default. `ConsumerStatefulWidget` only when you need a `TextEditingController`, `ScrollController`, or animation controller.
- No business logic in widgets. If a widget has more than `ref.watch` + layout, the logic belongs in a provider.
- Widgets that take more than 5 params get a settings/config object or get split.
- `const` everywhere it compiles.

## Testing

- Mirror source path: `lib/features/expenses/data/expense_repository.dart` → `test/features/expenses/data/expense_repository_test.dart`.
- Repository tests use an in-memory Drift database (`NativeDatabase.memory()`).
- Provider tests use `ProviderContainer` with overrides. No widget tree.
- Widget tests only for non-trivial widget logic. Don't test pure layout.

## Comments

- Comments explain **why**, not **what**.
- Public API on shared/core stuff gets dartdoc (`///`).
- Feature-internal code is mostly comment-free if names are good.
- `TODO` comments require a name and a date: `// TODO( 2026-07): switch to typed enum once Drift supports X`.

## Forbidden

- `print` — use `ref.read(loggerProvider).d('message')` from `core/services/logger_service.dart`.
- `dynamic` outside of explicit deserialization boundaries.
- `late` for values that could legitimately be null. Use `?` instead.
- `as` casts where a typed API exists.
- `setState` inside a `ConsumerWidget`'s callback when you could update a provider.
- `BuildContext` after `await` without `if (!context.mounted) return;`.
- Storing provider values in `StatefulWidget` state.
- Manual `Provider`/`StateNotifierProvider` declarations — codegen only.

## Reading colors in widgets:

- Brand color (FABs, primary buttons, active states): Theme.of(context).colorScheme.primary
- Design system tokens (labels, separators, system backgrounds, semantic colors): context.colors.label, context.colors.separator, context.colors.greenReturns, etc.
- Never use Colors.red, Colors.black, etc. directly. Always go through AppColors, AppThemeColors, or colorScheme.
- Never hard-code hex values in widget code.

