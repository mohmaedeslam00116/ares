import 'dart:developer' as developer;
import 'package:hive/hive.dart';
import '../models/task.dart';

class StorageService {
  static const String _boxName = 'tasks';
  Box<Task>? _box;
  bool _isInitialized = false;

  // O(1) lookup index: task id -> task key in Hive box
  final Map<String, dynamic> _taskIndex = {};

  Box<Task> get _taskBox {
    if (_box != null && _box!.isOpen) return _box!;
    // Fallback: try to access globally opened box from main.dart
    return Hive.box<Task>(_boxName);
  }

  /// Initialize the storage service
  Future<bool> init() async {
    if (_isInitialized) return true;

    try {
      _box = await Hive.openBox<Task>(_boxName);
      _rebuildIndex();
      _isInitialized = true;
      developer.log('StorageService initialized successfully', name: 'StorageService');
      return true;
    } catch (e) {
      developer.log(
        'Failed to initialize StorageService: $e',
        name: 'StorageService',
        error: e,
      );
      return false;
    }
  }

  /// Check if storage is initialized
  bool get isInitialized {
    if (_isInitialized && _box != null && _box!.isOpen) return true;
    try {
      // Check if global box is open
      final globalBox = Hive.box<Task>(_boxName);
      return globalBox.isOpen;
    } catch (_) {
      return false;
    }
  }

  /// Rebuild the task index from the Hive box
  void _rebuildIndex() {
    try {
      final box = _taskBox;
      _taskIndex.clear();
      for (final key in box.keys) {
        final task = box.get(key);
        if (task != null) {
          _taskIndex[task.id] = key;
        }
      }
    } catch (e) {
      developer.log('Failed to rebuild index: $e', name: 'StorageService', error: e);
    }
  }

  /// Get all tasks
  /// Returns empty list on error
  List<Task> getTasks() {
    try {
      return _taskBox.values.toList();
    } catch (e) {
      developer.log('Failed to get tasks: $e', name: 'StorageService', error: e);
      return [];
    }
  }

  /// Add a new task
  /// Returns true on success, false on failure
  Future<bool> addTask(Task task) async {
    try {
      final box = _taskBox;
      final key = await box.add(task);
      _taskIndex[task.id] = key;
      developer.log('Task added: ${task.id}', name: 'StorageService');
      return true;
    } catch (e) {
      developer.log('Failed to add task: $e', name: 'StorageService', error: e);
      return false;
    }
  }

  /// Delete a task by id using key-based O(1) lookup
  /// Returns true on success, false on failure
  Future<bool> deleteTask(String id) async {
    try {
      final key = _taskIndex[id];
      if (key == null) return false;
      await _taskBox.delete(key);
      _taskIndex.remove(id);
      developer.log('Task deleted: $id', name: 'StorageService');
      return true;
    } catch (e) {
      developer.log('Failed to delete task: $e', name: 'StorageService', error: e);
      return false;
    }
  }

  /// Update an existing task using HiveObject.save()
  /// Returns true on success, false on failure
  Future<bool> updateTask(Task task) async {
    try {
      await task.save();
      developer.log('Task updated: ${task.id}', name: 'StorageService');
      return true;
    } catch (e) {
      developer.log('Failed to update task: $e', name: 'StorageService', error: e);
      return false;
    }
  }

  /// Get a single task by id
  Task? getTask(String id) {
    try {
      final key = _taskIndex[id];
      if (key == null) return null;
      return _taskBox.get(key);
    } catch (e) {
      developer.log('Failed to get task: $e', name: 'StorageService', error: e);
      return null;
    }
  }

  /// Close the storage box
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
      _isInitialized = false;
    }
  }
}
