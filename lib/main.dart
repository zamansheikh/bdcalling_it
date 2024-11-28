import 'package:bdcalling_it/core/theme/app_theme.dart';
import 'package:bdcalling_it/screens/splash/welcome_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      home: const WelcomeScreen(),
    );
  }
}
