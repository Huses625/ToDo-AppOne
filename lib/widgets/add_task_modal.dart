import 'package:flutter/material.dart';

class AddTaskModal extends StatefulWidget {
  final Function(String) onAdd;

  const AddTaskModal({super.key, required this.onAdd});

  @override
  State<AddTaskModal> createState() => _AddTaskModalState();
}

class _AddTaskModalState extends State<AddTaskModal> {
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (_controller.text.trim().isNotEmpty) {
      widget.onAdd(_controller.text.trim());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets, // adjusts for keyboard
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add New Task', style: TextStyle(fontSize: 20)),
            TextField(
              controller: _controller,
              autofocus: true,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(hintText: 'Enter task title'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(onPressed: _submit, child: const Text('Add Task')),
          ],
        ),
      ),
    );
  }
}
