import 'package:flutter/material.dart';
import 'add_task.dart' as add_task; // Using alias for AddTaskScreen
import 'task_tabs.dart' as task_tabs; // Using alias for TaskTabsScreen
import 'task.dart' as task_model; // Using alias for Task class
import 'package:firebase_auth/firebase_auth.dart';
import 'login.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});

  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  List<task_model.Task> tasks = []; // Use the alias for Task

  void _navigateToAddTaskScreen(String category) async {
    final task_model.Task? newTask = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => add_task.AddTaskScreen(category: category), // Use the alias
      ),
    );

    if (newTask != null) {
      setState(() {
        tasks.add(newTask);
      });
    }
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
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
                      builder: (context) => task_tabs.TaskTabsScreen(tasks: tasks), // Use the alias
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
