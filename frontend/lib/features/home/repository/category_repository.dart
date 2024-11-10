import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/category.dart';

//http://localhost:8080/categories/all
//localhost:8080/categories/create
class CategoryRepository {
  final Dio dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl;

  CategoryRepository({required this.baseUrl})
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

  // Fetch categories from the API
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await dio.get("/categories/all");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        // You can calculate 'cashBox' here if needed (if the logic for 'cashBox' is still valid)
        // For example, you can calculate the sum of amounts of the categories if that makes sense:
        final cashBoxData =
            data.firstWhere((item) => item['id'] == 0, orElse: () => {});
        final categoriesData = data.where((item) => item['id'] != 0).toList();

        double cashBox = (cashBoxData['amount'] as num).toDouble();

        // Map response data to Category objects
        final categories = categoriesData
            .map((item) => Category(
                  name: item['name'],
                  amount: (item['amount'] as num).toDouble(),
                  color: Color(
                      int.parse(item['color_code'].replaceFirst('0x', '0xFF'))),
                ))
            .toList();

        return {
          'cashBox': cashBox,
          'categories': categories,
        };
      } else {
        logger.e('Failed to load categories ${response.data}');
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      logger.e('Error fetching categories: $error');
      throw Exception('Error fetching categories: $error');
    }
  }

  // Add a new category to the server
  Future<void> addCategory(Category category) async {
    try {
      // Ensure token is properly set in headers
      await _initializeToken();
      logger.i(
          'Adding category: ${category.amount} ${category.name} ${category.color} ');

      // Send the request with the correct payload
      final response = await dio.post(
        "/categories/create",
        data: {
          'name': category.name,
          'amount': category.amount,
          'color_code':
              '0xFF${category.color.value.toRadixString(16).substring(2).toUpperCase()}',
        },
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to add category, Response: ${response.data}');
        throw Exception('Failed to add category');
      }
    } catch (error) {
      // Detailed error logging
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error adding category: $error');
      }
      throw Exception('Error adding category: $error');
    }
  }
}
