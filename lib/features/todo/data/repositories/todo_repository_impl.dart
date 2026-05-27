import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDatasource localDatasource;

  TodoRepositoryImpl({required this.localDatasource});

  @override
  Future<Either<Failure, List<TodoEntity>>> getTodos() async {
    try {
      final items = await localDatasource.getAllTodos();
      final todos = items.map(TodoModel.fromDrift).toList();
      return Right(todos);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> addTodo(TodoEntity todo) async {
    try {
      final companion = TodoModel.toCompanion(todo);
      await localDatasource.insertTodo(companion);
      return Right(todo);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TodoEntity>> updateTodo(TodoEntity todo) async {
    try {
      final companion = TodoModel.toCompanion(todo);
      await localDatasource.updateTodo(companion);
      return Right(todo);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTodo(String id) async {
    try {
      await localDatasource.deleteTodoById(id);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
