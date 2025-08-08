---

# 🔐 E-Commerce Authentication Feature

A **secure, production-ready authentication module** integrated with a **real API** for your Flutter e-commerce application.
Implements **Clean Architecture**, **BLoC state management**, and a **beautiful Material 3 UI** for a smooth user experience.

---

## ✨ Features

* 👤 **User Registration** – Sign up with name, email, and password (with validation).
* 🔑 **Login** – Secure login using API authentication.
* 🚪 **Logout** – API-driven logout with token invalidation.
* 🔄 **Auto Login** – Persistent authentication via local token storage.
* 📱 **Responsive UI** – Optimized for mobile and tablet.
* 🎨 **Beautiful Material 3 Design** – Rounded fields, gradients, shadows.
* 🧩 **Clean Architecture** – Separation of **data**, **domain**, and **presentation**.

---

## 📂 Folder Structure

```
📦auth
 ┣ 📂data
 ┃ ┣ 📂datasources
 ┃ ┃ ┣ 📜auth_local_data_source.dart
 ┃ ┃ ┗ 📜auth_remote_data_source.dart
 ┃ ┣ 📂models
 ┃ ┃ ┗ 📜user_model.dart
 ┃ ┗ 📂repositories
 ┃ ┃ ┗ 📜user_repository_impl.dart
 ┣ 📂domain
 ┃ ┣ 📂entities
 ┃ ┃ ┗ 📜user.dart
 ┃ ┣ 📂repositories
 ┃ ┃ ┗ 📜user_repository.dart
 ┃ ┗ 📂usecases
 ┃ ┃ ┣ 📜login.dart
 ┃ ┃ ┣ 📜logout.dart
 ┃ ┃ ┗ 📜sign_up.dart
 ┣ 📂facade
 ┃ ┗ 📜auth_facade.dart
 ┗ 📂presentation
 ┃ ┣ 📂bloc
 ┃ ┃ ┣ 📜auth_bloc.dart
 ┃ ┃ ┣ 📜auth_event.dart
 ┃ ┃ ┗ 📜auth_state.dart
 ┃ ┣ 📂pages
 ┃ ┃ ┣ 📜home_page.dart
 ┃ ┃ ┣ 📜sign_in_page.dart
 ┃ ┃ ┣ 📜sign_up_page.dart
 ┃ ┃ ┗ 📜splash_page.dart
 ┃ ┗ 📂widgets
 ┃ ┃ ┣ 📜auth_button.dart
 ┃ ┃ ┗ 📜auth_text_field.dart
```

---

## 🚀 How It Works

### 1️⃣ Login (`LoginPage`)

* Sends credentials to `/auth/login` endpoint.
* Stores JWT token securely (e.g., `flutter_secure_storage`).
* Navigates to **Home Page** on success.

### 2️⃣ Registration (`RegisterPage`)

* Sends name, email, and password to `/auth/register`.
* Displays server validation errors if any.

### 3️⃣ Logout

* Sends logout request to `/auth/logout`.
* Clears stored token and returns to login screen.

---

## 🔌 API Integration

Example API call (Dio example):

```dart
final response = await dio.post(
  '$baseUrl/auth/login',
  data: {
    'email': email,
    'password': password,
  },
);

if (response.statusCode == 200) {
  final token = response.data['token'];
  await secureStorage.write(key: 'auth_token', value: token);
}
```

---

## 🧭 Navigation Flow

1. **Splash Screen** checks if token exists →

   * If yes → fetch user profile → go to **Home Page**.
   * If no → go to **Login Page**.
2. Login/Register → Store token → Navigate to **Home Page**.
3. Logout → Clear token → Go to **Login Page**.

---

## 🎨 UI Highlights

* Material 3 design with custom theming.
* Error messages appear below form fields.
* Loading spinners for async API calls.
* Smooth transitions between pages.

---

## 🛡 Security

* **HTTPS** for all API calls.
* Tokens stored securely using `flutter_secure_storage`.
* Automatic logout when token expires.

---

## 📦 Example Run

```bash
flutter run lib/main.dart
```
## Pages 
![Screenshots](https://github.com/SabonaWaktole/2025-A2SV-G6-mobile-assessment/blob/task22/ecom/assets/Screenshot%20from%202025-08-08%2023-08-56.png)
![Screenshots](https://github.com/SabonaWaktole/2025-A2SV-G6-mobile-assessment/blob/task22/ecom/assets/Screenshot%20from%202025-08-08%2023-09-15.png)
![Screenshots](https://github.com/SabonaWaktole/2025-A2SV-G6-mobile-assessment/blob/task22/ecom/assets/Screenshot%20from%202025-08-08%2023-09-24.png)


---

---
