import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/models/todo.dart';
import 'package:listify/widgets/priorty_button.dart';

class UpdateTodoDialog extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onUpdateTodo;

  const UpdateTodoDialog({
    super.key,
    required this.todo,
    required this.onUpdateTodo,
  });

  @override
  State<UpdateTodoDialog> createState() => _UpdateTodoDialogState();
}

class _UpdateTodoDialogState extends State<UpdateTodoDialog> {
  late TextEditingController _titleController;
  late String selectedPriority;
  late DateTime selectedDate;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo.title);
    selectedPriority = widget.todo.priority;
    selectedDate = widget.todo.dateTime;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final updatedTodo = Todo(
        id: widget.todo.id,
        title: _titleController.text.trim(),
        priority: selectedPriority,
        dateTime: selectedDate,
        isCompleted: widget.todo.isCompleted,
      );
      widget.onUpdateTodo(updatedTodo);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Task'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                cursorColor: tdBlue,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter a task title',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: tdBlue, width: 2.0),
                  ),
                  labelStyle: TextStyle(color: tdGrey),
                  floatingLabelStyle: TextStyle(color: tdBlue),
                  focusColor: tdBlue,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text('Priority:'),
              const SizedBox(height: 8),
              Row(
                children: [
                  PriorityButton(
                    priority: 'Low',
                    color: tdLowPriority,
                    selectedPriority: selectedPriority,
                    onPrioritySelected: (value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  PriorityButton(
                    priority: 'Medium',
                    color: tdMediumPriority,
                    selectedPriority: selectedPriority,
                    onPrioritySelected: (value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  PriorityButton(
                    priority: 'High',
                    color: tdHighPriority,
                    selectedPriority: selectedPriority,
                    onPrioritySelected: (value) {
                      setState(() {
                        selectedPriority = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: tdBlue,
            foregroundColor: Colors.white,
          ),
          child: const Text('Update Task'),
        ),
      ],
    );
  }
}
