import 'dart:convert';
import 'dart:io';

import 'package:bdcalling_it/core/dependency_injector.dart';
import 'package:bdcalling_it/models/user_model.dart';
import 'package:bdcalling_it/services/auth_service.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthService authService;
  ProfileBloc({
    required this.authService,
  }) : super(ProfileInitial()) {
    on<FetchProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final token = await authService.getToken();
        final user = await authService.getUser(json.decode(token!));
        emit(ProfileLoaded(user!));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
    on<UpdateProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await authService.updateProfile(
          event.user,
          event.file,
        );
        sl<ProfileBloc>().add(FetchProfile());
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
