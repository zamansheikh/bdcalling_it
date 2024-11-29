part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

final class FetchProfile extends ProfileEvent {}

final class UpdateProfile extends ProfileEvent {
  final UserModel user;
  final File file;
  const UpdateProfile({
    required this.user,
    required this.file,
  });

  @override
  List<Object> get props => [
        user,
        file,
      ];
}
