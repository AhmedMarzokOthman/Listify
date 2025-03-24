import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:listify/models/todo.dart';

class TodoServices {
  static const String _todosKey = 'todos';

  static Future<void> init() async {
    await SharedPreferences.getInstance();
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTodos =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(_todosKey, encodedTodos);
  }

  static Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  static Future<List<Todo>> getTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTodos = prefs.getStringList(_todosKey) ?? [];
    return encodedTodos
        .map((encodedTodo) => Todo.fromJson(jsonDecode(encodedTodo)))
        .toList();
  }

  static Future<void> updateTodo(String id, Todo todo) async {
    final todos = await getTodos();
    final index = todos.indexWhere((item) => item.id == id);
    if (index != -1) {
      todos[index] = todo;
      await saveTodos(todos);
    }
  }

  static Future<void> clearCompletedTodos() async {
    final todos = await getTodos();
    final activeTodos = todos.where((todo) => !todo.isCompleted).toList();
    await saveTodos(activeTodos);
  }

  static Future<void> updateTodoStatus(String id) async {
    final todos = await getTodos();
    final index = todos.indexWhere((item) => item.id == id);
    if (index != -1) {
      todos[index].isCompleted = !todos[index].isCompleted;
      await saveTodos(todos);
    }
  }

  static Future<void> deleteTodo(String id) async {
    final todos = await getTodos();
    todos.removeWhere((todo) => todo.id == id);
    await saveTodos(todos);
  }

  static Future<List<Todo>> getScheduledTodos() async {
    final todos = await getTodos();
    return todos.where((todo) => !todo.isCompleted).toList();
  }

  static Future<List<Todo>> getCompletedTodos() async {
    final todos = await getTodos();
    return todos.where((todo) => todo.isCompleted).toList();
  }
}
