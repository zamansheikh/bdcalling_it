import 'dart:io';

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
        final user = await authService.getUser("Tokern");
        emit(ProfileLoaded(user!));//TODO: Add mail when API will be ready
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
