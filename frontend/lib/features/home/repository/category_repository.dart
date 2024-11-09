import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/category.dart';

class CategoryRepository {
  final Dio _dio = Dio();
  final String apiUrl =
      'http://10.0.2.2:3000/api/categories'; // Localhost API endpoint for Android emulator

  // Fetch categories from the API
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        final data = response.data;

        // Mapping response data to a list of Category objects
        return {
          'cashBox':
              (data['cashBox'] as num).toDouble(), // Convert cashBox to double
          'categories': (data['categories'] as List)
              .map((item) => Category(
                    name: item['name'],
                    amount: (item['amount'] as num)
                        .toDouble(), // Convert amount to double
                    color: Color(int.parse(item['color']
                        .replaceFirst('#', '0xFF'))), // Parse color value
                  ))
              .toList(),
        };
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      throw Exception('Error fetching categories: $error');
    }
  }

  // Add a new category to the server
  Future<void> addCategory(Category category) async {
    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          'name': category.name,
          'amount': category.amount,
          // Convert Color object to hex format string
          'color':
              '#${category.color.value.toRadixString(16).substring(2).toUpperCase()}',
        },
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add category');
      }
    } catch (error) {
      throw Exception('Error adding category: $error');
    }
  }
}
