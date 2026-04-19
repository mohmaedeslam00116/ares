import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ares/providers/task_provider.dart';
import 'package:ares/services/storage_service.dart';
import 'package:ares/models/task.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late TaskProvider taskProvider;
  late MockStorageService mockStorageService;

  setUp(() {
    mockStorageService = MockStorageService();
    // Assuming constructor handles loading
    taskProvider = TaskProvider(mockStorageService);
  });

  test('addTask adds task to list', () async {
    when(mockStorageService.addTask(any)).thenAnswer((_) async {});
    await taskProvider.addTask('Test Task', 'Description');
    expect(taskProvider.tasks.length, 1);
    expect(taskProvider.tasks.first.title, 'Test Task');
  });
}
