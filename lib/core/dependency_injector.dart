import 'package:bdcalling_it/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:bdcalling_it/screens/task/task_bloc/task_bloc.dart';
import 'package:bdcalling_it/services/api_service.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bdcalling_it/services/task_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance; // Service locator

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => AuthBloc(authService: sl()));
  sl.registerFactory(() => TaskBloc(taskService: sl(), authService: sl()));

  // Services
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => TaskService(sl()));

  sl.registerLazySingleton(() => SharedPreferences.getInstance());
}
