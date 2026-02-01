## Flutter Task Manager App

This project is a simple Flutter application demonstrating:

- Mock login flow with session persistence
- Task list CRUD (Create, Edit, Delete)
- Offline-first local storage
- Clean layered + feature-based architecture
- Proper state management using BLoC

---

This project was developed and tested using **Flutter 3.27.4**.

---

# Features Implemented

## Authentication Flow

- Login screen with:
    - Email + Password input
    - Validation (email format, password length)
    - Loading indicator during login


- Session persistence:
    - User stays logged in after app restart
- Logout support:
    - Clears session and returns to login screen

---

## Task Management (CRUD)

- Home screen displays task list
- Empty state shown when no tasks exist
- Add new tasks via Floating Action Button
- Edit existing tasks by tapping on them
- Delete task with confirmation dialog
- Task fields include:
    - Title (required)
    - Description (optional)
    - Status (Pending / Completed)

---

## Offline Persistence

- Tasks remain saved even after app restart
- Login session remains stored until logout
- All CRUD operations update storage correctly

---

# Architecture & Project Structure

This project follows a **feature-based + layered architecture**:

```text
lib/
 └─ features/
     └─ threads/
         ├─ data/
         │   ├─ models/
         │   └─ repository/
         ├─ presentation/
         │   ├─ bloc/
         │   ├─ screens/
         │   └─ widgets/
         └─ utils/
```

This separation ensures:

- Clean responsibilities
- Easy scaling
- Testable business logic
- No direct UI ↔ storage coupling

---

# State Management Choice

## Why flutter_bloc (BLoC)?

This project uses **flutter_bloc** because:

- Provides predictable and structured state handling
- Separates UI from business logic
- Makes CRUD flows clean and testable
- Ideal for apps requiring multiple independent states
    - Auth/session state
    - Task list state

Example flow:
UI → Event → Bloc → Repository → Storage → State → UI Update


---

# Persistence Choice

## Why SharedPreferences?

SharedPreferences was chosen because:

- Lightweight and simple for small datasets
- Suitable for:
    - Login session flag
    - Basic offline task list storage
- Quick to implement for assignment-level persistence

Tasks are stored as JSON strings locally.

---

# Assumptions & Trade-offs

### Assumptions

- Authentication is mocked (no backend integration)
- Task list is stored locally only (single-device)

### Trade-offs

- SharedPreferences is not ideal for very large datasets
    - Hive or SQLite would be better for production
- No remote sync included (offline-only design)

---
