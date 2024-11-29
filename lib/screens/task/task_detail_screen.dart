import 'package:bdcalling_it/models/task_model.dart';
import 'package:flutter/material.dart';

class TaskDetailsScreen extends StatelessWidget {
  final TaskModel task;
   const TaskDetailsScreen({
    required this.task,
    super.key,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${task.title}'),
            const SizedBox(height: 8),
            Text('Description: ${task.description}'),
            const SizedBox(height: 8),
            Text('ID: ${task.id}'),
            const SizedBox(height: 8),
            Text('Created At: ${task.createdAt}'),
            const SizedBox(height: 8),
            Text('Updated At: ${task.updatedAt}'),
          ],
        ),
      ),
    );
  }
}
