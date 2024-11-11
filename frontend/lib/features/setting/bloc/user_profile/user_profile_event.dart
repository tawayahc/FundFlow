// user_profile_event.dart

part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends UserProfileEvent {}

class SubmitChangeEmailEvent extends UserProfileEvent {
  final String newEmail;

  const SubmitChangeEmailEvent(this.newEmail);

  @override
  List<Object> get props => [newEmail];
}

class FetchAvatarPresets extends UserProfileEvent {}

class ChangeAvatar extends UserProfileEvent {
  final String newAvatarUrl;

  const ChangeAvatar(this.newAvatarUrl);

  @override
  List<Object> get props => [newAvatarUrl];
}
