import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    return Scaffold(appBar: AppBar(title: const Text('Add Task')), body: Column(children: [TextField(controller: titleController), TextField(controller: descController), ElevatedButton(onPressed: () {
      Provider.of<TaskProvider>(context, listen: false).addTask(titleController.text, descController.text);
      Navigator.pop(context);
    }, child: const Text('Save'))]));
  }
}