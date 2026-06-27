# Inner Monk

Guidance for **Gemini / Antigravity** when working in this repository. Follow these conventions unless I explicitly instruct otherwise.

---

# Project

**Inner Monk** — Flutter wellness & recovery app (recovery/habit tracking, journaling, AI-assisted guidance).

- Frontend: Flutter / Dart
- State: Riverpod (primary, single source of truth)
- Architecture: Clean Architecture, feature-first
- Backend: Supabase (Auth, Postgres, Storage, RLS)
- AI: Anthropic Claude API
- Offline: Hive (offline-first cache)
- Networking: REST, OAuth 2.0 / JWT
- Stage: MVP — prioritize shipping over perfection.

---

# How to Work in This Repository

## Planning

Before making any code changes:

1. Analyze the task.
2. Present a short implementation plan containing:
   - Files to modify
   - Overall approach
   - Any decision points or assumptions
3. Wait for approval before editing code.

**Exception**

- Trivial one-line fixes or obvious typos may be implemented immediately.

---

## Development Principles

- Make the smallest change that solves the problem.
- Avoid unrelated refactoring.
- Follow existing patterns before introducing new ones.
- Match the style and architecture already used in the feature.
- When finished, provide only:
  - concise diff summary
  - files changed
  - important implementation notes

Do not re-explain existing functionality.

---

# Communication Style

- Lead with the answer.
- Prefer bullets over long paragraphs.
- Mention important risks or trade-offs in one line.
- If requirements are ambiguous, ask one focused question instead of guessing.

---

# Architecture

Feature-first architecture with a shared core.

```text
lib/
  core/
    result/
    error/
    network/
    theme/
    constants/
    utils/
    widgets/

  features/
    <feature>/
      data/
      domain/
      presentation/

  app/

  main.dart
```

## Rules

- Each feature owns its own data, domain and presentation layers.
- Never import one feature directly into another.
- Shared functionality belongs in `core`.
- Dependencies point inward:

```
presentation → domain → data contracts
```

- UI never communicates directly with:
  - Supabase
  - Hive
  - HTTP
  - Storage

Repositories are the only gateway.

### Use Cases

Use Cases are optional.

If business logic is only a thin pass-through, Riverpod Notifiers may call repositories directly.

---

# State Management

Riverpod is the only source of truth.

Rules:

- Prefer `Notifier` and `AsyncNotifier`
- No `riverpod_generator`
- No code generation
- Providers remain feature-scoped
- Widgets remain presentation-only
- Business logic belongs inside Notifiers and Repositories
- Use `autoDispose` where appropriate

---

# Models

Use plain Dart classes.

Do **NOT** use:

- freezed
- json_serializable
- build_runner

Requirements:

- immutable models
- final fields
- const constructors whenever possible
- manual `fromJson()`
- manual `toJson()`
- manual `copyWith()`

Override equality only when truly required.

Separate DTOs from Domain Entities whenever appropriate.

---

# Error Handling

Use the shared `Result<T>` implementation located in:

```
lib/core/result
```

Never introduce another:

- Result
- Either
- Option

Expected failures should return:

```dart
Success<T>
Failure<T>
```

Do not throw exceptions across architectural layers.

Convert:

- Supabase exceptions
- Network exceptions
- Database exceptions

into `AppError` inside the data layer.

Consume results using exhaustive pattern matching.

---

# Backend (Supabase)

All Supabase operations must be encapsulated inside repositories and datasources.

Never call Supabase directly from UI.

Requirements:

- Respect Row Level Security (RLS)
- Scope queries to authenticated users
- Centralize authentication
- Convert backend errors into AppError

---

# AI

All AI communication must be centralized.

Recommended location:

```
lib/core/ai/
```

Do not scatter:

- prompts
- model names
- configuration

throughout the project.

Return `Result<T>` like every other external service.

Never hardcode API keys.

---

# Offline

Hive is the offline-first cache.

Repositories determine:

- cache-first
- network-first
- cache-then-network

Hive implementation details remain inside the data layer.

Never expose Hive objects to presentation or domain.

---

# Secrets

Never commit:

- API keys
- Tokens
- Secrets

Configuration must come from:

- `--dart-define`
- `flutter_dotenv`

Expose environment keys through:

```
core/constants
```

Avoid scattered string literals.

---

# Code Style

Follow:

- Effective Dart
- `analysis_options.yaml`

Keep:

```
flutter analyze
```

clean.

Naming:

- snake_case files
- PascalCase types
- camelCase members
- SCREAMING_SNAKE_CASE constants

Prefer:

- const widgets
- composition over giant widgets
- extracted reusable widgets

Group imports:

1. dart
2. flutter
3. package
4. project

Remove:

- dead code
- commented code
- unused imports
- debug prints

---

# Testing

Current project mode:

**MVP**

Do **NOT** create:

- tests
- test scaffolding
- mocks

unless explicitly requested.

Still write code that remains testable through dependency injection and repository abstractions.

---

# Git

Use Conventional Commits.

Examples:

- feat:
- fix:
- refactor:
- docs:
- chore:
- perf:

One logical change per commit.

---

# Definition of Done

- ✅ Matches the approved implementation plan.
- ✅ Follows project architecture.
- ✅ Uses the shared `Result<T>` implementation.
- ✅ `flutter analyze` introduces no new warnings.
- ✅ No secrets committed.
- ✅ No debug prints.
- ✅ UI communicates only through repositories.

---

# Gemini / Antigravity Instructions

When working in this repository:

- Think before coding.
- Respect the existing architecture.
- Make the smallest possible change.
- Never introduce unnecessary abstractions.
- Prefer consistency over cleverness.
- Prioritize readability and maintainability.
- Explain trade-offs briefly when needed.
- If requirements are unclear, ask one precise question before implementing.
- Do not rewrite or refactor unrelated code.
- Preserve existing coding style unless explicitly instructed otherwise.
- Always optimize for shipping a stable MVP.
