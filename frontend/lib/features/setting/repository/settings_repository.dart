import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/setting/models/change_email_request.dart';
import 'package:fundflow/features/setting/models/change_password_request.dart';
import 'package:fundflow/features/setting/models/delete_account_request.dart';
import 'package:fundflow/features/setting/models/user_profile.dart';
import 'package:fundflow/utils/api_helper.dart';

class SettingsRepository {
  final Dio dio;

  SettingsRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  Future<void> changeEmail(ChangeEmailRequest request) async {
    try {
      final response = await dio.post(
        '/settings/change-email',
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
        '/settings/change-password',
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
      final response = await dio.delete(
        '/settings/delete-account',
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

  Future<UserProfile> fetchUserProfile() async {
    try {
      final response = await dio.get('/profile');
      logger.d('Fetched user profile: ${response.data}');
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Failed to fetch user profile: ${e.response?.data}');
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> changeAvatar(String newAvatarUrl) async {
    logger.d('Sending PUT request to ${dio.options.baseUrl}/profile/');
    logger.d('Request data: ${{'new_user_profile_pic': newAvatarUrl}}');
    try {
      final response = await dio.put(
        '/profile/',
        data: {'new_user_profile_pic': newAvatarUrl},
        options: Options(
          followRedirects: false,
          validateStatus: (status) => status != null && status < 500,
        ),
      );
      logger.d('Response status code: ${response.statusCode}');
      logger.d('Avatar changed successfully: ${response.data}');
    } on DioException catch (e) {
      if (e.response != null) {
        final location = e.response!.headers.value('location');
        if (location != null) {
          logger.e('Redirecting to: $location');
        }
      }
      throw Exception('Failed to change avatar');
    }
  }

  Future<List<String>> fetchAvatarPresets() async {
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME']!;
    final apiKey = dotenv.env['CLOUDINARY_API_KEY']!;
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET']!;
    const folderPath = 'Fundflow/profiles';
    final baseUrl =
        'https://api.cloudinary.com/v1_1/$cloudName/resources/image';

    String basicAuth =
        'Basic ${base64Encode(utf8.encode('$apiKey:$apiSecret'))}';

    try {
      final response = await dio.get(
        baseUrl,
        options: Options(
          headers: {HttpHeaders.authorizationHeader: basicAuth},
        ),
        queryParameters: {
          'resource_type': 'image',
          'type': 'upload',
        },
      );

      if (response.statusCode == 200) {
        final List resources = response.data['resources'];

        // Filter images based on asset_folder, if necessary
        final List<String> imageUrls = resources
            .where((image) => image['asset_folder'] == folderPath)
            .map((image) => image['secure_url'] as String)
            .toList();
        logger.d('Fetched ${imageUrls.length} images');
        return imageUrls;
      } else {
        logger.e('Failed to fetch images: ${response.data}');
        throw Exception('Failed to load images');
      }
    } catch (e) {
      logger.e('Failed to fetch images: $e');
      return [];
    }
  }
}
