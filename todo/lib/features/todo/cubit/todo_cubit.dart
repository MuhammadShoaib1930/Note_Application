import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/locators/locator.dart';
import 'package:todo/core/utils/stoarge_key.dart';
import 'package:todo/core/utils/storage_services.dart';
import 'package:todo/data/model/todo_model.dart';
import 'package:todo/data/repository/todo_repository.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());
  final TodoRepository _todoRepository = locator<TodoRepository>();
  final StoargeServices _stoargeServices = locator<StoargeServices>();

  void addTodo({
    required String title, required String description, required bool isCompleted
  })async{
    emit(TodoAddEditDeleteLoading());
    final res = await _todoRepository.addTodo(
      userId: _stoargeServices.getValue(StoargeKey.userId),
       title: title, 
       description: description,
        isCompleted: isCompleted
      );
      res.fold((failure) => emit(TodoError(error: failure.message)), 
      (document) => emit(TodoAddEditDeleteSuccess()),
      );
  }
  void getTodo() async{
    emit(TodoFetchLoading());
    final res= await _todoRepository.getTodo(userId: _stoargeServices.getValue(StoargeKey.userId));
    res.fold((failure) =>emit(TodoError(error: failure.message)) , (todoModle) =>emit(TodoFetchSuccess(todoModel: todoModle)));
  }
  void editTodo({
    required String documentId,
    required String title, required String description, required bool isCompleted
  })async{
    emit(TodoAddEditDeleteLoading());
    final res = await _todoRepository.editTodo(
      documentId: documentId,
       title: title, 
       description: description,
        isCompleted: isCompleted
      );
      res.fold((failure) => emit(TodoError(error: failure.message)), 
      (document) => emit(TodoAddEditDeleteSuccess()),
      );
  }
  void deleteTodo({required String documentId}) async{
    emit(TodoAddEditDeleteLoading());
    final res= await _todoRepository.delteTodo(
      documentId:  documentId);
    res.fold((failure) =>emit(TodoError(error: failure.message)) , (todoModle) =>emit(TodoAddEditDeleteSuccess()));
  }
}
