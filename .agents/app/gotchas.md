# Gotchas

A running log of pitfalls discovered in this codebase. Add new entries as you hit them. Newest at the top.

---

## Format for entries

```
## <Short title>

**Symptom:** what you see.
**Cause:** why it happens.
**Fix:** what to do.
**Date / context:** when this was added, by whom, in what task.
```

---

## Figma label/separator alpha values lost on export

**Symptom:** `secondaryLabel`, `tertiaryLabel`, `quaternaryLabel` look identical on screen; separators are too harsh.  
**Cause:** Source `Default_tokens.json` has `alpha:1` for all of these. iOS HIG expects 60%/30%/18% on labels and 29%/60% on separators (light/dark).  
**Fix:** Patch alpha in `app_colors.dart` after regeneration. Long-term: fix the Figma variables to use the correct alpha, or update the generator script to apply known overrides.

---

## `ref.read` in `build` causes stale UI

**Symptom:** Widget doesn't rebuild when the underlying provider changes.  
**Cause:** `ref.read` does not subscribe. It returns the current value and forgets.  
**Fix:** Use `ref.watch` in `build`. Use `ref.read` only in callbacks (`onPressed`, etc.).

---

## `context` after `await` crashes

**Symptom:** `Looking up a deactivated widget's ancestor is unsafe.`  
**Cause:** Widget was disposed between the `await` and the next `context` use.  
**Fix:** `if (!context.mounted) return;` immediately after every `await` that precedes a `context` use.

---

## `keepAlive: true` leaking state across logical sessions

**Symptom:** Old data persists after a "reset" or logout.  
**Cause:** A `keepAlive` provider is never auto-disposed; it holds state for the app's lifetime.  
**Fix:** Don't use `keepAlive` for session-bound state. For the API client (lifetime = app), it's correct. For anything else, default to auto-dispose and invalidate explicitly: `ref.invalidate(someProvider)`.

---

## Money rounding errors (If applicable)

**Symptom:** Totals are off by 1 paise after a few additions.  
**Cause:** Someone used `double` for money math.  
**Fix:** All money is `int` paise. Convert from rupees with `(rupees * 100).round()`, never `.toInt()`.

---

## Codegen out of sync

**Symptom:** `_$Foo` not found, or generated file has stale provider/model signatures.  
**Cause:** Forgot to run `build_runner` after editing a `@riverpod` or `@freezed` file.  
**Fix:** `dart run build_runner build --delete-conflicting-outputs`. For active dev, use `watch` instead of `build`.