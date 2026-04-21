# FocusForge Architecture

## Overview
FocusForge follows **Clean Architecture** principles to ensure separation of concerns, testability, and maintainability.

## Layers

### 1. Presentation Layer
- **Framework**: Flutter
- **State Management**: Riverpod
- **Widgets**: UI components built with Material 3.
- **Screens**: Composed of widgets, listening to providers for state.

### 2. Domain Layer
- **Models**: Plain Dart objects (e.g., `Task`, `Session`).
- **Repositories (Interfaces)**: Abstract definitions of data operations.
- **Use Cases**: Business logic (e.g., "Start Focus Session").

### 3. Data Layer
- **Repositories (Implementations)**: Concrete implementations using Firebase or Local storage.
- **Data Sources**: Firebase Firestore, SharedPreferences.
- **Services**: External API wrappers (AuthService, NotificationService).

## Design Pattern: MVVM + Repository
- **Model**: Data entities.
- **View**: Flutter screens and widgets.
- **ViewModel (Provider/Notifier)**: Bridge between UI and Domain logic.
- **Repository**: Handles data fetching and persistence.

## Data Flow
User Input → Widget → Riverpod Notifier → Repository → Firebase/Local Storage → UI Update.
