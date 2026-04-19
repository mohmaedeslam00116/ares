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

  test('deleteTask removes task from list', () async {
    // Manually add to provider for testing
    taskProvider.addTask('Task to delete', 'Description');
    String id = taskProvider.tasks.first.id;
    
    when(mockStorageService.deleteTask(id)).thenReturn(null);
    taskProvider.deleteTask(id);
    
    expect(taskProvider.tasks.length, 0);
  });
}
