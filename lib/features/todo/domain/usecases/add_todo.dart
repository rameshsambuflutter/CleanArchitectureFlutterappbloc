import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class AddTodo extends UseCase<TodoEntity, TodoEntity> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<Either<Failure, TodoEntity>> call(TodoEntity params) {
    return repository.addTodo(params);
  }
}
