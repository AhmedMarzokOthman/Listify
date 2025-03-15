import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/model/todo.dart';

class TodoController {
  // ValueNotifier to notify UI of changes
  final ValueNotifier<List<Todo>> todosNotifier = ValueNotifier<List<Todo>>([]);

  // Add a field to track the current search keyword
  String _currentSearchKeyword = '';

  // Constructor
  TodoController() {
    loadTodos();
  }

  // UI helper for AppBar
  static AppBar buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: tdBGColor,
      title: SizedBox(
        height: 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('assets/imgs/logo.png'),
        ),
      ),
    );
  }

  // Load all todos from Hive
  Future<void> loadTodos() async {
    final box = Hive.box<Todo>('todo_database');
    List<Todo> allTodos = box.values.toList();

    // Apply the current search filter if there is one
    if (_currentSearchKeyword.isEmpty) {
      todosNotifier.value = allTodos;
    } else {
      todosNotifier.value = allTodos
          .where((todo) => todo.todoText
              .toLowerCase()
              .contains(_currentSearchKeyword.toLowerCase()))
          .toList();
    }
  }

  // Add a new todo
  Future<void> addTodo(String todoText) async {
    // Trim the text to remove leading and trailing whitespace
    final trimmedText = todoText.trim();

    // Check if the trimmed text is empty
    if (trimmedText.isEmpty) {
      // Don't add the todo if it's empty or just whitespace
      return;
    }

    final box = Hive.box<Todo>('todo_database');
    final newTodo = Todo(
      todoId: DateTime.now().microsecondsSinceEpoch.toString(),
      todoText: trimmedText, // Use the trimmed text
      createdAt: DateTime.now(),
    );

    await box.add(newTodo);
    await loadTodos();
  }

  // Toggle todo completion status
  Future<void> toggleTodoStatus(Todo todo) async {
    final box = Hive.box<Todo>('todo_database');
    // Find the key for this todo
    final keyToUpdate = box.keys.firstWhere(
      (key) => box.get(key)?.todoId == todo.todoId,
      orElse: () => null,
    );

    if (keyToUpdate != null) {
      todo.isDone = !todo.isDone;
      await box.put(keyToUpdate, todo);
      await loadTodos();
    }
  }

  // Delete a todo
  Future<void> deleteTodo(String id) async {
    final box = Hive.box<Todo>('todo_database');
    // Find the key for the todo with this id
    final keyToDelete = box.keys.firstWhere(
      (key) => box.get(key)?.todoId == id,
      orElse: () => null,
    );

    if (keyToDelete != null) {
      await box.delete(keyToDelete);
      await loadTodos();
    }
  }

  // Search todos
  void searchTodo(String keyword) {
    _currentSearchKeyword = keyword; // Store the current keyword
    final box = Hive.box<Todo>('todo_database');
    List<Todo> allTodos = box.values.toList();

    if (keyword.isEmpty) {
      todosNotifier.value = allTodos;
    } else {
      todosNotifier.value = allTodos
          .where((todo) =>
              todo.todoText.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }
  }

  // Get title based on todos count
  String getTitle() {
    return todosNotifier.value.isNotEmpty ? "All ToDos" : "Add a ToDo";
  }

  // Dispose resources
  void dispose() {
    todosNotifier.dispose();
  }

  // Update a todo
  Future<void> updateTodo(String id, String newText) async {
    // Trim the text to remove leading and trailing whitespace
    final trimmedText = newText.trim();

    // Check if the trimmed text is empty
    if (trimmedText.isEmpty) {
      return;
    }

    final box = Hive.box<Todo>('todo_database');
    // Find the key for the todo with this id
    final keyToUpdate = box.keys.firstWhere(
      (key) => box.get(key)?.todoId == id,
      orElse: () => null,
    );

    if (keyToUpdate != null) {
      final todo = box.get(keyToUpdate);
      if (todo != null) {
        final updatedTodo = Todo(
          todoId: todo.todoId,
          todoText: trimmedText, // Use the trimmed text
          isDone: todo.isDone,
          createdAt: todo.createdAt,
        );
        await box.put(keyToUpdate, updatedTodo);
        await loadTodos();
      }
    }
  }
}
