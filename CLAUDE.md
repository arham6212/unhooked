CLAUDE.md — Inner Monk
Guidance for Claude / Claude Code when working in this repo. Follow these conventions unless I explicitly say otherwise.
Project
Inner Monk — Flutter wellness & recovery app (recovery/habit tracking, journaling, AI-assisted guidance).

* Frontend: Flutter / Dart
* State: Riverpod (primary, single source of truth)
* Architecture: Clean Architecture, feature-first
* Backend: Supabase (auth, Postgres, storage, RLS)
* AI: Anthropic Claude API
* Offline: Hive (offline-first cache)
* Networking: REST, OAuth 2.0 / JWT
* Stage: MVP — bias toward shipping. Pragmatic over perfect.
How to work here (important)

* Plan first, then edit. Before touching code, post a short plan: files to change, the approach, any decision points. Wait for my OK, then implement.
   * Exception: trivial one-liners / obvious typos — just do them.
* Smallest change that solves the problem. Don't refactor unrelated code.
* Match existing patterns in the file/feature before introducing new ones.
* When done, show the diff or a concise summary of what changed — not a re-explanation of the whole feature.
Communication style

* Lead with the answer or the change. No preamble.
* Bullets over paragraphs. High-signal, direct.
* Flag risks/trade-offs in one line; don't pad.
* If ambiguous, ask one sharp question instead of guessing wide.
Architecture & folders
Feature-first with a shared `core`:

```
lib/
  core/                 # shared across features
    result/             # Result<T> type (see Error handling)
    error/              # AppError / failure types
    network/            # http client, interceptors, auth
    theme/              # colors, typography, theme
    constants/          # app-wide constants, env keys
    utils/              # helpers, extensions
    widgets/            # shared reusable widgets
  features/
    <feature>/
      data/             # datasources, models (DTOs), repository impls
      domain/           # entities, repository interfaces, (use cases optional)
      presentation/     # screens, widgets, Riverpod providers/notifiers
  app/                  # app root, router, global providers, bootstrap
  main.dart

```

Rules:

* A feature owns its data/domain/presentation. Cross-feature sharing goes through `core`, never feature-to-feature imports.
* Dependencies point inward: presentation → domain → data contracts. UI never touches Supabase/HTTP/Hive directly — always through a repository.
* MVP pragmatism: use-case classes are optional. If a call is a thin pass-through, a notifier may call the repository directly. Add use cases only when there's real logic to encapsulate.
State management — Riverpod

* Riverpod is the single source of truth. No global mutable singletons, no `setState` for shared state.
* Prefer `Notifier` / `AsyncNotifier` with manually declared providers. No `riverpod_generator` codegen (consistent with the no-codegen approach below).
* Providers are feature-scoped, declared near the feature they serve.
* Keep UI dumb: widgets read providers and render; logic lives in notifiers/repositories.
* Use `autoDispose` where appropriate to avoid leaks.
Models — plain Dart classes

* No `freezed`, no `json_serializable`, no `build_runner` for models. Hand-write classes.
* Immutable: `final` fields, `const` constructor where possible.
* Write `fromJson` / `toJson` manually.
* Add `copyWith` manually when needed.
* Override `==` and `hashCode` only when value equality is actually required.
* Keep DTOs (data layer) separate from entities (domain) when they diverge; map between them in the repository.
Error handling — custom Result type

* Fallible operations (repositories, datasources, services) return a `Result<T>` — don't throw across layer boundaries for expected failures.
* One canonical `Result` lives in `lib/core/result/`. Use the existing definition — do not create parallel `Result`/`Either`/`Option` types. Canonical shape (Dart 3 sealed):

```dart
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure<T> extends Result<T> {
  final AppError error;
  const Failure(this.error);
}

```

* Consume with exhaustive pattern matching:

```dart
final result = await repo.loadEntries();
switch (result) {
  case Success(:final data):  // use data
  case Failure(:final error): // handle error
}

```

* Convert low-level exceptions (Supabase, network) into `AppError` inside the data layer; surface them as `Failure` upward.
Backend — Supabase

* All Supabase access wrapped in datasources/repositories. No raw calls from UI.
* Row Level Security is ON. Write queries that work under RLS (scope to the authenticated user).
* Auth: OAuth 2.0 / JWT via Supabase; tokens handled centrally in `core/network`.
* Map Supabase/Postgres errors → `AppError` at the data layer.
AI — Claude API

* Centralize Claude calls in a dedicated service (e.g. `core/ai/`). Keep prompts, model name, and config in one place — not scattered inline.
* Responses flow through `Result<T>` like any other I/O.
* Never hardcode the API key (see Secrets).
Offline — Hive

* Hive is the offline-first cache. Repositories decide cache-vs-network (e.g. cache-then-network).
* Keep adapters/boxes in the data layer; don't leak Hive types into domain/presentation.
Secrets & config

* Never commit secrets — no Supabase keys, no Claude API key, no tokens in source.
* Load config via env (`--dart-define` or `flutter_dotenv`). `.env` is gitignored.
* Reference env keys through `core/constants`, not scattered string literals.
Code style

* Effective Dart + the project's `analysis_options.yaml`. Keep `flutter analyze` clean — no new warnings.
* Naming: `snake_case` files, `PascalCase` types, `camelCase` members, `SCREAMING_SNAKE` const env keys.
* Use `const` constructors/widgets aggressively (rebuild perf).
* Extract widgets when a `build` gets long; composition over deep nesting.
* Group imports: dart / flutter / package / project. No dead code or commented-out blocks left behind.
Testing

* MVP mode: do not add tests, test files, or test scaffolding unless I explicitly ask.
* Still write testable code (pure functions, injected dependencies, repositories behind interfaces) so tests drop in later without rework.
Git

* Conventional Commits (assumption — tell me if you prefer otherwise): `feat:`, `fix:`, `refactor:`, `chore:`, `docs:`, `perf:`. Imperative, optional scope — e.g. `feat(journal): add streak counter`.
* One logical change per commit. Don't bundle unrelated edits.
Definition of done (any change)

* [ ] Matches the agreed plan
* [ ] Follows architecture, Result, and model conventions above
* [ ] `flutter analyze` clean, no new warnings
* [ ] No secrets, no stray debug prints
* [ ] UI talks to repositories only (no direct Supabase/HTTP/Hive in widgets)
