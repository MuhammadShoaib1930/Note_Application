import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:todo/core/utils/storage_services.dart';
import 'package:todo/data/provider/appwrite_provider.dart';
import 'package:todo/data/repository/auth_repository.dart';
import 'package:todo/data/repository/todo_repository.dart';

final locator = GetIt.I;

void setupLocator() {
  locator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.createInstance(),
  );
  locator.registerLazySingleton<AppwriteProvider>(
    () => AppwriteProvider());
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepository());
  locator.registerLazySingleton<StoargeServices>(
    () => StoargeServices());
  locator.registerLazySingleton<TodoRepository>(
    () => TodoRepository());
}
