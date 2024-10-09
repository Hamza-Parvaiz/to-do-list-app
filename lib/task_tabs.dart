import 'package:flutter/material.dart';
import 'task.dart'; // Ensure this import is correct
// other imports...

class TaskTabsScreen extends StatelessWidget {
  final List<Task> tasks; // This should be correct

  const TaskTabsScreen({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Colors.redAccent,
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            title: Text(task.name),
            subtitle: Text('Category: ${task.category}'),
          );
        },
      ),
    );
  }
}
