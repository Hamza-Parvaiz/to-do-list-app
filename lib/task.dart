import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
// import 'edit_task.dart' as editTask; // Keeping the alias
import 'package:firebase_messaging/firebase_messaging.dart';
// Keeping the alias

class Task {
  final String name;
  final DateTime date;
  final String category;

  Task({required this.name, required this.date, required this.category});
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
    _configureFCM();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Configure Firebase Cloud Messaging
  void _configureFCM() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');

      // Listen to foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Received a message in the foreground!');
        if (message.notification != null) {
          // Show a dialog or local notification
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(message.notification!.title ?? 'Notification'),
              content: Text(message.notification!.body ?? ''),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Fetch tasks from API (For demonstration, using a local API)
  Future<void> _fetchTasks() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      setState(() {
        _tasks = data
            .map((task) => Task(
                  name: task['title'],
                  date: DateTime.now()
                      .add(Duration(days: task['id'] % 30)), // Random date
                  category: _assignCategory(task['id']),
                ))
            .toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  // Assign category based on task ID for demonstration
  String _assignCategory(int id) {
    if (id % 4 == 0) return 'Gym';
    if (id % 4 == 1) return 'Business Ideas';
    if (id % 4 == 2) return 'Coding Practice';
    return 'Music Classes';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          tabs: const [
            Tab(icon: Icon(Icons.list), text: "All"),
            Tab(icon: Icon(Icons.done), text: "Completed"),
            Tab(icon: Icon(Icons.pending), text: "Pending"),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(),
                _buildTaskList(filterCompleted: true),
                _buildTaskList(filterCompleted: false),
              ],
            ),
    );
  }

  Widget _buildTaskList({bool? filterCompleted}) {
    List<Task> filteredTasks = _tasks;
    if (filterCompleted != null) {
      filteredTasks = _tasks.where((task) {
        bool isCompleted = task.date.isBefore(DateTime.now());
        return filterCompleted ? isCompleted : !isCompleted;
      }).toList();
    }

    return ListView.builder(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) {
        Task task = filteredTasks[index];
        return ListTile(
          title: Text(task.name),
          subtitle: Text(DateFormat('yyyy-MM-dd').format(task.date)),
          trailing: Text(task.category),
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: EditTaskScreen(_tasks[0])));
          },
        );
      },
    );
  }
}
