import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage
import '../models/user_model.dart';

class AuthenticationRepository {
  final Dio _dio = Dio();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // FIX: Replace with your actual API endpoints
  final String loginUrl = 'https://yourapi.com/login';
  final String registerUrl = 'https://yourapi.com/register';
  final String getUserUrl = 'https://yourapi.com/me';
  final String logoutUrl = 'https://yourapi.com/logout';

  Future<User> login({required String email, required String password}) async {
    final response = await _dio.post(loginUrl, data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200) {
      // Save token securely
      await _secureStorage.write(key: 'token', value: response.data['token']);
      return User.fromJson(response.data['user']);
    } else {
      throw Exception('Failed to log in');
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String name,
  }) async {
    final response = await _dio.post(registerUrl, data: {
      'email': email,
      'password': password,
      'name': name,
    });

    if (response.statusCode == 201) {
      await _secureStorage.write(key: 'token', value: response.data['token']);
      return User.fromJson(response.data['user']);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<User?> getCurrentUser() async {
    String? token = await _secureStorage.read(key: 'token');

    if (token != null) {
      try {
        _dio.options.headers['Authorization'] = 'Bearer $token';
        final response = await _dio.get(getUserUrl);

        if (response.statusCode == 200) {
          return User.fromJson(response.data);
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  Future<void> logout() async {
    String? token = await _secureStorage.read(key: 'token');

    if (token != null) {
      try {
        _dio.options.headers['Authorization'] = 'Bearer $token';
        await _dio.post(logoutUrl);
      } catch (e) {
        // Handle error if needed
      } finally {
        await _secureStorage.delete(key: 'token');
      }
    }
  }
}
