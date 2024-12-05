import 'package:fundflow/models/user_model.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User userProfile;
  final double cashBox;

  ProfileLoaded({
    required this.userProfile,
    required this.cashBox,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
