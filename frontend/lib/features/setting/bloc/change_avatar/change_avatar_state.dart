import 'package:equatable/equatable.dart';
import 'package:fundflow/features/setting/models/user_profile.dart';

abstract class ChangeAvatarState extends Equatable {
  const ChangeAvatarState();

  @override
  List<Object?> get props => [];
}

class ChangeAvatarInitial extends ChangeAvatarState {}

class UserProfileLoading extends ChangeAvatarState {}

class UserProfileLoaded extends ChangeAvatarState {
  final UserProfile userProfile;

  const UserProfileLoaded(this.userProfile);

  @override
  List<Object?> get props => [userProfile];
}

class UserProfileError extends ChangeAvatarState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

class AvatarPresetsLoading extends ChangeAvatarState {}

class AvatarPresetsLoaded extends ChangeAvatarState {
  final List<String> avatars;

  const AvatarPresetsLoaded(this.avatars);

  @override
  List<Object?> get props => [avatars];
}

class AvatarChangeSuccess extends ChangeAvatarState {}

class AvatarChangeFailure extends ChangeAvatarState {
  final String message;

  const AvatarChangeFailure(this.message);

  @override
  List<Object?> get props => [message];
}
