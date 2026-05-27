import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'todo_local_datasource.g.dart';

class TodoItems extends Table {
  TextColumn get id => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().withDefault(const Constant(''))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [TodoItems])
class TodoLocalDatasource extends _$TodoLocalDatasource {
  TodoLocalDatasource() : super(_openConnection());

  /// Constructor for testing with in-memory database
  TodoLocalDatasource.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  Future<List<TodoItem>> getAllTodos() => select(todoItems).get();

  Future<int> insertTodo(TodoItemsCompanion entry) =>
      into(todoItems).insert(entry);

  Future<bool> updateTodo(TodoItemsCompanion entry) =>
      update(todoItems).replace(entry);

  Future<int> deleteTodoById(String id) =>
      (delete(todoItems)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todo_db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
