part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class FetchProfile extends ProfileEvent {}

final class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String address;
  final File file;
  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.file,
  });

  @override
  List<Object> get props => [
    firstName,
    lastName,
    address,
    file,
  ];
}