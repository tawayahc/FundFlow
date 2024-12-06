import 'package:fundflow/features/auth/models/otp_request.dart';
import 'package:fundflow/features/auth/models/otp_verify_request.dart';
import 'package:fundflow/features/auth/models/repassword_request.dart';

abstract class RepasswordEvent {}

class GenerateOTPEvent extends RepasswordEvent {
  final OTPRequest request;

  GenerateOTPEvent(this.request);
}

class VerifyOTPEvent extends RepasswordEvent {
  final OTPVerifyRequest request;

  VerifyOTPEvent(this.request);
}

class ResetPasswordEvent extends RepasswordEvent {
  final RepasswordRequest request;

  ResetPasswordEvent(this.request);
}
