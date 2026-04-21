import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import 'notification_provider.dart';

enum TaskFilter { all, pending, completed }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  String? _categoryFilter;
  String? _tagFilter;
  final StorageService _storage = StorageService();
  final NotificationService _notifications = NotificationService();
  final Uuid _uuid = const Uuid();

  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;
  String? get tagFilter => _tagFilter;

  List<Task> get tasks {
    var filtered = _tasks;
    if (_filter == TaskFilter.pending) {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (_filter == TaskFilter.completed) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) {
      filtered = filtered.where((t) => t.category == _categoryFilter).toList();
    }
    if (_tagFilter != null && _tagFilter!.isNotEmpty) {
      filtered = filtered.where((t) => t.tags.contains(_tagFilter)).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }
    return filtered;
  }

  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  List<String> get categories {
    final cats = _tasks
        .where((t) => t.category != null && t.category!.isNotEmpty)
        .map((t) => t.category!)
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  List<String> get allTags {
    final tags = <String>{};
    for (final task in _tasks) {
      tags.addAll(task.tags);
    }
    return tags.toList()..sort();
  }

  Future<void> init() async {
    await _storage.init();
    await _notifications.init();
  }

  Future<void> loadTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _tasks = await _storage.getTasks();
    } catch (e) {
      _error = 'Failed to load tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addTask({
    required String title,
    required String description,
    DateTime? dueDate,
    String priority = 'medium',
    String? category,
    List<String> tags = const [],
    int recurrenceType = 0,
    bool reminderEnabled = true,
    int reminderMinutesBefore = 30,
  }) async {
    if (title.trim().isEmpty) {
      _error = 'Title cannot be empty';
      notifyListeners();
      return false;
    }
    try {
      final task = Task(
        id: _uuid.v4(),
        title: title.trim(),
        description: description.trim(),
        createdAt: DateTime.now(),
        dueDate: dueDate,
        priority: priority,
        category: category,
        tags: tags,
        recurrenceType: recurrenceType,
        reminderEnabled: reminderEnabled,
        reminderMinutesBefore: reminderMinutesBefore,
      );
      final success = await _storage.addTask(task);
      if (success) {
        _tasks.insert(0, task);
        // Schedule notification if due date is set
        if (dueDate != null && reminderEnabled) {
          await _notifications.scheduleTaskReminder(
            task: task,
            minutesBefore: reminderMinutesBefore,
          );
        }
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to add task: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> toggleTask(String id) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index == -1) return false;
      final task = _tasks[index];
      final wasCompleted = task.isCompleted;
      task.isCompleted = !task.isCompleted;

      // Handle recurring tasks
      if (task.isCompleted && task.isRecurring) {
        task.lastCompletedAt = DateTime.now();
        // Create next occurrence
        await _createNextRecurrence(task);
      }

      final success = await _storage.updateTask(task);
      if (success) {
        // Cancel old reminder
        await _notifications.cancelTaskReminder(id);
        // Schedule new reminder if needed
        if (!task.isCompleted && task.dueDate != null && task.reminderEnabled) {
          await _notifications.scheduleTaskReminder(
            task: task,
            minutesBefore: task.reminderMinutesBefore,
          );
        }
        notifyListeners();
      } else {
        task.isCompleted = wasCompleted;
      }
      return success;
    } catch (e) {
      _error = 'Failed to toggle task: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> _createNextRecurrence(Task task) async {
    if (task.dueDate == null) return;

    DateTime nextDueDate;
    switch (task.recurrence) {
      case RecurrenceType.daily:
        nextDueDate = task.dueDate!.add(const Duration(days: 1));
        break;
      case RecurrenceType.weekly:
        nextDueDate = task.dueDate!.add(const Duration(days: 7));
        break;
      case RecurrenceType.monthly:
        nextDueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month + 1,
          task.dueDate!.day,
        );
        break;
      case RecurrenceType.yearly:
        nextDueDate = DateTime(
          task.dueDate!.year + 1,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        break;
      default:
        return;
    }

    final newTask = Task(
      id: _uuid.v4(),
      title: task.title,
      description: task.description,
      createdAt: DateTime.now(),
      dueDate: nextDueDate,
      priority: task.priority,
      category: task.category,
      tags: task.tags,
      recurrenceType: task.recurrenceType,
      reminderEnabled: task.reminderEnabled,
      reminderMinutesBefore: task.reminderMinutesBefore,
    );

    await _storage.addTask(newTask);
    _tasks.insert(0, newTask);

    // Schedule notification for new task
    if (newTask.reminderEnabled) {
      await _notifications.scheduleTaskReminder(
        task: newTask,
        minutesBefore: newTask.reminderMinutesBefore,
      );
    }
  }

  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
    DateTime? dueDate,
    String priority = 'medium',
    String? category,
    List<String> tags = const [],
    int recurrenceType = 0,
    bool reminderEnabled = true,
    int reminderMinutesBefore = 30,
  }) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index == -1) return false;
      final task = _tasks[index];
      task.title = title.trim();
      task.description = description.trim();
      task.dueDate = dueDate;
      task.priority = priority;
      task.category = category;
      task.tags = tags;
      task.recurrenceType = recurrenceType;
      task.reminderEnabled = reminderEnabled;
      task.reminderMinutesBefore = reminderMinutesBefore;

      final success = await _storage.updateTask(task);

      // Update notification
      await _notifications.cancelTaskReminder(id);
      if (success && dueDate != null && reminderEnabled) {
        await _notifications.scheduleTaskReminder(
          task: task,
          minutesBefore: reminderMinutesBefore,
        );
      }

      notifyListeners();
      return success;
    } catch (e) {
      _error = 'Failed to update task: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      await _notifications.cancelTaskReminder(id);
      final success = await _storage.deleteTask(id);
      if (success) {
        _tasks.removeWhere((t) => t.id == id);
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = 'Failed to delete task: $e';
      notifyListeners();
      return false;
    }
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
    notifyListeners();
  }

  void setTagFilter(String? tag) {
    _tagFilter = tag;
    notifyListeners();
  }

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
