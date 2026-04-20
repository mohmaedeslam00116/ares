import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

enum TaskFilter { all, pending, completed }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  TaskFilter _filter = TaskFilter.all;
  String _searchQuery = '';
  final StorageService _storage = StorageService();
  final Uuid _uuid = const Uuid();

  // Getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  TaskFilter get filter => _filter;
  String get searchQuery => _searchQuery;
  
  List<Task> get tasks {
    var filtered = _tasks;
    if (_filter == TaskFilter.pending) {
      filtered = filtered.where((t) => !t.isCompleted).toList();
    } else if (_filter == TaskFilter.completed) {
      filtered = filtered.where((t) => t.isCompleted).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((t) =>
        t.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        t.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }
    return filtered;
  }

  int get pendingCount => _tasks.where((t) => !t.isCompleted).length;
  int get completedCount => _tasks.where((t) => t.isCompleted).length;

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
  }) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index == -1) return false;
      final task = _tasks[index];
      final oldCompleted = task.isCompleted;
      task.title = title.trim();
      task.description = description.trim();
      task.dueDate = dueDate;
      task.priority = priority;
      final success = await _storage.updateTask(task);
      if (!success) {
        task.title = _tasks[index].title;
        task.description = _tasks[index].description;
        task.dueDate = _tasks[index].dueDate;
        task.priority = _tasks[index].priority;
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

  void setSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
