import "package:hive/hive.dart";

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  final String todoId;

  @HiveField(1)
  final String todoText;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  DateTime createdAt;

  Todo({
    required this.todoId,
    required this.todoText,
    this.isDone = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
