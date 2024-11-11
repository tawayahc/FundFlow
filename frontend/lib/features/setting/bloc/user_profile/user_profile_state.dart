// user_profile_state.dart

part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class ChangeAvatarInitial extends UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class ChangeEmailInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class ChangeEmailLoading extends UserProfileState {}

class AvatarPresetsLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfile userProfile;

  const UserProfileLoaded(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class AvatarPresetsLoaded extends UserProfileState {
  final List<String> avatars;

  const AvatarPresetsLoaded(this.avatars);

  @override
  List<Object> get props => [avatars];
}

class ChangeEmailSuccess extends UserProfileState {}

class AvatarChangeSuccess extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String error;

  const UserProfileError({required this.error});

  @override
  List<Object> get props => [error];
}

class ChangeEmailFailure extends UserProfileState {
  final String error;

  const ChangeEmailFailure({required this.error});

  @override
  List<Object> get props => [error];
}

class AvatarChangeFailure extends UserProfileState {
  final String message;

  const AvatarChangeFailure(this.message);

  @override
  List<Object> get props => [message];
}
