import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/models/todo.dart';
import 'package:listify/services/todo_service.dart';
import 'package:listify/widgets/add_todo_dialog.dart';
import 'package:listify/widgets/bottom_nav_bar.dart';
import 'package:listify/widgets/search_box.dart';
import 'package:listify/widgets/todo_item.dart';
import 'package:listify/widgets/update_todo_dialog.dart';
import 'package:listify/utils/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Todo>> _todosFuture;
  String _searchQuery = '';
  int _currentIndex = 0; // Track the current tab index

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() {
    setState(() {
      _todosFuture = TodoServices.getTodos();
    });
  }

  void _handleSearch(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  // Handle navigation between tabs
  void _onNavTap(int index) {
    if (_currentIndex == index)
      return; // Don't navigate if already on the same tab

    setState(() {
      _currentIndex = index;
    });

    // Navigate to the appropriate page
    switch (index) {
      case 0:
        // Already on HomePage
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRoutes.scheduledTasks);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRoutes.completedTasks);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
      backgroundColor: tdBGColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder:
                (context) => AddTodoDialog(
                  onAddTodo: (todo) {
                    TodoServices.addTodo(todo).then((_) {
                      _loadTodos();
                    });
                  },
                ),
          );
        },
        backgroundColor: tdBlue,
        shape: const CircleBorder(),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SearchBox(onToDoChange: _handleSearch),
          Expanded(
            child: FutureBuilder<List<Todo>>(
              future: _todosFuture,
              builder: (context, todoss) {
                if (todoss.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: tdBlue),
                  );
                } else if (todoss.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${todoss.error}',
                      style: TextStyle(color: tdHighPriority),
                    ),
                  );
                } else if (!todoss.hasData || todoss.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/imgs/blueprint.png"),
                        Text('No added tasks yet'),
                      ],
                    ),
                  );
                } else {
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
                            color: tdGrey.withAlpha(100),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No matching tasks found',
                            style: TextStyle(fontSize: 16, color: tdGrey),
                          ),
                        ],
                      ),
                    );
                  }

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

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      toolbarHeight: 100,
      title: SizedBox(width: 150, child: Image.asset('assets/imgs/logo.png')),
    );
  }
}
