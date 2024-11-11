abstract class RepasswordState {}

class RepasswordInitial extends RepasswordState {}

class RepasswordLoading extends RepasswordState {}

class RepasswordOTPSent extends RepasswordState {}

class RepasswordOTPVerified extends RepasswordState {}

class RepasswordPasswordReset extends RepasswordState {}

class RepasswordFailure extends RepasswordState {
  final String error;

  RepasswordFailure(this.error);
}
