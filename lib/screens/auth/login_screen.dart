import 'package:bdcalling_it/core/dependency_injector.dart';
import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/screens/auth/login_bloc/login_bloc.dart';
import 'package:bdcalling_it/screens/auth/login_bloc/login_event.dart';
import 'package:bdcalling_it/screens/auth/login_bloc/login_state.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bdcalling_it/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(authService: sl<AuthService>()),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacementNamed(context, RouteNames.tasklist);
            } else if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
          child: BlocBuilder<LoginBloc, LoginState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomTextField(
                        controller: _emailController,
                        labelText: 'Email',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        obscureText: true,
                      ),
                      const SizedBox(height: 16),
                      if (state is LoginLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(UserLoggedIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                ));
                          },
                          child: const Text('Login'),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
