import 'package:bdcalling_it/core/theme/app_theme.dart';
import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/core/routes/route_generator.dart';
import 'package:bdcalling_it/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:bdcalling_it/screens/task/task_bloc/task_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/dependency_injector.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => di.sl<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => di.sl<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'bdCalling IT Task',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        initialRoute: RouteNames.welcome,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
