import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/utils/api_helper.dart';

class CategoryRepository {
  final Dio dio;

  CategoryRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  // Fetch categories from the API
  Future<Map<String, dynamic>> getCategories() async {
    try {
      final response = await dio.get("/categories/all");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final cashBoxData =
            data.firstWhere((item) => item['id'] == 0, orElse: () => {});
        final categoriesData = data.where((item) => item['id'] != 0).toList();

        double cashBox = (cashBoxData['amount'] as num).toDouble();

        // Map response data to Category objects
        final categories = categoriesData
            .map((item) => Category(
                  id: item['id'],
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

  Future<void> editCategory(
      Category originalCategory, Category category) async {
    try {
      logger.i(
          'Editing category: ${category.amount} ${category.name} ${category.color} ');

      // Initialize the payload
      Map<String, dynamic> data = {};

      // Check for changes and add to data if necessary
      if (category.name != originalCategory.name) {
        data['new_name'] = category.name;
      }
      if (category.amount != originalCategory.amount) {
        data['new_amount'] = category.amount;
      }
      if (category.color != originalCategory.color) {
        data['new_color_code'] =
            '0xFF${category.color.value.toRadixString(16).substring(2).toUpperCase()}';
      }

      // If nothing has changed, we can skip the API call
      if (data.isEmpty) {
        logger.i('No changes to update');
        return;
      }

      // Send the request with the updated data
      final response = await dio.put(
        "/categories/${category.id}",
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to edit category, Response: ${response.data}');
        throw Exception('Failed to edit category');
      }
    } catch (error) {
      // Detailed error logging
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error editing category: $error');
      }
      throw Exception('Error editing category: $error');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      final response = await dio.delete("/categories/$categoryId");

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to delete category, Response: ${response.data}');
        throw Exception('Failed to delete category');
      }
    } catch (error) {
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error deleting category: $error');
      }
      throw Exception('Error deleting category: $error');
    }
  }

  Future<Map<String, List<Transaction>>> getCategoryTransactions(
      int categoryId) async {
    try {
      final response = await dio.get("/categories/$categoryId");

      if (response.statusCode == 200) {
        // Ensure response data is parsed correctly
        final Map<String, dynamic> data = response.data;

        if (data.containsKey('transactions') && data['transactions'] is List) {
          final List<dynamic> transactionsData = data['transactions'];

          final categoryTransactions = transactionsData
              .map((item) => Transaction(
                    id: item['id'],
                    categoryId: item['category_id'],
                    amount: (item['amount'] as num).toDouble(),
                    memo: item['memo'],
                    type: item['type'],
                    bankId: item['bank_id'],
                    bankNickname: item['bank_nickname'],
                    bankName: item['bank_name'],
                    createdAt: item['created_at'],
                  ))
              .toList();

          return {
            'transactions': categoryTransactions,
          };
        } else {
          throw Exception('Invalid transactions format in response');
        }
      } else {
        logger.e('Failed to load categories: ${response.data}');
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      logger.e('Error fetching categories: $error');
      throw Exception('Error fetching categories: $error');
    }
  }

  Future<void> transferAmount(
      int fromCategoryId, int toCategoryId, double amount) async {
    try {
      logger.i('Editing category: $amount $fromCategoryId $toCategoryId ');

      final data = {
        'from_category_id': fromCategoryId,
        'to_category_id': toCategoryId,
        'amount': amount,
      };

      final response = await dio.post(
        "/categories/transfer",
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to transfer amount, Response: ${response.data}');
        throw Exception('Failed to transfer amount');
      }
    } catch (error) {
      // Detailed error logging
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error transfer amount: $error');
      }
      throw Exception('Error transfer amount: $error');
    }
  }

  Future<void> updateCategoryAmount(int categoryId, double newAmount) async {
    try {
      final data = {
        'new_amount': newAmount,
      };

      final response = await dio.put("/categories/$categoryId", data: data);

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger
            .e('Failed to update category amount, Response: ${response.data}');
        throw Exception('Failed to update category amount');
      }
    } catch (error) {
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error updating category amount: $error');
      }
      throw Exception('Error updating category amount: $error');
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    try {
      final response = await dio.delete("/transactions/$transactionId");

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to delete transaction, Response: ${response.data}');
        throw Exception('Failed to delete transaction');
      }
    } catch (error) {
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error deleting transaction: $error');
      }
      throw Exception('Error deleting transaction: $error');
    }
  }
}
