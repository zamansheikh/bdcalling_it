import 'package:bdcalling_it/screens/auth/login_bloc/login_event.dart';
import 'package:bdcalling_it/screens/auth/login_bloc/login_state.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bloc/bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthService authService;
  LoginBloc({required this.authService}) : super(LoginInitial()) {
    on<UserLoggedIn>((event, emit) async {
      emit(LoginLoading());
      try {
        final response = await authService.login(
          email: event.email,
          password: event.password,
        );
        if (response['status'] == 'Success') {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure(error: response['message']));
        }
      } catch (e) {
        emit(LoginFailure(error: e.toString()));
      }
    });
  }
}
