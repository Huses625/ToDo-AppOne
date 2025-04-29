import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'dart:math';

import '../models/task.dart';
import '../services/task_storage.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_modal.dart';
import '../widgets/task_detail_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  final TaskStorage _storage = TaskStorage();

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _loadTasks();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _loadTasks() async {
    _tasks = await _storage.loadTasks();
    setState(() {});
  }

  void _addTask(String title) {
    setState(() {
      _tasks.add(Task(title: title));
    });
    _storage.saveTasks(_tasks);
  }

  void _toggleTask(int index) {
    setState(() {
      final task = _tasks[index];
      task.isDone = !task.isDone;
      task.dateDone = task.isDone ? DateTime.now() : null;

      if (task.isDone) {
        _confettiController.play();
        _showCongrats();
      }
    });
    _storage.saveTasks(_tasks);
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    _storage.saveTasks(_tasks);
  }

  void _showTaskDetail(Task task) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TaskDetailModal(task: task),
    );
  }

  void _showCongrats() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("🎉 Great job! One step at a time!"),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAddTaskModal() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddTaskModal(onAdd: _addTask),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Simple Todo App')),
          body:
              _tasks.isEmpty
                  ? const Center(child: Text('No tasks yet!'))
                  : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return TaskTile(
                        title: task.title,
                        isDone: task.isDone,
                        onToggleDone: () => _toggleTask(index),
                        onDelete: () => _deleteTask(index),
                        onTileTap: () => _showTaskDetail(task),
                      );
                    },
                  ),
          floatingActionButton: FloatingActionButton(
            onPressed: _showAddTaskModal,
            child: const Icon(Icons.add),
          ),
        ),

        // 🎊 Confetti overlays
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2,
            emissionFrequency: 0.08,
            numberOfParticles: 25,
            maxBlastForce: 10,
            minBlastForce: 4,
            gravity: 0.3,
            shouldLoop: false,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: 0,
            emissionFrequency: 0.08,
            numberOfParticles: 20,
            gravity: 0.3,
            shouldLoop: false,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi,
            emissionFrequency: 0.08,
            numberOfParticles: 20,
            gravity: 0.3,
            shouldLoop: false,
          ),
        ),
      ],
    );
  }
}
