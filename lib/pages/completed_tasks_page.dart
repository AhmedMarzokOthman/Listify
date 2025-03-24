import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/utils/app_routes.dart';
import 'package:listify/widgets/bottom_nav_bar.dart';
import 'package:listify/models/todo.dart';
import 'package:listify/services/todo_service.dart';
import 'package:listify/widgets/search_box.dart';
import 'package:listify/widgets/todo_item.dart';
import 'package:listify/widgets/update_todo_dialog.dart';

class CompletedTasksPage extends StatefulWidget {
  const CompletedTasksPage({super.key});

  @override
  State<CompletedTasksPage> createState() => _CompletedTasksPageState();
}

class _CompletedTasksPageState extends State<CompletedTasksPage> {
  late Future<List<Todo>> _todosFuture;
  String _searchQuery = '';
  final int _currentIndex = 2; // This is the Completed tab

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    _todosFuture = TodoServices.getCompletedTodos();
    setState(() {});
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  void _onNavTap(int index) {
    if (_currentIndex == index) return;

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, AppRoutes.home);
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.scheduledTasks);
        break;
      case 2:
        // Already on CompletedTasksPage
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: const Text('Completed Tasks'),
        actions: [
          // Add a clear all button
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Clear Completed Tasks'),
                      content: const Text(
                        'Are you sure you want to remove all completed tasks?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            TodoServices.clearCompletedTodos().then((_) {
                              _loadTodos();
                              Navigator.pop(context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Clear All'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      backgroundColor: tdBGColor,
      body: Column(
        children: [
          SearchBox(onToDoChange: _handleSearch),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: _todosFuture,
              builder: (context, todoss) {
                if (todoss.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (todoss.hasError) {
                  return Center(child: Text('Error: ${todoss.error}'));
                } else if (!todoss.hasData || todoss.data!.isEmpty) {
                  return const Center(child: Text('No completed tasks'));
                } else {
                  // Filter todos based on search and completed status
                  final todos = todoss.data!;
                  final filteredTodos =
                      _searchQuery.isEmpty
                          ? todos
                          : todos
                              .where(
                                (todo) => todo.title.toLowerCase().contains(
                                  _searchQuery,
                                ),
                              )
                              .toList();

                  if (filteredTodos.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 50,
                            color: tdGrey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No matching tasks found',
                            style: TextStyle(fontSize: 16, color: tdGrey),
                          ),
                        ],
                      ),
                    );
                  }

                  // Sort by date (newest first)
                  filteredTodos.sort(
                    (a, b) => b.dateTime.compareTo(a.dateTime),
                  );

                  return ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      return TodoItem(
                        todo: filteredTodos[index],
                        onTodoChanged: (todo) {
                          TodoServices.updateTodoStatus(todo.id).then((_) {
                            _loadTodos();
                          });
                        },
                        onDeleteItem: (id) {
                          TodoServices.deleteTodo(id).then((_) {
                            _loadTodos();
                          });
                        },
                        onEditItem: (todo) {
                          showDialog(
                            context: context,
                            builder:
                                (context) => UpdateTodoDialog(
                                  todo: todo,
                                  onUpdateTodo: (updatedTodo) {
                                    TodoServices.updateTodo(
                                      updatedTodo.id,
                                      updatedTodo,
                                    ).then((_) {
                                      _loadTodos();
                                    });
                                  },
                                ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
