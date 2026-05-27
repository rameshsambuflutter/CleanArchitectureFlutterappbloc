import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/features/todo/data/datasources/todo_local_datasource.dart';
import 'package:todo_app/features/todo/data/repositories/todo_repository_impl.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';

class MockTodoLocalDatasource extends Mock implements TodoLocalDatasource {}

void main() {
  late TodoRepositoryImpl repository;
  late MockTodoLocalDatasource mockDatasource;

  setUp(() {
    mockDatasource = MockTodoLocalDatasource();
    repository = TodoRepositoryImpl(localDatasource: mockDatasource);
  });

  final tTodoItem = TodoItem(
    id: '1',
    title: 'Test',
    description: 'Desc',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  final tTodoEntity = TodoEntity(
    id: '1',
    title: 'Test',
    description: 'Desc',
    isCompleted: false,
    createdAt: DateTime(2024, 1, 1),
  );

  group('getTodos', () {
    test('should return list of TodoEntity when datasource succeeds', () async {
      // arrange
      when(
        () => mockDatasource.getAllTodos(),
      ).thenAnswer((_) async => [tTodoItem]);

      // act
      final result = await repository.getTodos();

      // assert
      expect(result, Right([tTodoEntity]));
      verify(() => mockDatasource.getAllTodos());
    });

    test('should return DatabaseFailure when datasource throws', () async {
      // arrange
      when(() => mockDatasource.getAllTodos()).thenThrow(Exception('error'));

      // act
      final result = await repository.getTodos();

      // assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<DatabaseFailure>()),
        (_) => fail('should be left'),
      );
    });
  });

  group('deleteTodo', () {
    test('should return Right(null) when delete succeeds', () async {
      // arrange
      when(
        () => mockDatasource.deleteTodoById(any()),
      ).thenAnswer((_) async => 1);

      // act
      final result = await repository.deleteTodo('1');

      // assert
      expect(result, const Right(null));
      verify(() => mockDatasource.deleteTodoById('1'));
    });
  });
}
