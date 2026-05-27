import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo.dart';
import '../../domain/usecases/delete_todo.dart';
import '../../domain/usecases/get_todos.dart';
import '../../domain/usecases/update_todo.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final GetTodos getTodos;
  final AddTodo addTodo;
  final UpdateTodo updateTodo;
  final DeleteTodo deleteTodo;

  TodoBloc({
    required this.getTodos,
    required this.addTodo,
    required this.updateTodo,
    required this.deleteTodo,
  }) : super(const TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodoEvent>(_onAddTodo);
    on<UpdateTodoEvent>(_onUpdateTodo);
    on<ToggleTodoEvent>(_onToggleTodo);
    on<DeleteTodoEvent>(_onDeleteTodo);
  }

  Future<void> _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) async {
    emit(const TodoLoading());
    final result = await getTodos(const NoParams());
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (todos) => emit(TodoLoaded(todos)),
    );
  }

  Future<void> _onAddTodo(AddTodoEvent event, Emitter<TodoState> emit) async {
    final todo = TodoEntity(
      id: const Uuid().v4(),
      title: event.title,
      description: event.description,
      createdAt: DateTime.now(),
    );
    final result = await addTodo(todo);
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => add(const LoadTodos()),
    );
  }

  Future<void> _onUpdateTodo(
    UpdateTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await updateTodo(event.todo);
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => add(const LoadTodos()),
    );
  }

  Future<void> _onToggleTodo(
    ToggleTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final updatedTodo = event.todo.copyWith(
      isCompleted: !event.todo.isCompleted,
    );
    final result = await updateTodo(updatedTodo);
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => add(const LoadTodos()),
    );
  }

  Future<void> _onDeleteTodo(
    DeleteTodoEvent event,
    Emitter<TodoState> emit,
  ) async {
    final result = await deleteTodo(event.id);
    result.fold(
      (failure) => emit(TodoError(failure.message)),
      (_) => add(const LoadTodos()),
    );
  }
}
