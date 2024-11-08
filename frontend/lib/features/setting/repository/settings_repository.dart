import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/setting/models/change_email_request.dart';
import 'package:fundflow/features/setting/models/change_password_request.dart';
import 'package:fundflow/features/setting/models/delete_account_request.dart';

class SettingsRepository {
  final Dio dio;
  final String baseUrl;
  final storage = FlutterSecureStorage();

  SettingsRepository({required this.baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<void> changeEmail(ChangeEmailRequest request) async {
    try {
      final response = await dio.post(
        '/changeEmail',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('Email changed successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to change email: ${e.response?.data}');
      throw Exception('Failed to change email');
    }
  }

  Future<void> changePassword(ChangePasswordRequest request) async {
    try {
      final response = await dio.post(
        '/changePassword',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('Password changed successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to change password: ${e.response?.data}');
      throw Exception('Failed to change password');
    }
  }

  Future<void> deleteAccount(DeleteAccountRequest request) async {
    try {
      final response = await dio.post(
        '/deleteAccount',
        data: request.toJson(),
      );
      // Handle the response
      logger.d('Account deleted successfully: ${response.data}');
    } on DioException catch (e) {
      // Handle errors
      logger.e('Failed to delete account: ${e.response?.data}');
      throw Exception('Failed to delete account');
    }
  }
}
