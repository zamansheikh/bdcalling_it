import 'package:bdcalling_it/core/theme/app_theme.dart';
import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/core/routes/route_generator.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'bdCalling IT Task',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      initialRoute: RouteNames.welcome,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
