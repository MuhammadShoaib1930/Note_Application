import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/routes/route_names.dart';
import 'package:todo/core/theme/app_color.dart';
import 'package:todo/core/utils/app_string.dart';
import 'package:todo/features/todo/cubit/todo_cubit.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  @override
  void initState() {
    context.read<TodoCubit>().getTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.todo),
        actions: [
          IconButton(
              onPressed: () {
                //Move to profile Screen
              },
              icon: Icon(Icons.person)),
        ],
      ),
      body: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          if (state is TodoFetchLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TodoFetchSuccess) {
            final todos = state.todoModel;
            return todos.isNotEmpty
                ? ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        onTap: () => context.pushNamed(RouteNames.editTodo, extra: todo),
                        title: Text(todo.title),
                        subtitle: Text(todo.description),
                        leading: CircleAvatar(
                          radius: 10,
                          backgroundColor: todo.isCompleted
                              ? AppColor.snackBarGreen
                              : AppColor.snackBarRed,
                        ),
                      );
                    },
                  )
                : Center(
                    child: Text(AppString.noDataFound),
                  );
          } else if (state is TodoError) {
            return Center(
              child: Text(state.error),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(RouteNames.addTodo);
        },
        backgroundColor: AppColor.appColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
