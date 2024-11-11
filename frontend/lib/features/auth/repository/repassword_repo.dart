import 'package:dio/dio.dart';
import 'package:fundflow/app.dart';

import '../models/otp_request.dart';
import '../models/otp_verify_request.dart';
import '../models/repassword_request.dart';

class RepasswordRepository {
  final Dio dio;
  final String baseUrl;

  RepasswordRepository({required this.baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
        ));

  Future<void> generateOTP(OTPRequest request) async {
    try {
      final response = await dio.post(
        '/claim-otp',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('OTP generated successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to generate OTP: ${e.response?.data}');
      throw Exception('Failed to generate OTP');
    }
  }

  Future<void> verifyOTP(OTPVerifyRequest request) async {
    try {
      final response = await dio.post(
        '/verify-otp',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('OTP verified successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to verify OTP: ${e.response?.data}');
      throw Exception('Failed to verify OTP');
    }
  }

  Future<void> resetPassword(RepasswordRequest request) async {
    try {
      final response = await dio.post(
        '/reset-password',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('Password reset successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to reset password: ${e.response?.data}');
      throw Exception('Failed to reset password');
    }
  }
}
