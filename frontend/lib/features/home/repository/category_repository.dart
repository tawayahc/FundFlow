import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/category.dart';

class CategoryRepository {
  final Dio _dio = Dio();
  final String apiUrl =
      'http://10.0.2.2:3000/api/categories'; // Or your local IP

  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        final data = response.data;
        return {
          'cashBox': (data['cashBox'] as num).toDouble(), // Cast to double
          'categories': (data['categories'] as List)
              .map((item) => Category(
                    category: item['category'],
                    amount:
                        (item['amount'] as num).toDouble(), // Cast to double
                    color: Color(
                        int.parse(item['color'].replaceFirst('#', '0xFF'))),
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

  Future<void> addCategory(Category category) async {
    try {
      final response = await _dio.post(
        apiUrl,
        data: {
          'category': category.category,
          'amount': category.amount,
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
