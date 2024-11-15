import 'package:fundflow/features/setting/models/user_profile.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserProfile userProfile;
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
