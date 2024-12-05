import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/utils/api_helper.dart';

class TransactionRepository {
  final Dio dio;

  TransactionRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  Future<Map<String, dynamic>> getTransactions() async {
    try {
      final response = await dio.get("/transactions/all");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        final transactions = data
            .map((item) => Transaction(
                  id: item['id'],
                  type: item['type'],
                  amount: (item['amount'] as num).toDouble(),
                  bankId: item['bank_id'],
                  bankNickname: item['bank_nickname'],
                  bankName: item['bank_name'],
                  categoryId: item['category_id'] ?? 0,
                  metaData: item['meta_data'],
                  memo: item['memo'],
                  createdAt: item['created_at'],
                ))
            .toList();
        return {
          'transactions': transactions,
        };
      } else {
        logger.e('Failed to load Transactions ${response.data}');
        throw Exception('Failed to load Transactions');
      }
    } catch (error) {
      logger.e('Error fetching Transactions: $error');
      throw Exception('Error fetching Transactions: $error');
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

  Future<void> updateBankAmount(int bankId, double newAmount) async {
    try {
      final data = {'new_amount': newAmount};
      final response = await dio.put("/banks/$bankId", data: data);

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to update bank amount, Response: ${response.data}');
        throw Exception('Failed to update bank amount');
      }
    } catch (error) {
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error updating bank amount: $error');
      }
      throw Exception('Error updating bank amount: $error');
    }
  }

  Future<Bank> getBankById(int bankId) async {
    try {
      final response = await dio.get("/banks/$bankId");
      if (response.statusCode == 200) {
        final data = response.data;
        final bank = Bank(
          id: data['id'],
          name: data['name'],
          bankName: data['bank_name'],
          amount: (data['amount'] as num).toDouble(),
        );
        return bank;
      } else {
        throw Exception('Failed to get bank');
      }
    } catch (error) {
      throw Exception('Error getting bank: $error');
    }
  }

  Future<void> updateCategoryAmount(int categoryId, double newAmount) async {
    try {
      final data = {'new_amount': newAmount};
      final response = await dio.put("/categories/$categoryId", data: data);

      logger.d('Response: $newAmount');

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

  Future<Category> getCategoryById(int categoryId) async {
    try {
      final response = await dio.get("/categories/$categoryId");
      if (response.statusCode == 200) {
        final data = response.data;
        final category = Category(
          id: data['id'],
          name: data['name'],
          amount: (data['amount'] as num).toDouble(),
          color:
              Color(int.parse(data['color_code'].replaceFirst('0x', '0xFF'))),
        );
        return category;
      } else {
        throw Exception('Failed to get category');
      }
    } catch (error) {
      throw Exception('Error getting category: $error');
    }
  }
}
