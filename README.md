#  **Task Management App – Flutter**

A lightweight **task management application** built with **Flutter**, supporting **offline-first functionality** with seamless online sync.

---

## Features

* **Create tasks offline**
* **Automatic sync** when the device reconnects
* **Organized task lists** with local caching
* Smooth and responsive UI

---

## Tech Stack

### **Frontend (Flutter)**

* **BLoC Architecture** → predictable state management
* **sqflite** → offline local storage
* **http** → API calling & synchronization 
* **Flutter Widgets + Material UI** for clean UI design

---

## Offline–First Workflow

1. Tasks created offline are saved locally using **sqflite**
2. When the device comes online, pending tasks sync automatically to the backend
3. Data remains consistent across local + server

---

## Folder Structure

```
lib/
 ├─ main.dart
 ├─ core/
    ├─ constants
    ├─ shared_pref_service.dart
 ├─ models/
 ├─ features/
    ├─ auth/
    |  ├─ bloc/
    |  ├─ presentation/
    |  ├─ widgets/
    |  ├─ reposiories/
    ├─ home/
       ├─ bloc/
       ├─ presentation/
       ├─ widgets/
       ├─ reposiories/
 
```

---



## Backend - https://github.com/AtharvSutar05/task-management-backend

### Tech Stack
- **TypeScript (Node.js + Express)**
- **PostgreSQL for scalable and relational data storage**
- **Drizzle ORM + Drizzle-Kit for schema management**


