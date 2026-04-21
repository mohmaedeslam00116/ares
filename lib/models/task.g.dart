// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Task(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      isCompleted: fields[3] as bool,
      createdAt: fields[4] as DateTime,
      dueDate: fields[5] as DateTime?,
      priority: fields[6] as String,
      category: fields[7] as String?,
      tags: (fields[8] as List?)?.cast<String>() ?? [],
      recurrenceType: fields[9] as int? ?? 0,
      lastCompletedAt: fields[10] as DateTime?,
      reminderEnabled: fields[11] as bool? ?? true,
      reminderMinutesBefore: fields[12] as int? ?? 30,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isCompleted)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.dueDate)
      ..writeByte(6)
      ..write(obj.priority)
      ..writeByte(7)
      ..write(obj.category)
      ..writeByte(8)
      ..write(obj.tags)
      ..writeByte(9)
      ..write(obj.recurrenceType)
      ..writeByte(10)
      ..write(obj.lastCompletedAt)
      ..writeByte(11)
      ..write(obj.reminderEnabled)
      ..writeByte(12)
      ..write(obj.reminderMinutesBefore);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
