import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/model/create_transfer_request.dart';
import 'package:fundflow/features/transaction/model/form_model.dart';
import 'package:fundflow/utils/api_helper.dart';
import '../model/create_transaction_request_model.dart';

class TransactionAddRepository {
  final Dio dio;

  TransactionAddRepository({required ApiHelper apiHelper})
      : dio = apiHelper.dio;

  Future<List<Bank>> fetchBanks() async {
    try {
      final response = await dio.get('/banks/all');
      final List<dynamic> data = response.data;
      logger.d('Banks loaded successfully');
      return data.map((bank) => Bank.fromJson(bank)).toList();
    } catch (e) {
      logger.e('Failed to load banks: $e');
      throw Exception('Failed to load banks: $e');
    }
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final response = await dio.get('/categories/all');
      // remove category id 0 before returning
      final List<dynamic> data =
          response.data.where((category) => category['id'] != 0).toList();
      logger.d('Categories loaded successfully');
      return data.map((category) => Category.fromJson(category)).toList();
    } catch (e) {
      logger.e('Failed to load categories: $e');
      throw Exception('Failed to load categories: $e');
    }
  }

  Future<void> addTransaction(CreateTransactionRequest transaction) async {
    try {
      await dio.post(
        '/transactions/create',
        data: transaction.toJson(),
      );
      logger.d('Transaction added successfully');
    } on DioException catch (e) {
      logger.e('Failed to add transaction: ${e.response?.data}');
      throw Exception('Failed to add transaction');
    }
  }

  Future<void> addTransfer(CreateTransferRequest transfer) async {
    try {
      await dio.post(
        '/banks/transfer',
        data: transfer.toJson(),
      );
      logger.d('Transfer added successfully');
    } on DioException catch (e) {
      logger.e('Failed to add transfer: ${e.response?.data}');
      throw Exception('Failed to add transfer');
    }
  }
}
