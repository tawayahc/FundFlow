import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';

class ApiHelper {
  final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  // Singleton pattern (optional, based on your app's needs)
  static ApiHelper? _instance;

  factory ApiHelper({required String baseUrl}) {
    if (_instance == null) {
      _instance = ApiHelper._internal(baseUrl);
    }
    return _instance!;
  }

  ApiHelper._internal(String baseUrl)
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          // **Conditional Authorization Header Addition**
          // Only add Bearer token if Authorization header is not already set
          if (!options.headers.containsKey('Authorization')) {
            String? token = await storage.read(key: 'token');
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
              // logger.d('Authorization header set with token: $token');
            } else {
              logger.w('No token found in secure storage.');
            }
          } else {
            logger.d('Authorization header already set for this request.');
          }
        } catch (e) {
          logger.e('Error reading token from storage: $e');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        // Handle responses globally if needed
        return handler.next(response);
      },
      onError: (DioException e, handler) {
        // Handle errors globally if needed
        return handler.next(e);
      },
    ));
  }

  // Optional: Add methods for specific API needs, e.g., upload, download, etc.
}
