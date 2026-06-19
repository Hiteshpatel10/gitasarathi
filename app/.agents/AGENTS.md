# GitaSarathi — Agent Guide

**Read this file at the start of every task. It is the source of truth.**

You are working on GitaSarathi, a Spiritual/Gita Flutter app. Solo developer (Raviraj). Stack: **Flutter + Riverpod (codegen) + Backend API (Dio) + Firebase**. Target platforms: Android + iOS.

---

## Before you write any code

1. Read this file (`AGENTS.md`).
2. Read `.agents/architecture.md` — the folder structure and dependency rules.
3. Read `.agents/conventions.md` — naming, patterns, do/don't.
4. Read the feature-specific notes in `.agents/features/<feature>.md` if one exists for the area you're touching.
5. If the task is non-trivial, write a plan first and confirm before coding.

If any of these files contradict the user's instructions in the current message, **the user's instructions win** — but flag the contradiction.

---

## The non-negotiable rules

These are the rules that, if broken, cost the most to undo later. Treat them as hard constraints.

1. **Money is stored as `int` in paise.** Never `double`. Never rupees. Convert at the UI boundary only, using helpers in `core/utils/money.dart` (if applicable).
2. **Providers are codegen.** Always use `@riverpod` annotations + `build_runner`. No manual `Provider`/`StateNotifierProvider` declarations.
3. **`ref.watch` in `build`. `ref.read` in callbacks.** Never the other way. Never store a provider's value in a `StatefulWidget` field.
4. **Features do not import from other features.** Cross-feature data flows through `core/` (network, shared repositories) or `shared/`.
5. **`core/` never imports from `features/`.** One-way dependency.
6. **No raw HTTP calls scattered in the code.** Use the centralized Dio API client. Network calls go in Data Sources or Repositories only.
7. **The `ApiClient` is a `keepAlive` provider.** Everything else defaults to auto-dispose.
8. **Generated files (`*.g.dart`, `*.freezed.dart`) are committed.** Do not gitignore them.
9. **No `print`.** Use the logger in `core/utils/logger.dart`.
10. **No `BuildContext` across async gaps without `mounted` checks.**
11. **`flutter analyze`** must be clean before any task is done. The analysis_options.yaml enforces several conventions automatically. If a lint fires, fix the code — do not silence the lint.
If a task seems to require breaking one of these, **stop and ask** instead of breaking it.

---

## Workflow for any task

### Step 1 — Understand
- Restate the task in your own words.
- List the files you expect to read, create, and modify.
- Identify which feature(s) are involved.

### Step 2 — Plan
- For anything beyond a one-line change, write a short plan: what changes, in what order, and why.
- Confirm the plan if the task is ambiguous or touches multiple features.

### Step 3 — Implement
- Follow the folder structure in `.agents/architecture.md`.
- Follow the patterns in `.agents/conventions.md`.
- Run codegen after touching providers or freezed classes: `dart run build_runner build --delete-conflicting-outputs`.

### Step 4 — Verify
- `flutter analyze` — must be clean. No new warnings.
- `dart format .` on touched files.
- If you added logic, add or update a test in `test/` mirroring the source path.
- Manually trace: does the new code follow the dependency rules in rule 4 and 5 above?

### Step 5 — Update the agent docs
- If you introduced a new pattern, add it to `.agents/conventions.md`.
- If you added a feature, create `.agents/features/<feature>.md` with a one-page summary.
- If you discovered a gotcha, add it to `.agents/gotchas.md`.

**Updating these docs is part of the task, not optional.** Future-you (and future agents) need it.

---

## Commit discipline

- One logical change per commit.
- Message format: `<scope>: <imperative summary>` (e.g., `auth: add google sign in`).
- Commit generated files in the same commit as their source.
- Never commit commented-out code, `TODO` without a name, or debug prints.

---

## When you are unsure

Do not guess. Ask. Specifically ask when:

- The task touches money math, currency formatting, or date-range logic.
- A new dependency would be added to `pubspec.yaml`.
- A schema or API endpoint migration is needed.
- A pattern in this repo doesn't match what you'd "normally" do — the repo wins; confirm before deviating.

---

## What "done" looks like

A task is done when:
- [ ] Code matches conventions in `.agents/conventions.md`.
- [ ] `flutter analyze` is clean.
- [ ] Codegen is run, generated files committed.
- [ ] Tests added or updated for new logic.
- [ ] `.agents/` docs updated if patterns changed.
- [ ] You wrote a short summary of what changed and what to verify manually.
