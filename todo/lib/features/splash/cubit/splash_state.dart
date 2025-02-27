part of 'splash_cubit.dart';

sealed class SplashState {}
final class SplashInitial extends SplashState {}
final class SplashLoading extends SplashState {}
final class SplashSuccess extends SplashState {}
final class SplashError extends SplashState {
  final String error;
  SplashError({required this.error});
}
