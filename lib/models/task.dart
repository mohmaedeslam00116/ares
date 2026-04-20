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
  String priority;

  @HiveField(7)
  String? category;

  @HiveField(8)
  List<String> tags;

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
    this.category,
    List<String>? tags,
  }) : tags = tags ?? [] {
    // Lenient validation for title
    if (title.isEmpty) {
      this.title = 'Untitled Task';
    }
    // Validate priority
    if (!['low', 'medium', 'high'].contains(priority)) {
      this.priority = 'medium';
    }
  }

  // Simple setters with validation
  set title(String value) {
    title = value.isEmpty ? 'Untitled Task' : value;
  }

  set priority(String value) {
    priority = ['low', 'medium', 'high'].contains(value) ? value : 'medium';
  }

  set tags(List<String> value) {
    tags = value ?? [];
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
    String? category,
    List<String>? tags,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? List.from(this.tags),
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
        other.priority == priority &&
        other.category == category;
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
      category,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, title: $title, description: $description, '
        'isCompleted: $isCompleted, createdAt: $createdAt, '
        'dueDate: $dueDate, priority: $priority, category: $category, tags: $tags)';
  }
}
