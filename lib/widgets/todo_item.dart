import 'package:flutter/material.dart';
import 'package:listify/constants/colors.dart';
import 'package:listify/models/todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Function(Todo) onTodoChanged;
  final Function(String) onDeleteItem;
  final Function(Todo) onEditItem;

  const TodoItem({
    super.key,
    required this.todo,
    required this.onTodoChanged,
    required this.onDeleteItem,
    required this.onEditItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Dismissible(
        key: Key(todo.id),
        // Delete background (end to start)
        background: Container(
          decoration: BoxDecoration(
            color: tdBlue.withAlpha(200),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.edit, color: Colors.white, size: 32),
        ),
        // Delete background (right to left)
        secondaryBackground: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_sweep, color: Colors.white, size: 32),
        ),
        // Enable both directions
        direction: DismissDirection.horizontal,
        // Handle both directions
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            // Swipe left to delete
            return true; // Confirm deletion
          } else if (direction == DismissDirection.startToEnd) {
            // Swipe right to edit
            onEditItem(todo);
            return false; // Don't dismiss the item
          }
          return false;
        },
        onDismissed: (direction) {
          // This will only trigger for endToStart (delete) due to confirmDismiss
          onDeleteItem(todo.id);
        },
        child: InkWell(
          onTap: () => onTodoChanged(todo),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha(40),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Priority color strip
                    Container(
                      width: 10,
                      color: priorityColors[todo.priority] ?? tdBlue,
                    ),
                    // Main content
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            // Status indicator/checkbox
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    todo.isCompleted
                                        ? tdBlue.withAlpha(20)
                                        : Colors.transparent,
                                border: Border.all(
                                  color:
                                      todo.isCompleted ? tdLowPriority : tdGrey,
                                  width: 2,
                                ),
                              ),
                              child:
                                  todo.isCompleted
                                      ? Icon(
                                        Icons.check,
                                        color: tdLowPriority,
                                        size: 16,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 16),
                            // Title and details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    todo.title,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          todo.isCompleted ? tdGrey : tdBlack,
                                      decoration:
                                          todo.isCompleted
                                              ? TextDecoration.lineThrough
                                              : null,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: priorityColors[todo.priority]
                                              ?.withAlpha(15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          todo.priority,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                priorityColors[todo.priority] ??
                                                tdBlue,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.calendar_today,
                                        size: 12,
                                        color: tdGrey,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${todo.dateTime.day}/${todo.dateTime.month}/${todo.dateTime.year} - ${todo.dateTime.hour}:${todo.dateTime.minute}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: tdGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Actions
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit icon
                                IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: tdBlue.withAlpha(200),
                                  ),
                                  splashRadius: 24,
                                  onPressed: () => onEditItem(todo),
                                ),
                                // Delete icon
                                IconButton(
                                  icon: Icon(
                                    Icons.delete_outline,
                                    color: tdRed.withAlpha(200),
                                  ),
                                  splashRadius: 24,
                                  onPressed: () => onDeleteItem(todo.id),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
