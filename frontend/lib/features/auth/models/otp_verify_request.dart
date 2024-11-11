class OTPVerifyRequest {
  final String email;
  final String otp;

  OTPVerifyRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {'email': email, 'otp': otp};
  }
}
