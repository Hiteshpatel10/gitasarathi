# Architecture

## Folder structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp, theme, router wiring
│
├── core/                             # Infrastructure. No feature meaning.
│   ├── network/
│   │   ├── api_client.dart           # Dio / Firebase Client wrapper
│   │   ├── endpoints.dart            # API endpoints
│   │   └── interceptors/             # Auth/Logging interceptors
│   ├── providers/
│   │   └── network_provider.dart     # keepAlive ApiClient provider
│   ├── theme/                        # Colors, text styles, ThemeData
│   ├── router/                       # go_router config
│   ├── utils/                        # money.dart, date_extensions.dart, logger.dart
│   └── widgets/                      # Truly app-wide widgets (PrimaryButton, EmptyState)
│
├── features/                         # One folder per feature
│   └── <feature>/
│       ├── data/
│       │   ├── models/               # Freezed data models for this feature
│       │   ├── data_sources/         # Remote/Local data sources (API calls)
│       │   └── <feature>_repository.dart   # Wraps Data Sources, exposes domain API
│       ├── providers/                       # Riverpod providers for this feature
│       └── view/
│           ├── <feature>_screen.dart
│           └── widgets/                     # Widgets used only inside this feature
│
└── shared/                           # Feature-domain code reused by ≥2 features
    ├── models/
    └── widgets/                      # e.g. CategoryChip used in auth+insights
```

## Dependency rules (enforced, not optional)

```
features/A ──► core/           ✅
features/A ──► shared/         ✅
features/A ──► features/B      ❌  NEVER
core/      ──► features/       ❌  NEVER
core/      ──► shared/         ❌  NEVER (core is the foundation)
shared/    ──► core/           ✅
shared/    ──► features/       ❌  NEVER
```

If feature A needs data owned by feature B's domain, both go through `core/network` via repositories, or interact through `shared/` elements. Sibling features do not know about each other.

## Where things live — quick reference

| Thing                                  | Location                                          |
|----------------------------------------|---------------------------------------------------|
| API Client / Dio Setup                 | `core/network/api_client.dart`                    |
| Data Model (Freezed)                   | `features/<f>/data/models/<name>_model.dart`      |
| `ApiClient` provider                   | `core/providers/network_provider.dart`            |
| Feature remote source (API calls)      | `features/<f>/data/data_sources/<name>_remote.dart`|
| Feature repository (wraps Sources)     | `features/<f>/data/<f>_repository.dart`           |
| Feature provider (list, filters, etc.) | `features/<f>/providers/<name>_provider.dart`     |
| Screen                                 | `features/<f>/view/<name>_screen.dart`            |
| Widget used only by feature            | `features/<f>/view/widgets/<name>.dart`           |
| Widget used by ≥2 features             | `shared/widgets/<name>.dart`                      |
| Widget used app-wide (infrastructure)  | `core/widgets/<name>.dart`                        |
| Money helpers, date helpers, logger    | `core/utils/<name>.dart`                          |
| Theme, colors, text styles             | `core/theme/<name>.dart`                          |

## When to promote a widget to `shared/`

- A second feature actually imports it. Not "might someday." Today.
- If only one feature uses it, it stays in that feature's `view/widgets/`.

## When to add a `domain/` folder to a feature

- The UI model differs meaningfully from the API response model (Data Model).
- You have computed/aggregated types that don't map cleanly to a single API endpoint.
- Otherwise, use the Freezed data models directly. Don't pre-abstract.

## Layering inside a feature

```
view  ──watches──►  providers  ──calls──►  repository  ──uses──►  Data Source  ──requests──►  Backend/Firebase
```

- Views never call repositories or Data Sources directly.
- Providers never touch Data Sources or API Clients directly — go through the repository.
- Repositories never know about Riverpod (`ref`, providers). They take plain Dart args.

This keeps the repository unit-testable without any Flutter/Riverpod setup.
