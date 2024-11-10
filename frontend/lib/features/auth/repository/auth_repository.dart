import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage
import 'package:fundflow/app.dart';
import '../models/user_model.dart';

class AuthenticationRepository {
  final Dio _dio;
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  AuthenticationRepository({required this.baseUrl})
      : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl, // Update based on your environment
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );

  Future<String> login(
      {required String username, required String password}) async {
    try {
      final response = await _dio.post("/login", data: {
        'username': username,
        'password': password,
      });

      logger.d('Login Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _secureStorage.write(key: 'token', value: token);
          return token;
        } else {
          throw Exception('Token not found in the response');
        }
      } else {
        throw Exception('Login failed');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        logger.e('Dio error response: ${dioError.response?.data}');
        throw Exception(
            dioError.response?.data['errors'][0]['msg'] ?? 'Login failed');
      } else {
        logger.e('Dio error: ${dioError.message}');
        throw Exception('Network error');
      }
    } catch (e) {
      logger.e('Login Error: $e');
      throw Exception('Login failed');
    }
  }

  Future<String> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _dio.post("/register", data: {
        'email': email,
        'password': password,
        'username': username,
      });

      logger.d('Register Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        final token = response.data['token'] as String?;
        if (token != null) {
          await _secureStorage.write(key: 'token', value: token);
          return token;
        } else {
          throw Exception('Token not found in the response');
        }
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        logger.e('Dio error response: ${dioError.response?.data}');
      } else {
        logger.e('Dio error: ${dioError.message}');
      }
      throw Exception('Failed to register: ${dioError.message}');
    } catch (e) {
      logger.e('Register Error: $e');
      throw Exception('Failed to register: $e');
    }
  }

  Future<String?> getStoredToken() async {
    return await _secureStorage.read(key: 'token');
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
  }

  /// Retrieves the current user's information.
  Future<User> getCurrentUser() async {
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.get('/profile', // Adjust endpoint
          options: Options(
            headers: {
              'Authorization': 'Bearer $token', // Use the retrieved token
            },
          ));
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Failed to load user: $e');
    }
  }

  /// Updates the user's avatar with the provided [avatarUrl].
  Future<void> updateUserAvatar(String avatarUrl) async {
    try {
      final String? token = await _secureStorage.read(key: 'token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      final response = await _dio.post(
        '/api/user/update-avatar', // Adjust endpoint
        data: {
          'profileImageUrl': avatarUrl
        }, // Ensure the key matches your backend
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Use the retrieved token
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update avatar');
      }
    } catch (e) {
      throw Exception('Failed to update avatar: $e');
    }
  }
}
