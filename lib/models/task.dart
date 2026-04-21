import 'package:hive/hive.dart';

part 'task.g.dart';

// Recurrence types
enum RecurrenceType {
  none,
  daily,
  weekly,
  monthly,
  yearly,
}

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

  @HiveField(7)
  String? category; // work, personal, health, shopping, study, finance, home, other

  @HiveField(8)
  List<String> tags; // e.g., ['important', 'urgent', 'meeting']

  @HiveField(9)
  int recurrenceType; // 0=none, 1=daily, 2=weekly, 3=monthly, 4=yearly

  @HiveField(10)
  DateTime? lastCompletedAt;

  @HiveField(11)
  bool reminderEnabled;

  @HiveField(12)
  int reminderMinutesBefore; // minutes before due date

  Task({
    required this.id,
    required this.title,
    this.description = '',
    this.isCompleted = false,
    required this.createdAt,
    this.dueDate,
    this.priority = 'medium',
    this.category,
    this.tags = const [],
    this.recurrenceType = 0,
    this.lastCompletedAt,
    this.reminderEnabled = true,
    this.reminderMinutesBefore = 30,
  }) {
    if (title.isEmpty) {
      throw ArgumentError('Title cannot be empty');
    }
  }

  // Getters for recurrence
  RecurrenceType get recurrence {
    return RecurrenceType.values[recurrenceType];
  }

  bool get isRecurring => recurrenceType > 0;
  bool get hasReminder => dueDate != null && reminderEnabled;

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
    int? recurrenceType,
    DateTime? lastCompletedAt,
    bool? reminderEnabled,
    int? reminderMinutesBefore,
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
      tags: tags ?? this.tags,
      recurrenceType: recurrenceType ?? this.recurrenceType,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderMinutesBefore: reminderMinutesBefore ?? this.reminderMinutesBefore,
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
        other.category == category &&
        _listEquals(other.tags, tags) &&
        other.recurrenceType == recurrenceType &&
        other.reminderEnabled == reminderEnabled &&
        other.reminderMinutesBefore == reminderMinutesBefore;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      id, title, description, isCompleted, createdAt, dueDate,
      priority, category, tags, recurrenceType, reminderEnabled,
      reminderMinutesBefore,
    );
  }
}
