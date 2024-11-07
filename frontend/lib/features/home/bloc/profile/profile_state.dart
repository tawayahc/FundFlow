abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String username;
  final double totalMoney;

  ProfileLoaded({required this.username, required this.totalMoney});
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError({required this.message});
}
