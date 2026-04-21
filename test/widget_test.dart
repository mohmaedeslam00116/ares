import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:hermes/models/task.dart';
import 'package:hermes/providers/task_provider.dart';
import 'package:hermes/widgets/task_card.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskAdapter());
    Hive.registerAdapter(TaskPriorityAdapter());
    Hive.registerAdapter(CategoryAdapter());
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('TaskCard displays task title', (tester) async {
    await Hive.openBox<Task>('tasks');
    await Hive.openBox('settings');

    final task = Task(
      id: '1',
      title: 'Test Task Title',
      description: 'Test Description',
      createdAt: DateTime.now(),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ChangeNotifierProvider(
            create: (_) => TaskProvider(),
            child: Builder(
              builder: (ctx) => TaskCard(task: task),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Test Task Title'), findsOneWidget);
  });
}
