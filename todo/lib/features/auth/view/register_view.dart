import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/routes/route_names.dart';
import 'package:todo/core/utils/app_image_url.dart';
import 'package:todo/core/utils/app_string.dart';
import 'package:todo/core/utils/custom_snackbar.dart';
import 'package:todo/core/utils/full_screen_dialog_loading.dart';
import 'package:todo/core/utils/validation_rules.dart';
import 'package:todo/core/widgets/custom_text_form_field.dart';
import 'package:todo/core/widgets/rounded_elevated_button.dart';
import 'package:todo/features/auth/cubit/register_cubit.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _firestNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  clearText(){
    _firestNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
  }
  @override
  void dispose() {
    _firestNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if(state is RegisterLoading){
                FullScreenDialogLoading.show(context);
              }else if(state is RegisterSuccess){
                clearText();
                FullScreenDialogLoading.cancel(context);
                CustomSnackbar.showSuccess(context, AppString.accountCreated
                );
                context.goNamed(RouteNames.login);

              }else if(state is RegisterError){
                FullScreenDialogLoading.cancel(context);
                CustomSnackbar.showError(context, state.error);
              }
            },
            builder: (context, state) {
              return Form(
                  key: _registerFormKey,
                  child: Column(
                    children: [
                      Image.asset(
                        AppImageUrl.logo,
                        width: 100,
                        height: 100,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      CustomTextFormField(
                          controller: _firestNameController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.required;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          obscureText: false,
                          hintText: AppString.firstName,
                          suffix: null),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                          controller: _lastNameController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.required;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          obscureText: false,
                          hintText: AppString.lastName,
                          suffix: null),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                          controller: _emailController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.required;
                            } else if (!ValidationRules.emailValidation
                                .hasMatch(val)) {
                              return AppString.provideValidEmail;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          obscureText: false,
                          hintText: AppString.email,
                          suffix: null),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                          controller: _passwordController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return AppString.required;
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: !isPasswordVisible,
                          hintText: AppString.password,
                          suffix: InkWell(
                            onTap: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            child: Icon(isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      RoundedElevatedButton(
                        buttonText: AppString.register,
                        onPressed: () {
                          if (_registerFormKey.currentState!.validate()) {
                            context.read<RegisterCubit>().register(
                              firstName: _firestNameController.text, 
                              lastName: _lastNameController.text, 
                              email: _emailController.text, 
                              password: _passwordController.text);

                          }
                        },
                      ),
                    ],
                  ));
            },
          ),
        ),
      )),
    );
  }
}
