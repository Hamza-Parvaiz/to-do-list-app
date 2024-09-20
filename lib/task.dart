import 'package:flutter/material.dart';

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

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Remove the red bar (set background to white)
        title: const Text(
          'All Tasks',
          style: TextStyle(
            fontSize: 33,
            fontWeight: FontWeight.bold,
            color: Colors.red, // Red color for 'All Tasks' text
            shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)], // Brown shadow
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.red, // Keep indicator red to match the theme
          tabs: const [
            Tab(
              icon: Icon(Icons.event, color: Colors.red, shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)]), // Red icon with brown shadow
              child: Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.red, // Red text in tabs
                  shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)], // Brown shadow
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.calendar_today, color: Colors.red, shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)]), // Red icon with brown shadow
              child: Text(
                'TOMORROW',
                style: TextStyle(
                  color: Colors.red, // Red text in tabs
                  shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)], // Brown shadow
                ),
              ),
            ),
            Tab(
              icon: Icon(Icons.calendar_view_day, color: Colors.red, shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)]), // Red icon with brown shadow
              child: Text(
                'UPCOMING',
                style: TextStyle(
                  color: Colors.red, // Red text in tabs
                  shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)], // Brown shadow
                ),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PlaceholderWidget(text: 'Today’s Tasks'),
          PlaceholderWidget(text: 'Tomorrow’s Tasks'),
          PlaceholderWidget(text: 'Upcoming Tasks'),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String text;
  const PlaceholderWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.red, // Red color for placeholder text
            shadows: [Shadow(offset: Offset(2, 2), color: Colors.brown, blurRadius: 5)], // Brown shadow
          ),
        ),
      ),
    );
  }
}
