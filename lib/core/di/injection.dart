import 'package:get_it/get_it.dart';

import '../../features/todo/data/datasources/todo_local_datasource.dart';
import '../../features/todo/data/repositories/todo_repository_impl.dart';
import '../../features/todo/domain/repositories/todo_repository.dart';
import '../../features/todo/domain/usecases/add_todo.dart';
import '../../features/todo/domain/usecases/delete_todo.dart';
import '../../features/todo/domain/usecases/get_todos.dart';
import '../../features/todo/domain/usecases/update_todo.dart';
import '../../features/todo/presentation/bloc/todo_bloc.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Datasources
  final database = TodoLocalDatasource();
  getIt.registerLazySingleton<TodoLocalDatasource>(() => database);

  // Repositories
  getIt.registerLazySingleton<TodoRepository>(
    () => TodoRepositoryImpl(localDatasource: getIt()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => GetTodos(getIt()));
  getIt.registerLazySingleton(() => AddTodo(getIt()));
  getIt.registerLazySingleton(() => UpdateTodo(getIt()));
  getIt.registerLazySingleton(() => DeleteTodo(getIt()));

  // Bloc
  getIt.registerFactory(
    () => TodoBloc(
      getTodos: getIt(),
      addTodo: getIt(),
      updateTodo: getIt(),
      deleteTodo: getIt(),
    ),
  );
}
