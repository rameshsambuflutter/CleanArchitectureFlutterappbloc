import 'package:drift/drift.dart';

import '../../domain/entities/todo_entity.dart';
import '../datasources/todo_local_datasource.dart';

class TodoModel {
  /// Convert from Drift's generated TodoItem to domain entity
  static TodoEntity fromDrift(TodoItem item) {
    return TodoEntity(
      id: item.id,
      title: item.title,
      description: item.description,
      isCompleted: item.isCompleted,
      createdAt: item.createdAt,
    );
  }

  /// Convert from domain entity to Drift companion for insert/update
  static TodoItemsCompanion toCompanion(TodoEntity entity) {
    return TodoItemsCompanion(
      id: Value(entity.id),
      title: Value(entity.title),
      description: Value(entity.description),
      isCompleted: Value(entity.isCompleted),
      createdAt: Value(entity.createdAt),
    );
  }
}
