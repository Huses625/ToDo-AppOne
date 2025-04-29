import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskStorage {
  static const String _taskKey = 'tasks';

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> taskJson =
        tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList(_taskKey, taskJson);
  }

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? taskJson = prefs.getStringList(_taskKey);

    if (taskJson != null) {
      return taskJson
          .map((taskStr) => Task.fromJson(jsonDecode(taskStr)))
          .toList();
    }
    return [];
  }
}
