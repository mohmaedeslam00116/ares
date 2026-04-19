import 'package:hive/hive.dart';
import '../models/task.dart';

class StorageService {
  List<Task> getTasks() => Hive.box<Task>('tasks').values.toList();
  void addTask(Task task) => Hive.box<Task>('tasks').add(task);
}