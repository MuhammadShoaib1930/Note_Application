import 'package:go_router/go_router.dart';
import 'package:todo/core/routes/route_names.dart';
import 'package:todo/data/model/todo_model.dart';
import 'package:todo/features/auth/view/login_view.dart';
import 'package:todo/features/auth/view/register_view.dart';
import 'package:todo/features/splash/view/splash_view.dart';
import 'package:todo/features/todo/view/add_edit_todo_view.dart';
import 'package:todo/features/todo/view/todo_view.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(
    name: RouteNames.splash,
    path: "/",
    builder: (context, state) => SplashView(),
  ),
  GoRoute(
    name: RouteNames.login,
    path: "/login",
    builder: (context, state) => LoginView(),
  ),
  GoRoute(
    name: RouteNames.register,
    path: "/register",
    builder: (context, state) => RegisterView(),
  ),
  GoRoute(
    name: RouteNames.todo,
    path: "/todo",
    builder: (context, state) => TodoView(),
  ),
  GoRoute(
    name: RouteNames.addTodo,
    path: "/addTodo",
    builder: (context, state) => AddEditTodoView(),
  ),
  GoRoute(
    name: RouteNames.editTodo,
    path: "/editTodo",
    builder: (context, state) {
      final todoModel = state.extra as TodoModel;
      return AddEditTodoView(todoModel: todoModel);
      },
  ),

]);
