import 'package:equatable/equatable.dart';

abstract class ChangeAvatarEvent extends Equatable {
  const ChangeAvatarEvent();

  @override
  List<Object> get props => [];
}

class FetchUserProfile extends ChangeAvatarEvent {}

class FetchAvatarPresets extends ChangeAvatarEvent {}

class ChangeAvatar extends ChangeAvatarEvent {
  final String newAvatarUrl;

  const ChangeAvatar(this.newAvatarUrl);

  @override
  List<Object> get props => [newAvatarUrl];
}
