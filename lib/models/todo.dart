class Todo {
  final String id;
  final String title;
  final String priority;
  final DateTime dateTime;
  bool isCompleted;

  Todo({
    required this.id,
    required this.title,
    required this.priority,
    required this.dateTime,
    this.isCompleted = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      priority: json['priority'],
      dateTime: DateTime.parse(json['dateTime']),
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'priority': priority,
      'dateTime': dateTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }
}
