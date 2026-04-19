
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  const TaskCard({super.key, required this.task});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      onDismissed: (_) {},
      child: Card(
        child: ListTile(title: Text(task.title), subtitle: Text(task.description)),
      ),
    );
  }
}
