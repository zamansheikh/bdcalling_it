part of 'register_bloc.dart';

sealed class RegisterEvent {}

class UserRegistered extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String address;
  final File? profileImage;

  UserRegistered({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.address,
    this.profileImage,
  });
}