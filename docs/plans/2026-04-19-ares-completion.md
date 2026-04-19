# ARES Implementation Plan: Task Completion and Polishing

> **For Hermes:** Use subagent-driven-development skill to implement this plan task-by-task.

**Goal:** Complete the core functionality of ARES (Task Manager) and apply basic UI/UX improvements.

**Architecture:** Flutter with Provider and Hive for local storage.

**Tech Stack:** Flutter, Provider, Hive, Google Fonts.

---

### Task 1: Initialize Hive in `main.dart`
**Objective:** Proper initialization for Hive before app runs.

**Files:** `lib/main.dart`

**Step 1: Update main to initialize Hive**
Update `main()`:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');
  runApp(const AresApp());
}
```

**Step 2: Commit**
```bash
git add lib/main.dart
git commit -m "feat: initialize hive in main"
```

### Task 2: Implement Delete Task Logic
**Objective:** Hook up `Dismissible` in `TaskCard`.

**Files:** `lib/widgets/task_card.dart`, `lib/providers/task_provider.dart`

**Step 1: Update `TaskProvider`**
Add:
```dart
void deleteTask(String id) {
  _tasks.removeWhere((t) => t.id == id);
  _storage.deleteTask(id);
  notifyListeners();
}
```

**Step 2: Update `StorageService`**
Add:
```dart
void deleteTask(String id) => Hive.box<Task>('tasks').delete(id);
```

**Step 3: Update `TaskCard`**
Update `onDismissed`:
```dart
onDismissed: (_) => context.read<TaskProvider>().deleteTask(task.id),
```

**Step 4: Commit**
```bash
git add lib/widgets/task_card.dart lib/providers/task_provider.dart lib/services/storage_service.dart
git commit -m "feat: add delete functionality"
```

### Task 3: Apply UI/UX Pro Max Principles
**Objective:** Modern, clean design using `GoogleFonts` and improved `TaskCard`.

**Files:** `lib/theme/app_theme.dart`, `lib/widgets/task_card.dart`

**Step 1: Improve `app_theme.dart`**
Update to use cleaner colors and `GoogleFonts`.

**Step 2: Improve `TaskCard`**
Add better padding, border-radius, and typography.

**Step 3: Commit**
```bash
git add lib/theme/app_theme.dart lib/widgets/task_card.dart
git commit -m "style: apply pro-max design"
```
