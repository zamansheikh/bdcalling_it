import 'dart:convert';
import 'dart:io';

import 'package:bdcalling_it/models/user_model.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;
  AuthBloc({
    required this.authService,
  }) : super(AuthInitial()) {
    on<UserRegistered>(
      (event, emit) async {
        emit(AuthLoading());
        try {
          final response = await authService.register(
            firstName: event.firstName,
            lastName: event.lastName,
            email: event.email,
            password: event.password,
            address: event.address,
            profileImage: event.profileImage,
          );
          if (response['status'] == 'Success') {
            emit(AuthSuccess());
          } else {
            emit(AuthError(response['message']));
          }
        } catch (e) {
          emit(AuthError(e.toString()));
        }
      },
    );
    on<UserLoggedIn>((event, emit) async {
      emit(AuthLoading());
      try {
        final response = await authService.login(
          email: event.email,
          password: event.password,
        );
        if (response['status'] == 'Success') {
          final user = await authService.getUser(response["data"]['token']);
          print(user);
          user != null
              ? emit(AuthAuthenticated(user))
              : emit(AuthError('User not found'));
        } else {
          emit(AuthError(response['message']));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<UserLoggedOut>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      try {
        final userToken = await authService.getToken();

        if (userToken != null) {
          final user = await authService.getUser(json.decode(userToken));
          emit(AuthAuthenticated(user!));
        } else {
          emit(AuthInitial());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
