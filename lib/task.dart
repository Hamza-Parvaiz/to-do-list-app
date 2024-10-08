import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Add 'as http'

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskScreen(),
    );
  }
}

class Task {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  // Factory method to create a Task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchTasks();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Fetch tasks from API
  Future<void> _fetchTasks() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        _tasks = data.map((task) => Task.fromJson(task)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: Colors.red,
            shadows: [
              Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)
            ],
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red,
          tabs: const [
            Tab(
              icon: Icon(Icons.event, color: Colors.red),
              child: Text('TODAY', style: TextStyle(color: Colors.red)),
            ),
            Tab(
              icon: Icon(Icons.calendar_today, color: Colors.red),
              child: Text('TOMORROW', style: TextStyle(color: Colors.red)),
            ),
            Tab(
              icon: Icon(Icons.calendar_view_day, color: Colors.red),
              child: Text('UPCOMING', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                TaskList(tasks: _tasks),
                const PlaceholderWidget(text: 'Tomorrow’s Tasks'),
                const PlaceholderWidget(text: 'Upcoming Tasks'),
              ],
            ),
    );
  }
}

class TaskList extends StatelessWidget {
  final List<Task> tasks;

  const TaskList({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            tasks[index].title,
            style: const TextStyle(color: Colors.red),
          ),
          trailing: Icon(
            tasks[index].completed ? Icons.check_circle : Icons.circle_outlined,
            color: tasks[index].completed ? Colors.green : Colors.red,
          ),
        );
      },
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;
  const PlaceholderWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 24,
          color: Colors.red,
          shadows: [
            Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)
          ],
        ),
      ),
    );
  }
}
