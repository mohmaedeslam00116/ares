import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime? dueDate;

  @HiveField(6)
  String priority; // low, medium, high

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
  }) {
    if (title.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
    if (!['low', 'medium', 'high'].contains(priority)) {
      throw ArgumentError('Priority must be low, medium, or high');
    }
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
    bool clearDueDate = false,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.title == title &&
        other.description == description &&
        other.isCompleted == isCompleted &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate &&
        other.priority == priority;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      description,
      isCompleted,
      createdAt,
      dueDate,
      priority,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, '
        'isCompleted: $isCompleted, createdAt: $createdAt, '
        'dueDate: $dueDate, priority: $priority)';
  }
}
