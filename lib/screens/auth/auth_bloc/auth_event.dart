part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class UserLoggedIn extends AuthEvent {
  final String email;
  final String password;

  const UserLoggedIn({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}


class UserRegistered extends AuthEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final File? profileImage;

  const UserRegistered({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    this.profileImage,
  });
}

class UserLoggedOut extends AuthEvent {}

class AppStarted extends AuthEvent {}