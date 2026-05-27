# Clean Architecture Flutter Todo App with BLoC

A Flutter Todo application built following **Clean Architecture** principles with **BLoC** pattern for state management. This project demonstrates a scalable, testable, and maintainable approach to Flutter development.

## Architecture Overview

```
lib/
├── core/
│   ├── di/              # Dependency Injection (GetIt)
│   ├── error/           # Failure classes
│   ├── router/          # GoRouter configuration
│   └── usecases/        # Base UseCase abstract class
└── features/
    └── todo/
        ├── data/
        │   ├── datasources/    # Drift (SQLite) local database
        │   ├── models/         # Data models & mappers
        │   └── repositories/   # Repository implementations
        ├── domain/
        │   ├── entities/       # Business entities
        │   ├── repositories/   # Repository contracts (abstract)
        │   └── usecases/       # Business logic use cases
        └── presentation/
            ├── bloc/           # BLoC (Events, States, Bloc)
            ├── pages/          # UI Screens
            └── widgets/        # Reusable widgets
```

## Features

- Create, read, update, and delete todos
- Mark todos as complete/incomplete
- Todo detail view with editing
- Local SQLite persistence using Drift
- Material 3 design with theming

## Tech Stack

| Category | Library |
|----------|---------|
| State Management | `flutter_bloc` |
| Dependency Injection | `get_it` |
| Routing | `go_router` |
| Local Database | `drift` + `sqlite3_flutter_libs` |
| Functional Programming | `dartz` (Either type for error handling) |
| Equality | `equatable` |
| Code Generation | `build_runner`, `drift_dev`, `injectable_generator` |
| Testing | `bloc_test`, `mocktail` |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0

### Installation

```bash
# Clone the repository
git clone https://github.com/rameshsambuflutter/CleanArchitectureFlutterappbloc.git
cd CleanArchitectureFlutterappbloc

# Install dependencies
flutter pub get

# Run code generation (Drift database)
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## Clean Architecture Layers

### Domain Layer (Innermost)
- **Entities**: Pure Dart classes representing business objects (`TodoEntity`)
- **Repositories**: Abstract contracts defining data operations
- **Use Cases**: Single-responsibility business logic (`GetTodos`, `AddTodo`, `UpdateTodo`, `DeleteTodo`)

### Data Layer
- **Models**: Data transfer objects with mapping logic between Drift and domain entities
- **Datasources**: Drift database implementation for local SQLite storage
- **Repository Implementations**: Concrete implementations that fulfill domain contracts

### Presentation Layer (Outermost)
- **BLoC**: Manages UI state with events and states pattern
- **Pages**: Flutter widgets for Todo list and detail views
- **Widgets**: Reusable UI components (e.g., Add Todo dialog)

## State Management Flow

```
UI Event → BLoC → UseCase → Repository → Datasource
                                              ↓
UI ← State ← BLoC ← Either<Failure, Data> ←──┘
```

Error handling uses the `Either` type from `dartz` to propagate failures without exceptions.

## Project Highlights

- Separation of concerns across layers
- Dependency inversion via abstract repository contracts
- Testable architecture with mocked dependencies
- Type-safe database with Drift code generation
- Declarative routing with GoRouter
- Immutable state management with BLoC + Equatable

## License

This project is open source and available under the [MIT License](LICENSE).
