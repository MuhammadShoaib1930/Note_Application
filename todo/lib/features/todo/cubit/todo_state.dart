part of 'todo_cubit.dart';

sealed class TodoState{}
final class TodoInitial extends TodoState {}
final class TodoAddEditDeleteLoading extends TodoState {}
final class TodoFetchLoading extends TodoState {}
final class TodoAddEditDeleteSuccess extends TodoState {}
final class TodoFetchSuccess extends TodoState {
  final List<TodoModel> todoModel;
  TodoFetchSuccess({
    required this.todoModel
  });
}
final class TodoError extends TodoState {
  final String error;
  TodoError({
    required this.error
  });
}
