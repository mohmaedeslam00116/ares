import 'package:hive/hive.dart';
import '../models/task.dart';

class StorageService {
  List<Task> getTasks() => Hive.box<Task>('tasks').values.toList();
  void addTask(Task task) => Hive.box<Task>('tasks').add(task);
  void deleteTask(String id) {
    final box = Hive.box<Task>('tasks');
    final index = box.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      box.deleteAt(index);
    }
  }
}