import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;
  final StorageService _storage = StorageService();

  void loadTasks() { _tasks = _storage.getTasks(); notifyListeners(); }
  void addTask(String title, String description) { 
    final newTask = Task(id: DateTime.now().toString(), title: title, description: description, createdAt: DateTime.now());
    _storage.addTask(newTask); _tasks.add(newTask); notifyListeners(); 
  }
}