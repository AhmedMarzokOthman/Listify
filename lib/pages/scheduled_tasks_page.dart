import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/utils/app_routes.dart';
import 'package:listify/widgets/bottom_nav_bar.dart';
import 'package:listify/models/todo.dart';
import 'package:listify/services/todo_service.dart';
import 'package:listify/widgets/search_box.dart';
import 'package:listify/widgets/todo_item.dart';
import 'package:listify/widgets/update_todo_dialog.dart';

class ScheduledTasksPage extends StatefulWidget {
  const ScheduledTasksPage({super.key});

  @override
  State<ScheduledTasksPage> createState() => _ScheduledTasksPageState();
}

class _ScheduledTasksPageState extends State<ScheduledTasksPage> {
  late Future<List<Todo>> _todosFuture;
  String _searchQuery = '';
  final int _currentIndex = 1; // This is the Scheduled tab

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    _todosFuture = TodoServices.getScheduledTodos();
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
        // Already on ScheduledTasksPage
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.completedTasks);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: tdBGColor,
        title: const Text('Scheduled Tasks'),
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
                  return const Center(child: Text('No scheduled tasks'));
                } else {
                  // Filter todos based on search and scheduled status
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

                  // Sort by priority: High -> Medium -> Low
                  filteredTodos.sort((a, b) {
                    const priorityOrder = {'High': 0, 'Medium': 1, 'Low': 2};
                    final priorityComparison = priorityOrder[a.priority]!
                        .compareTo(priorityOrder[b.priority]!);
                    if (priorityComparison == 0) {
                      return b.dateTime.compareTo(a.dateTime);
                    }
                    return priorityComparison;
                  });

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
