
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ARES Task Manager')),
      body: Consumer<TaskProvider>(
        builder: (context, provider, _) => AnimatedList(
          key: _listKey,
          initialItemCount: provider.tasks.length,
          itemBuilder: (context, index, animation) => SlideTransition(
            position: animation.drive(Tween(begin: const Offset(1, 0), end: Offset.zero)),
            child: TaskCard(task: provider.tasks[index]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
