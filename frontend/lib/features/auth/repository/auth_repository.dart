import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // Secure storage
import '../models/user_model.dart';

class AuthenticationRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.0.2.2:8080/', // Update based on your environment
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final String loginUrl = '/login';
  final String registerUrl = '/register';
  final String getUserUrl = '/me';

  Future<User> login({required String email, required String password}) async {
    try {
      final response = await _dio.post(loginUrl, data: {
        'email': email,
        'password': password,
      });

      print('Login Response: ${response.statusCode} ${response.data}');

      if (response.statusCode == 200) {
        // Save token securely
        await _secureStorage.write(key: 'token', value: response.data['token']);
        return User.fromJson(response.data['user']);
      } else {
        throw Exception('Failed to log in');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Dio error response: ${dioError.response?.data}');
        throw Exception(
            dioError.response?.data['errors'][0]['msg'] ?? 'Login failed');
      } else {
        print('Dio error: ${dioError.message}');
        throw Exception('Network error');
      }
    } catch (e) {
      print('Login Error: $e');
      throw Exception('Login failed');
    }
  }

  Future<User> register({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final response = await _dio.post(registerUrl, data: {
        'email': email,
        'password': password,
        'username': username,
      });
      print('Register Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 201) {
        await _secureStorage.write(key: 'token', value: response.data['token']);
        return User.fromJson(response.data['user']);
      } else {
        throw Exception('Failed to register');
      }
    } on DioException catch (dioError) {
      if (dioError.response != null) {
        print('Dio error response: ${dioError.response?.data}');
      } else {
        print('Dio error: ${dioError.message}');
      }
      throw Exception('Failed to register: ${dioError.message}');
    } catch (e) {
      print('Register Error: $e');
      throw Exception('Failed to register: $e');
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
          print('Failed to fetch user: ${response.statusCode}');
          return null;
        }
      } on DioException catch (dioError) {
        print('Dio error: ${dioError.response?.data}');
        return null;
      } catch (e) {
        print('Error fetching user: $e');
        return null;
      }
    }
    return null;
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: 'token');
    // No need to call /logout on the server
  }
}
