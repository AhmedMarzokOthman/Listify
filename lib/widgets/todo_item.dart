import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/model/todo.dart';
import 'package:intl/intl.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onToDoChange;
  final Function(String) onDeleteItem;
  final Function(String, String)
      onUpdateItem; // Make sure this accepts two parameters

  const TodoItem({
    super.key,
    required this.todo,
    required this.onToDoChange,
    required this.onDeleteItem,
    required this.onUpdateItem,
  });

  String _formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('h:mm a - d MMM');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
          onTap: () {
            onToDoChange(todo);
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          tileColor: Colors.white,
          leading: Icon(
            todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
            color: tdBlue,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                todo.todoText,
                style: TextStyle(
                    fontSize: 16,
                    color: tdBlack,
                    decoration:
                        todo.isDone ? TextDecoration.lineThrough : null),
              ),
              Text(
                _formatDate(todo.createdAt),
                style: const TextStyle(
                  fontSize: 12,
                  color: tdGrey,
                ),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(0),
                margin:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: tdRed,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 18,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDeleteItem(todo.todoId);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: tdBlue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 18,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onUpdateItem(todo.todoId, todo.todoText);
                  },
                ),
              ),
            ],
          )),
    );
  }
}