import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/todo/domain/entities/todo_entity.dart';
import '../../features/todo/presentation/pages/todo_detail_page.dart';
import '../../features/todo/presentation/pages/todo_list_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'todoList',
      builder: (context, state) => const TodoListPage(),
    ),
    GoRoute(
      path: '/todo/:id',
      name: 'todoDetail',
      builder: (context, state) {
        final todo = state.extra as TodoEntity;
        return TodoDetailPage(todo: todo);
      },
    ),
  ],
);
