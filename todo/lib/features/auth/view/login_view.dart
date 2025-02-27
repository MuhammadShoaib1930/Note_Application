import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/locators/locator.dart';
import 'package:todo/core/routes/route_names.dart';
import 'package:todo/core/theme/app_color.dart';
import 'package:todo/core/utils/app_image_url.dart';
import 'package:todo/core/utils/app_string.dart';
import 'package:todo/core/utils/custom_snackbar.dart';
import 'package:todo/core/utils/full_screen_dialog_loading.dart';
import 'package:todo/core/utils/stoarge_key.dart';
import 'package:todo/core/utils/storage_services.dart';
import 'package:todo/core/utils/validation_rules.dart';
import 'package:todo/core/widgets/custom_text_form_field.dart';
import 'package:todo/core/widgets/rounded_elevated_button.dart';
import 'package:todo/features/auth/cubit/login_cubit.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final StoargeServices _stoargeServices = locator<StoargeServices>();
  bool isPasswordVisible = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void clearText() {
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: BlocConsumer<LoginCubit, LoginState>(
              listener: (context, state) {
                if (state is LoginLoading) {
                  FullScreenDialogLoading.show(context);
                } else if (state is LoginSuccess) {
                  FullScreenDialogLoading.cancel(context);
                  CustomSnackbar.showSuccess(context, AppString.success);
                  clearText();
                  _stoargeServices.setValue(
                      StoargeKey.userId, state.session.userId);
                  _stoargeServices.setValue(
                      StoargeKey.seesionId, state.session.$id);
                  context.goNamed(RouteNames.todo);
                } else if (state is LoginFailure) {
                  FullScreenDialogLoading.cancel(context);
                  CustomSnackbar.showError(context, state.error);
                }
              },
              builder: (context, state) {
                return Form(
                  key: _loginFormKey,
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
                        suffix: null,
                      ),
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
                          child: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColor.greyColor,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RoundedElevatedButton(
                          buttonText: AppString.login,
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              context.read<LoginCubit>().login(
                                  email: _emailController.text,
                                  password: _passwordController.text);
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushNamed(RouteNames.register);
                        },
                        child: RichText(
                            text: TextSpan(
                                text: AppString.newUser,
                                style: TextStyle(color: AppColor.greyColor),
                                children: [
                              TextSpan(
                                text: AppString.register,
                                style: TextStyle(
                                  color: AppColor.appColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ])),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
