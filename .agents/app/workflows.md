# Task recipes

Recipes for common tasks. Follow these step-by-step. If a recipe doesn't exist for your task, write one after you finish.

---

## Add a new feature

1. Create the folder: `lib/features/<feature>/{data,providers,view}/`.
2. If API/Backend changes are needed:
   - Add the necessary endpoint definitions to `core/network/endpoints.dart`.
   - Update `ApiClient` or `Data Sources` to make the HTTP requests.
   - Define your Freezed data model in `features/<feature>/data/models/`.
3. Create the repository in `features/<feature>/data/`. Wraps the data source.
4. Create a repository provider in the same `data/` file or a sibling.
5. Build providers in `features/<feature>/providers/`. Start with the read providers; controllers come last.
6. Build the screen in `features/<feature>/view/`. Wire it into `core/router/app_router.dart`.
7. Run codegen (`build_runner`).
8. Add `.agents/features/<feature>.md` from the template.
9. `flutter analyze`. Format. Test.

## Add a new screen to an existing feature

1. Create `features/<f>/view/<name>_screen.dart`.
2. Add the route to `core/router/app_router.dart`.
3. Reuse existing providers if possible. Add new ones in `features/<f>/providers/` if needed.
4. Update the feature's `.agents/features/<f>.md` — add the screen to Surface area.
5. Codegen, analyze, format.

## Add a field to an existing API model

1. Edit the Freezed model file in `features/<feature>/data/models/`.
2. Add the new field to the factory constructor. Update the `fromJson` logic automatically via `build_runner`.
3. Run codegen.
4. Update Data Sources if the query parameters or request body changes.
5. Update repositories and providers as needed.
6. **Manually test the network layer:** execute the API request and verify nothing breaks on the UI.

## Add a new shared widget

1. Confirm it's used by **at least two features today**. If not, keep it inside the feature.
2. If app-wide infrastructure (button, empty state) → `core/widgets/`.
3. If feature-domain (CategoryChip) → `shared/widgets/`.
4. Add dartdoc explaining intended use.

## Add a dependency

1. **Stop.** Ask the user first. Confirm the dependency is needed.
2. Check pub.dev: maintenance status, last update, popularity, null-safety, license.
3. Prefer first-party / well-known maintainers (Flutter team, Invertase, Felangel, Simon Binder).
4. Add to `pubspec.yaml`. Pin to a major version range, not `any`.
5. Document why in `.agents/dependencies.md` (create if missing).

## Refactor a provider

1. Confirm the change is non-breaking for consumers. Search usages.
2. If breaking, update consumers in the same PR/commit.
3. Codegen.
4. Verify tests still pass.

## Debug a "widget doesn't rebuild" issue

Walk this checklist before guessing:

1. Is the provider being read with `ref.watch` (not `ref.read`)?
2. Is the widget a `ConsumerWidget`/`ConsumerStatefulWidget` (not plain `StatelessWidget`)?
3. If the data is from an API, is the provider successfully emitting the new state after the asynchronous request finishes?
4. Is the provider auto-disposing between screens unexpectedly? Add `keepAlive` only if truly needed.
5. Is the new state actually different from the old state (equality)? `Notifier` only notifies on inequality.

## Before opening a PR (or marking task done)

- [ ] `flutter analyze` clean.
- [ ] `dart format .` on touched files.
- [ ] Codegen run, generated files committed.
- [ ] Tests added/updated.
- [ ] `.agents/` docs updated if patterns changed or new feature added.
- [ ] Manually tested the happy path on at least one platform.
- [ ] Summary written: what changed, what to verify, any known limitations.
