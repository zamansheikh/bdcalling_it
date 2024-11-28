import 'dart:io';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bloc/bloc.dart';
part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
    final AuthService authService;

  RegisterBloc({
    required this.authService,
  }) : super(RegisterInitial()) {
    on<UserRegistered>((event, emit) {
    });
  }
}
