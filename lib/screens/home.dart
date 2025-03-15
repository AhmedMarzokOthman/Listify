import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/controller/todo_controller.dart';
import 'package:listify/model/todo.dart';
import 'package:listify/widgets/search_box.dart';
import 'package:listify/widgets/todo_item.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TodoController _todoController = TodoController();
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _todoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: TodoController.buildAppBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                searchBox((value) => _todoController.searchTodo(value)),
                Expanded(
                  child: ValueListenableBuilder<List<Todo>>(
                      valueListenable: _todoController.todosNotifier,
                      builder: (context, todos, _) {
                        return ListView(
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 50, bottom: 20),
                              child: Text(
                                _todoController.getTitle(),
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            for (Todo todo in todos.reversed)
                              TodoItem(
                                todo: todo,
                                onToDoChange: _todoController.toggleTodoStatus,
                                onDeleteItem: _todoController.deleteTodo,
                                onUpdateItem: (String id, String text) {
                                  _showUpdateDialog(id, text);
                                },
                              ),
                            const SizedBox(
                              height: 50,
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    margin: const EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Add new todo item',
                        border: InputBorder.none,
                      ),
                      cursorColor: tdBlue,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    bottom: 15,
                    right: 15,
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      _todoController.addTodo(_textController.text);
                      _textController.clear();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdBlue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(60, 60),
                      shape: const CircleBorder(),
                      elevation: 10,
                    ),
                    child: const Icon(Icons.add),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

// Scale animation

  void _showUpdateDialog(String id, String currentText) {
    final TextEditingController _updateController =
        TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: tdBGColor,
          surfaceTintColor: tdBGColor,
          title: const Text('Update Todo'),
          content: TextField(
            controller: _updateController,
            cursorColor: tdBlue,
            decoration: const InputDecoration(
                hintText: 'Update todo item',
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: tdBlue),
                )),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: tdBlue),
              ),
            ),
            TextButton(
              onPressed: () {
                _todoController.updateTodo(id, _updateController.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Update',
                style: TextStyle(color: tdBlue),
              ),
            ),
          ],
        );
      },
    );
  }
}
