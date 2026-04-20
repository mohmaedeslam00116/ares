import 'package:flutter_test/flutter_test.dart';
import 'package:ares/providers/task_provider.dart';

void main() {
  group('TaskProvider', () {
    test('initial state has empty tasks', () {
      final provider = TaskProvider();
      expect(provider.tasks, isEmpty);
    });

    test('addTask adds task to list', () async {
      final provider = TaskProvider();
      await provider.addTask(title: 'Test Task', description: 'Test Description');
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.title, 'Test Task');
    });

    test('deleteTask removes task from list', () async {
      final provider = TaskProvider();
      await provider.addTask(title: 'Test Task', description: 'Test Description');
      final id = provider.tasks.first.id;
      await provider.deleteTask(id);
      expect(provider.tasks, isEmpty);
    });

    test('toggleTask flips completion status', () async {
      final provider = TaskProvider();
      await provider.addTask(title: 'Test Task', description: 'Test Description');
      final id = provider.tasks.first.id;
      expect(provider.tasks.first.isCompleted, false);
      await provider.toggleTask(id);
      expect(provider.tasks.first.isCompleted, true);
    });
  });
}