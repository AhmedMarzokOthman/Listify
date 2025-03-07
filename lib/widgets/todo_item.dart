import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/model/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChange;
  final onDeleteItem;
  const TodoItem({
    super.key,
    required this.todo,
    required this.onToDoChange,
    required this.onDeleteItem,
  });

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
          color: tdBlue,
        ),
        title: Text(
          todo.todoText!,
          style: TextStyle(
              fontSize: 16,
              color: tdBlack,
              decoration: todo.isDone ? TextDecoration.lineThrough : null),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 12),
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
              onDeleteItem(todo.id);
            },
          ),
        ),
      ),
    );
  }
}
/*
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
                        spreadRadius: 0.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Add new todo item',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              )
            ],
          ),
        ) */
