
---

# 📂 Project Structure – Flutter Chat & Auth App

This project follows **Clean Architecture** principles with a clear separation between **presentation**, **domain**, and **data** layers, making the codebase scalable, testable, and maintainable.

## 🗂 Directory Layout

```
lib
├── core/                    # Reusable app-wide utilities & constants
│   ├── constants/           # Global styling constants (colors, text styles)
│   ├── error/               # Exception & failure handling
│   ├── helper/              # Misc helper functions
│   ├── network/             # Network status & connectivity checks
│   ├── usecases/            # Base usecase class for domain layer
│   └── utils/               # Token storage, local utility methods
│
├── features/                # App features grouped by domain
│   ├── auth/                 # Authentication (Sign In, Sign Up, Logout)
│   │   ├── data/             # Data layer (API calls, local storage)
│   │   │   ├── datasources/  # Remote & local auth sources
│   │   │   ├── models/       # Auth-specific data models
│   │   │   └── repositories/ # Repository implementations
│   │   ├── domain/           # Business logic layer
│   │   │   ├── entities/     # Core user entities (no Flutter deps)
│   │   │   ├── repositories/ # Abstract contracts
│   │   │   └── usecases/     # Login, signup, logout
│   │   ├── facade/           # Combines usecases for easy UI access
│   │   └── presentation/     # UI layer
│   │       ├── bloc/         # Auth BLoC state management
│   │       ├── pages/        # Auth screens (sign in, sign up, splash, home)
│   │       └── widgets/      # Reusable auth widgets
│
│   ├── chat/                 # Real-time chat feature
│   │   ├── data/             # Data layer (socket & REST)
│   │   │   ├── datasources/  # Chat remote/local data sources
│   │   │   ├── models/       # Chat & message models
│   │   │   └── repositories/ # Repository implementations
│   │   ├── domain/           # Business logic layer
│   │   │   ├── entities/     # Chat & message entities
│   │   │   ├── repositories/ # Abstract contracts
│   │   │   └── usecases/     # Get chats, send/receive messages, etc.
│   │   ├── facade/           # Unified chat operations for UI
│   │   └── presentation/     # UI layer
│   │       ├── bloc/         # Chat & user BLoCs
│   │       ├── pages/        # Chat screens (list, detail)
│   │       └── widgets/      # Chat-specific widgets (bubbles, tiles, inputs)
│
├── injection_container.dart  # Service locator setup (GetIt DI)
└── main.dart                 # App entry point
```

---

## 🏛 Architecture Overview

This app uses:

* **Clean Architecture**: Splits code into independent layers (Data → Domain → Presentation).
* **BLoC (Business Logic Component)**: For predictable, testable state management.
* **Dependency Injection (GetIt)**: Centralized control over app dependencies.
* **Socket.io**: Real-time communication for chat.
* **REST API**: For authentication, user management, and message history.

---

## 🚀 Feature Highlights

* 🔐 **Authentication** – Sign up, log in, log out using secure storage for tokens.
* 💬 **Real-time Chat** – Instant messaging via sockets with acknowledgment handling.
* 📜 **Message History** – Retrieve past conversations from the server.
* 🖌 **Custom Styling** – Centralized theme/colors for a consistent UI.
* 📶 **Network Awareness** – Detects connectivity for better UX.
* ♻ **Reusable Architecture** – Adding new features requires minimal changes to existing code.

---

## 📌 Best Practices Followed

* **SOLID principles** for maintainable code.
* **Separation of concerns** between layers.
* **Stream-based sockets** for real-time updates.
* **Immutable states** for predictable rendering.
* **Centralized error handling** in the `core/error` module.

---
