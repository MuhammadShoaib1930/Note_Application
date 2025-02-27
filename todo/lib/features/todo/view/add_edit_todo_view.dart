import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/theme/app_color.dart';
import 'package:todo/core/utils/app_string.dart';
import 'package:todo/core/utils/custom_snackbar.dart';
import 'package:todo/core/utils/full_screen_dialog_loading.dart';
import 'package:todo/core/widgets/custom_text_form_field.dart';
import 'package:todo/core/widgets/rounded_elevated_button.dart';
import 'package:todo/data/model/todo_model.dart';
import 'package:todo/features/todo/cubit/todo_cubit.dart';

class AddEditTodoView extends StatefulWidget {
  final TodoModel? todoModel;
  const AddEditTodoView({super.key, this.todoModel});
  @override
  State<AddEditTodoView> createState() => _AddEditTodoViewState();
}

class _AddEditTodoViewState extends State<AddEditTodoView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEditingController,
      _descriptionEditingController;
  late bool isCompleted;
  @override
  void initState() {
    super.initState();
    _titleEditingController =
        TextEditingController(text: widget.todoModel?.title ?? "");
    _descriptionEditingController =
        TextEditingController(text: widget.todoModel?.description ?? "");
    isCompleted = widget.todoModel?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    super.dispose();
  }

  clearText() {
    _titleEditingController.clear();
    _descriptionEditingController.clear();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final title = _titleEditingController.text;
      final description = _descriptionEditingController.text;
      if (widget.todoModel == null) {
        context.read<TodoCubit>().addTodo(
            title: title, description: description, isCompleted: false);
      } else {
        context.read<TodoCubit>().editTodo(
            documentId: widget.todoModel!.id,
            title: title,
            description: description,
            isCompleted: isCompleted);
      }
    }
  }

  void _deleteTodo({required String documentId}) {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        title: AppString.deleteTodo,
        desc: AppString.areYouSureToDeleteTodo,
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          context.read<TodoCubit>().deleteTodo(documentId: documentId);
        }).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.todoModel == null ? AppString.addTodo : AppString.editTode),
        actions: [
          if (widget.todoModel != null)
            IconButton(
              onPressed: () {
                _deleteTodo(documentId: widget.todoModel!.id);
              },
              icon: Icon(
                Icons.delete,
                color: AppColor.whiteColor,
              ),
            )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: BlocConsumer<TodoCubit, TodoState>(
          listener: (context, state) {
            if (state is TodoAddEditDeleteLoading) {
              FullScreenDialogLoading.show(context);
            } else if (state is TodoAddEditDeleteSuccess) {
              FullScreenDialogLoading.cancel(context);
              clearText();
              if (widget.todoModel == null) {
                CustomSnackbar.showSuccess(context, AppString.todoCreated);
              } else {
                CustomSnackbar.showSuccess(context, AppString.todoUpdated);
              }
              context.pop();
              context.read<TodoCubit>().getTodo();
            } else if (state is TodoError) {
              FullScreenDialogLoading.cancel(context);
              CustomSnackbar.showError(context, state.error);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                      controller: _titleEditingController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppString.required;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      hintText: AppString.title,
                      suffix: null),
                  CustomTextFormField(
                      controller: _descriptionEditingController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return AppString.required;
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      obscureText: false,
                      hintText: AppString.description,
                      suffix: null),
                  SizedBox(
                    height: 10,
                  ),
                  if (widget.todoModel != null)
                    Checkbox(
                      value: isCompleted,
                      onChanged: (value) {
                        setState(() {
                          isCompleted = value!;
                        });
                      },
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  RoundedElevatedButton(
                    buttonText: widget.todoModel == null
                        ? AppString.add
                        : AppString.update,
                    onPressed: () {
                      _submit();
                    },
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
