import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

class UpdateTodo extends UseCase<TodoEntity, TodoEntity> {
  final TodoRepository repository;

  UpdateTodo(this.repository);

  @override
  Future<Either<Failure, TodoEntity>> call(TodoEntity params) {
    return repository.updateTodo(params);
  }
}
