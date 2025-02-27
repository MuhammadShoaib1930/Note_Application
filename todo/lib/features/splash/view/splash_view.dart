import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/utils/app_image_url.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/core/routes/route_names.dart';
import 'package:todo/core/utils/custom_snackbar.dart';
import 'package:todo/core/utils/full_screen_dialog_loading.dart';
import 'package:todo/features/splash/cubit/splash_cubit.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkSession();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocConsumer<SplashCubit, SplashState>(
          listener: (context, state) {
            if(state is SplashLoading){
              FullScreenDialogLoading.show(context);
            }else
            if(state is SplashSuccess){
              FullScreenDialogLoading.cancel(context);
              context.goNamed(RouteNames.todo);
            }else
            if(state is SplashError){
              FullScreenDialogLoading.cancel(context);
              context.goNamed(RouteNames.login);
              CustomSnackbar.showError(context, state.error);
            }
          },
          builder: (context, state) {
            return Image.asset(
              AppImageUrl.logo,
              width: 80,
              height: 80,
            );
          },
        ),
      ),
    );
  }
}
