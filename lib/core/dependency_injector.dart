import 'package:bdcalling_it/screens/auth/regi_bloc/register_bloc.dart';
import 'package:bdcalling_it/services/api_service.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance; // Service locator

Future<void> init() async {
  // Bloc
  sl.registerFactory(() => RegisterBloc(authService: sl()));

  // Services
  sl.registerLazySingleton(() => AuthService());
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => SharedPreferences.getInstance());
}
