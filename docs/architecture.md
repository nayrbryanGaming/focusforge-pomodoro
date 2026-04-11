# FocusForge Architecture Documentation

## Architecture Pattern: Clean Architecture

FocusForge implements Clean Architecture principles with MVVM in the presentation layer.

### System Layers

1.  **Presentation Layer** (Flutter + Riverpod)
    *   **Views (Screens/Widgets)**: Declarative UI using Material 3. Dumb components that react to state changes.
    *   **State Notifiers (ViewModels)**: Riverpod `Notifier` and `AsyncNotifier` classes holding state logic.

2.  **Domain Layer** (Dart pure)
    *   **Entities**: Immutable data models representing core business logic (`Task`, `Session`, `UserStat`).
    *   **Repositories (Abstract)**: Interfaces defining contracts for data access.

3.  **Data Layer**
    *   **Repositories (Implementation)**: Concrete classes implementing domain interfaces.
    *   **Data Sources**: Firebase APIs (Remote) and Local Storage (SharedPreferences/Hive).

## State Management Concept

We strictly use `riverpod` for dependency injection and state management.
*   `providers.dart` exposes all decoupled data singletons.
*   `ConsumerWidget` is used exclusively for reactivity.

## Directory Structure Strategy
```
lib/
  core/           # Shared logic (themes, errors, utilities)
  features/       # Feature-driven boundaries (timer, tasks)
  models/         # Domain entities
  providers/      # Global Riverpod dependencies
```
