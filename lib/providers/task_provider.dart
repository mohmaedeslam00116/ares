import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

enum TaskFilter { all, pending, completed, category }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  String? _categoryFilter;
  final StorageService _storage = StorageService();
  final Uuid _uuid = const Uuid();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  String? get categoryFilter => _categoryFilter;

  List<Task> get tasks {
    var filtered = _tasks;

    // Apply category filter first
    if (_categoryFilter != null && _categoryFilter!.isNotEmpty) {
      filtered = filtered.where((t) => t.category == _categoryFilter).toList();
    }

    // Apply status filter
    if (_filter == TaskFilter.pending) {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (_filter == TaskFilter.completed) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()))
      ).toList();
    }

    // Sort by createdAt (newest first) and priority
    filtered.sort((a, b) {
      // Completed tasks go to bottom
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      // Sort by priority (high first)
      final priorityOrder = {'high': 0, 'medium': 1, 'low': 2};
      final priorityCompare = (priorityOrder[a.priority] ?? 1).compareTo(priorityOrder[b.priority] ?? 1);
      if (priorityCompare != 0) return priorityCompare;
      // Then by date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });

    return filtered;
  }

  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

  // Get all unique categories
  List<String> get categories {
    final cats = _tasks
        .where((t) => t.category != null && t.category!.isNotEmpty)
        .map((t) => t.category!)
        .toSet()
        .toList();
    cats.sort();
    return cats;
  }

  // Get all unique tags
  List<String> get allTags {
    final tags = <String>{};
    for (final task in _tasks) {
      tags.addAll(task.tags);
    }
    final list = tags.toList();
    list.sort();
    return list;
  }

  // Stats
  int getCategoryCount(String category) =>
      _tasks.where((t) => t.category == category).length;

  int get highPriorityCount =>
      _tasks.where((t) => t.priority == 'high' && !t.isCompleted).length;

  int get overdueCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _tasks.where((t) =>
        !t.isCompleted &&
        t.dueDate != null &&
        t.dueDate!.isBefore(today)).length;
  }

  // Initialization
  Future<void> init() async {
    await _storage.init();
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

  // CRUD operations
  Future<bool> addTask({
    required String title,
    required String description,
    DateTime? dueDate,
    String priority = 'medium',
    String? category,
    List<String>? tags,
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
        tags: tags ?? [],
      );

      final success = await _storage.addTask(task);
      if (success) {
        _tasks.insert(0, task);
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
      task.isCompleted = !task.isCompleted;
      final success = await _storage.updateTask(task);

      if (success) {
        notifyListeners();
      } else {
        task.isCompleted = !task.isCompleted; // revert
      }
      return success;
    } catch (e) {
      _error = 'Failed to toggle task: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateTask({
    required String id,
    required String title,
    required String description,
    DateTime? dueDate,
    String priority = 'medium',
    String? category,
    List<String>? tags,
    bool clearDueDate = false,
  }) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index == -1) return false;

      final task = _tasks[index];
      task.title = title.trim();
      task.description = description.trim();
      task.dueDate = clearDueDate ? null : dueDate;
      task.priority = priority;
      task.category = category;
      task.tags = tags ?? [];

      final success = await _storage.updateTask(task);
      if (!success) {
        // Revert on failure - reload from storage
        await loadTasks();
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

  // Filters & Search
  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setCategoryFilter(String? category) {
    _categoryFilter = category;
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
