import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/repositories/todo_repository.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodos usecase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    usecase = GetTodos(mockRepository);
  });

  final tTodos = [
    TodoEntity(
      id: '1',
      title: 'Test Todo',
      description: 'Test Description',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  test('should get list of todos from the repository', () async {
    // arrange
    when(
      () => mockRepository.getTodos(),
    ).thenAnswer((_) async => Right(tTodos));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, Right(tTodos));
    verify(() => mockRepository.getTodos());
    verifyNoMoreInteractions(mockRepository);
  });

  test('should return failure when repository fails', () async {
    // arrange
    when(
      () => mockRepository.getTodos(),
    ).thenAnswer((_) async => const Left(DatabaseFailure()));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Left(DatabaseFailure()));
  });
}
