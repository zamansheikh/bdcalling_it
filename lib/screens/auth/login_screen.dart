import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/screens/auth/auth_bloc/auth_bloc.dart';
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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, RouteNames.bottomNav);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
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
                  if (state is AuthLoading)
                    const CircularProgressIndicator()
                  else
                    ElevatedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(UserLoggedIn(
                              email: _emailController.text,
                              password: _passwordController.text,
                            ));
                      },
                      child: const Text('Login'),
                    ),
                  const SizedBox(height: 16),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RouteNames.register);
                    },
                    child: RichText(
                        text: const TextSpan(
                      text: 'Don\'t have an account? ',
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
