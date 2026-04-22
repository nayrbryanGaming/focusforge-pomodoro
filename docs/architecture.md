# FocusForge Architecture

## Overview
FocusForge is built using **Clean Architecture** principles to ensure maintainability, testability, and scalability. The codebase is organized into layers that separate concerns and prevent tight coupling.

## Layers

### 1. Presentation Layer
- **Widgets**: UI components using Flutter Material 3.
- **Screens**: Full page layouts.
- **Providers**: State management using **Riverpod**. We use `NotifierProvider` and `AsyncNotifierProvider` for reactive state.
- **Themes**: Centralized theme definitions in `app_theme.dart`.

### 2. Domain Layer (Models)
- **Entities/Models**: Plain Dart objects representing the business data (e.g., `TaskModel`, `StatsModel`).
- **Repositories (Interfaces)**: Abstract definitions of data operations.

### 3. Data Layer
- **Services**: Concrete implementations of data fetching and business logic.
  - `AuthService`: Firebase Authentication.
  - `TaskService`: Cloud Firestore interactions for tasks.
  - `StatsService`: Firestore aggregator for productivity metrics.
  - `NotificationService`: Local notifications using `flutter_local_notifications`.
- **Firebase**: Integration with Firestore, Analytics, and Crashlytics.

## State Flow
1. **User Interaction**: User taps a button on a Screen.
2. **Action**: The UI calls a method on a Riverpod Provider.
3. **Logic**: The Provider interacts with a Service (e.g., `TaskService`).
4. **Data**: The Service performs an async operation with Firebase.
5. **Reaction**: The Provider updates its state, and Riverpod automatically rebuilds the dependent UI components.

## Technical Decisions
- **Riverpod**: Chosen for its compile-time safety and provider-based dependency injection.
- **Firebase**: Provides a scalable, serverless backend that integrates perfectly with Flutter.
- **Material 3**: Modern design language for a "premium" look and feel.
- **Glassmorphism**: Used in the UI for a sophisticated, high-end aesthetic.
