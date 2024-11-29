import 'package:bdcalling_it/core/routes/route_names.dart';
import 'package:bdcalling_it/core/dependency_injector.dart';
import 'package:bdcalling_it/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    handleAuthCheck();
    super.initState();
  }

  void handleAuthCheck() async {
    sl<AuthBloc>().add(AppStarted());
    final AuthService authService = sl<AuthService>();
    final authToken = await authService.getToken();
    await Future.delayed(const Duration(seconds: 1));
    if (authToken != null) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.tasklist);
      }
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: AspectRatio(
                      aspectRatio: 1.5,
                      child: SvgPicture.asset(
                        "assets/svg_icon/task_icon.svg",
                        colorFilter:
                            ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                  ErrorInfo(
                    title: "Hello and Welcome",
                    description:
                        "We're setting things up for you. This will only take a moment.",
                    button: Transform.scale(
                      scale: 1.2,
                      child: const CircularProgressIndicator.adaptive(),
                    ),
                    press: () {},
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

class ErrorInfo extends StatelessWidget {
  const ErrorInfo({
    super.key,
    required this.title,
    required this.description,
    this.button,
    this.btnText,
    required this.press,
  });

  final String title;
  final String description;
  final Widget? button;
  final String? btnText;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16 * 2.5),
            button ??
                ElevatedButton(
                  onPressed: press,
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  child: Text(btnText ?? "Retry".toUpperCase()),
                ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
