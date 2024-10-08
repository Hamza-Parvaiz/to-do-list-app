import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Wishlist(),
    );
  }
}

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<Task> tasks = [];

  void _navigateToAddTaskScreen(String category) async {
    final Task? newTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(category: category),
      ),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.redAccent,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Center(
                child: Text(
                  'WISHLIST',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildClickableIcon(Icons.sports_gymnastics, 'Gym'),
                    _buildClickableIcon(Icons.business_outlined, 'Business Ideas'),
                    _buildClickableIcon(Icons.code_outlined, 'Coding Practice'),
                    _buildClickableIcon(Icons.music_note, 'Music Classes'),
                    _buildClickableIcon(Icons.travel_explore, 'Travel Plans'),
                    _buildClickableIcon(Icons.book, 'Reading Books'),
                    _buildClickableIcon(Icons.kitchen, 'Cooking Recipes'),
                    _buildClickableIcon(Icons.palette, 'Art & Painting'),
                  ],
                ),
              ),
              _buildStyledButton(
                'View Tasks',
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskTabsScreen(tasks: tasks),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClickableIcon(IconData icon, String label) {
    return GestureDetector(
      onTap: () => _navigateToAddTaskScreen(label),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.redAccent, size: 50), 
              const SizedBox(width: 20),
              Text(
                label,
                style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyledButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shadowColor: Colors.brown,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}

class AddTaskScreen extends StatefulWidget {
  final String category;

  const AddTaskScreen({super.key, required this.category});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task for ${widget.category}'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                ),
                const SizedBox(width: 16),
                _buildStyledButton('Choose Date', _pickDate),
              ],
            ),
            const SizedBox(height: 32),
            _buildStyledButton('Add Task', _submitTask),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitTask() {
    if (_taskController.text.isEmpty || _selectedDate == null) {
      return;
    }

    Task newTask = Task(
      name: _taskController.text,
      date: _selectedDate!,
      category: widget.category,
    );

    Navigator.pop(context, newTask);
  }

  Widget _buildStyledButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shadowColor: Colors.brown,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class TaskTabsScreen extends StatefulWidget {
  final List<Task> tasks;

  const TaskTabsScreen({super.key, required this.tasks});

  @override
  State<TaskTabsScreen> createState() => _TaskTabsScreenState();
}

class _TaskTabsScreenState extends State<TaskTabsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Task> todayTasks = widget.tasks.where((task) => isSameDate(task.date, DateTime.now())).toList();
    List<Task> tomorrowTasks = widget.tasks.where((task) => isSameDate(task.date, DateTime.now().add(const Duration(days: 1)))).toList();
    List<Task> upcomingTasks = widget.tasks.where((task) => task.date.isAfter(DateTime.now().add(const Duration(days: 1)))).toList();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Tasks'),
          backgroundColor: Colors.red,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.event), text: 'Today'),
              Tab(icon: Icon(Icons.calendar_today), text: 'Tomorrow'),
              Tab(icon: Icon(Icons.calendar_view_day), text: 'Upcoming'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TaskListView(tasks: todayTasks, onDeleteTask: _onDeleteTask, onEditTask: _onEditTask),
            TaskListView(tasks: tomorrowTasks, onDeleteTask: _onDeleteTask, onEditTask: _onEditTask),
            TaskListView(tasks: upcomingTasks, onDeleteTask: _onDeleteTask, onEditTask: _onEditTask),
          ],
        ),
      ),
    );
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  void _onDeleteTask(Task task) {
    setState(() {
      widget.tasks.remove(task);
    });
  }

  void _onEditTask(Task task) async {
    final Task? editedTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(task: task),
      ),
    );

    if (editedTask != null) {
      setState(() {
        int index = widget.tasks.indexOf(task);
        widget.tasks[index] = editedTask;
      });
    }
  }
}

class TaskListView extends StatelessWidget {
  final List<Task> tasks;
  final Function(Task) onDeleteTask;
  final Function(Task) onEditTask;

  const TaskListView({super.key, required this.tasks, required this.onDeleteTask, required this.onEditTask});

  @override
  Widget build(BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text('No tasks available'),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        Task task = tasks[index];
        return ListTile(
          title: Text(task.name),
          subtitle: Text(DateFormat.yMMMd().format(task.date)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.red),
                onPressed: () => onEditTask(task),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDeleteTask(task),
              ),
            ],
          ),
        );
      },
    );
  }
}

class Task {
  final String name;
  final DateTime date;
  final String category;

  Task({required this.name, required this.date, required this.category});
}

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _taskController.text = widget.task.name;
    _selectedDate = widget.task.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(labelText: 'Task Name'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  _selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Selected Date: ${DateFormat.yMMMd().format(_selectedDate!)}',
                ),
                const SizedBox(width: 16),
                _buildStyledButton('Choose Date', _pickDate),
              ],
            ),
            const SizedBox(height: 32),
            _buildStyledButton('Update Task', _submitTask),
          ],
        ),
      ),
    );
  }

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _submitTask() {
    if (_taskController.text.isEmpty || _selectedDate == null) {
      return;
    }

    Task editedTask = Task(
      name: _taskController.text,
      date: _selectedDate!,
      category: widget.task.category,
    );

    Navigator.pop(context, editedTask);
  }

  Widget _buildStyledButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shadowColor: Colors.brown,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
