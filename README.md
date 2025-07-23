# MGL Smart Wash Service

A Flutter mobile application for smart wash services.

## Features

- User authentication
- Clean architecture implementation
- GraphQL integration
- Shared preferences for local storage
- BLoC pattern for state management

## Getting Started

1. Clone the repository
2. Run `flutter pub get`
3. Configure your GraphQL endpoint in `lib/core/constants/app_constants.dart`
4. Run the app using `flutter run`

## Architecture

This project follows clean architecture principles with the following layers:

- Presentation Layer (UI, BLoCs)
- Domain Layer (Entities, Repositories, Use Cases)
- Data Layer (Models, Repository Implementations, Data Sources)

## Dependencies

- flutter_bloc: State management
- graphql_flutter: GraphQL client
- get_it: Dependency injection
- shared_preferences: Local storage
- equatable: Value equality
- dartz: Functional programming
![Login Screen](screenshot/login.png)
![Opt Screen](screenshot/opt.png)
![Splash Screen](screenshot/splash.png)
![Home Screen](screenshot/home.png)
![Home Screen](screenshot/wash.png)