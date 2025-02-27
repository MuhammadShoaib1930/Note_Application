
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/core/locators/locator.dart';
import 'package:todo/data/repository/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());
  final AuthRepository _authRepository= locator<AuthRepository>();
  void checkSession()async{
    emit(SplashLoading());
    final res =await _authRepository.checkSession();
    res.fold((failure)=>emit(SplashError(error: failure.message)), (session) => emit(SplashSuccess()),);
  }
}
