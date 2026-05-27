import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_app/core/error/failures.dart';
import 'package:todo_app/core/usecases/usecase.dart';
import 'package:todo_app/features/todo/domain/entities/todo_entity.dart';
import 'package:todo_app/features/todo/domain/usecases/add_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/delete_todo.dart';
import 'package:todo_app/features/todo/domain/usecases/get_todos.dart';
import 'package:todo_app/features/todo/domain/usecases/update_todo.dart';
import 'package:todo_app/features/todo/presentation/bloc/todo_bloc.dart';

class MockGetTodos extends Mock implements GetTodos {}

class MockAddTodo extends Mock implements AddTodo {}

class MockUpdateTodo extends Mock implements UpdateTodo {}

class MockDeleteTodo extends Mock implements DeleteTodo {}

class FakeTodoEntity extends Fake implements TodoEntity {}

void main() {
  late TodoBloc bloc;
  late MockGetTodos mockGetTodos;
  late MockAddTodo mockAddTodo;
  late MockUpdateTodo mockUpdateTodo;
  late MockDeleteTodo mockDeleteTodo;

  setUpAll(() {
    registerFallbackValue(const NoParams());
    registerFallbackValue(FakeTodoEntity());
    registerFallbackValue('');
  });

  setUp(() {
    mockGetTodos = MockGetTodos();
    mockAddTodo = MockAddTodo();
    mockUpdateTodo = MockUpdateTodo();
    mockDeleteTodo = MockDeleteTodo();
    bloc = TodoBloc(
      getTodos: mockGetTodos,
      addTodo: mockAddTodo,
      updateTodo: mockUpdateTodo,
      deleteTodo: mockDeleteTodo,
    );
  });

  tearDown(() => bloc.close());

  final tTodos = [
    TodoEntity(
      id: '1',
      title: 'Test Todo',
      description: 'Description',
      createdAt: DateTime(2024, 1, 1),
    ),
  ];

  group('LoadTodos', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] when successful',
      build: () {
        when(() => mockGetTodos(any())).thenAnswer((_) async => Right(tTodos));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTodos()),
      expect: () => [const TodoLoading(), TodoLoaded(tTodos)],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoError] when fails',
      build: () {
        when(
          () => mockGetTodos(any()),
        ).thenAnswer((_) async => const Left(DatabaseFailure('DB error')));
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadTodos()),
      expect: () => [const TodoLoading(), const TodoError('DB error')],
    );
  });

  group('DeleteTodoEvent', () {
    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] after successful delete',
      build: () {
        when(
          () => mockDeleteTodo(any()),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockGetTodos(any()),
        ).thenAnswer((_) async => const Right([]));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      expect: () => [const TodoLoading(), const TodoLoaded([])],
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoError] when delete fails',
      build: () {
        when(
          () => mockDeleteTodo(any()),
        ).thenAnswer((_) async => const Left(DatabaseFailure('fail')));
        return bloc;
      },
      act: (bloc) => bloc.add(const DeleteTodoEvent('1')),
      expect: () => [const TodoError('fail')],
    );
  });

  group('ToggleTodoEvent', () {
    final todo = TodoEntity(
      id: '1',
      title: 'Test',
      isCompleted: false,
      createdAt: DateTime(2024, 1, 1),
    );

    blocTest<TodoBloc, TodoState>(
      'emits [TodoLoading, TodoLoaded] after toggling',
      build: () {
        when(
          () => mockUpdateTodo(any()),
        ).thenAnswer((_) async => Right(todo.copyWith(isCompleted: true)));
        when(
          () => mockGetTodos(any()),
        ).thenAnswer((_) async => Right([todo.copyWith(isCompleted: true)]));
        return bloc;
      },
      act: (bloc) => bloc.add(ToggleTodoEvent(todo)),
      expect: () => [
        const TodoLoading(),
        TodoLoaded([todo.copyWith(isCompleted: true)]),
      ],
    );
  });
}
