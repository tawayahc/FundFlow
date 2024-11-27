import 'package:dio/dio.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/model/category_model.dart';
import 'package:fundflow/features/overview/model/transaction_all_model.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';
import 'package:fundflow/features/transaction/model/create_transfer_request.dart';
import 'package:fundflow/utils/api_helper.dart';
import '../model/transaction_model.dart';

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

  // Future<List<TransactionAllModel>> fetchTransactions() async {
  //   try {
  //     final response = await dio.get('/transactions/all');
  //     logger.d('API Response: ${response.data}');
  //     final List<dynamic> data = response.data;
  //     return data
  //         .map((transaction) => TransactionAllModel.fromJson(transaction))
  //         .toList();
  //   } catch (e) {
  //     logger.e('Failed to load transactions: $e');
  //     throw Exception('Failed to load transactions: $e');
  //   }
  // }
  Future<List<TransactionAllModel>> fetchOnlyExpense() async {
    try {
      // Fetch transactions
      final transactionsResponse = await dio.get('/transactions/all');
      final List<dynamic> transactionsData = transactionsResponse.data;

      // Fetch categories
      final categories = await fetchAllCategories();
      final categoryMap = {for (var cat in categories) cat.id: cat};

      // Combine transactions with category details, skipping categoryId 0 and missing categories
      return transactionsData
          .map<TransactionAllModel?>((transactionJson) {
            final categoryId = transactionJson['category_id'] ?? 0;
            if (categoryId == 0) {
              // Skip transactions with categoryId 0 (Uncategorized)
              return null;
            }
            final category = categoryMap[categoryId];
            if (category == null) {
              // If category not found, skip this transaction
              return null;
            }
            return TransactionAllModel.fromJson(transactionJson, category);
          })
          .whereType<TransactionAllModel>() // Filters out nulls
          .toList();
    } catch (e) {
      throw Exception('Failed to load combined transactions: $e');
    }
  }

  /// Fetches all transactions and combines them with category details,
  /// skipping transactions with categoryId 0 (Uncategorized) or missing categories.
  Future<List<TransactionAllModel>> fetchCombinedTransactions() async {
    try {
      // Fetch transactions
      final transactionsResponse = await dio.get('/transactions/all');
      final List<dynamic> transactionsData = transactionsResponse.data;

      // Fetch categories
      final categories = await fetchAllCategories();
      final categoryMap = {for (var cat in categories) cat.id: cat};

      // Define a default 'Income' category for income transactions without a valid categoryId
      final CategoryModel incomeCategory = CategoryModel(
        id: -1, // Assign a unique ID that doesn't conflict with existing categories
        name: 'Income',
        colorCode: '0xFF00FF00', // Green color for income
        amount: 0.0,
      );

      // Combine transactions with category details
      return transactionsData
          .map<TransactionAllModel?>((transactionJson) {
            final int? categoryId =
                transactionJson['category_id']; // Keep categoryId as nullable
            final String type =
                (transactionJson['type'] ?? '').toString().toLowerCase();

            if (type == 'income') {
              // Include income transactions regardless of categoryId
              return TransactionAllModel.fromJson(
                  transactionJson, incomeCategory);
            }

            if (categoryId == null || categoryId == 0) {
              // Skip non-income transactions with categoryId 0 or null
              return null;
            }

            final CategoryModel? category = categoryMap[categoryId];
            if (category == null) {
              // If category not found, skip this transaction
              return null;
            }

            return TransactionAllModel.fromJson(transactionJson, category);
          })
          .whereType<TransactionAllModel>() // Filters out nulls
          .toList();
    } catch (e) {
      throw Exception('Failed to load combined transactions: $e');
    }
  }

  /// Fetches all categories.
  Future<List<CategoryModel>> fetchAllCategories() async {
    try {
      final response =
          await dio.get('/categories/all'); // Adjust endpoint as needed
      final List<dynamic> data = response.data;
      return data
          .map<CategoryModel>(
              (categoryJson) => CategoryModel.fromJson(categoryJson))
          .toList();
    } catch (e) {
      throw Exception('Failed to load categories: $e');
    }
  }

  /// Optional: Fetches transactions filtered by category name.
  Future<List<TransactionAllModel>> fetchTransactionsByCategory(
      String categoryName) async {
    try {
      // Since you don't have a specific API endpoint for category filtering,
      // fetch all combined transactions and filter them locally.
      final allTransactions = await fetchCombinedTransactions();
      return allTransactions
          .where((tx) =>
              tx.categoryName.toLowerCase() == categoryName.toLowerCase())
          .toList();
    } catch (e) {
      throw Exception(
          'Failed to load transactions for category $categoryName: $e');
    }
  }

  /// Fetches transactions filtered by category name and date range.
  Future<List<TransactionAllModel>> fetchFilteredTransactions({
    required String? categoryName,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    try {
      // Fetch all combined transactions
      final allTransactions = await fetchCombinedTransactions();

      // Apply category filter if selected
      List<TransactionAllModel> filtered = allTransactions;
      if (categoryName != null && categoryName != "all") {
        filtered = filtered
            .where((tx) =>
                tx.categoryName.toLowerCase() == categoryName.toLowerCase())
            .toList();
      }

      // Apply date range filter if selected
      if (startDate != null && endDate != null) {
        filtered = filtered
            .where((tx) =>
        tx.createdAt
            .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
                tx.createdAt.isBefore(endDate.add(const Duration(days: 1))))
            .toList();
      }

      return filtered;
    } catch (e) {
      throw Exception('Failed to load filtered transactions: $e');
    }
  }

  Future<List<TransactionAllModel>> fetchExpenseFilteredTransactions({
    required String? expenseType,
    required DateTime? startDate,
    required DateTime? endDate,
  }) async {
    try {
      // Fetch all combined transactions
      final allTransactions = await fetchCombinedTransactions();

      // Apply category filter if selected
      List<TransactionAllModel> expenseFiltered = allTransactions;
      if (expenseType != null && expenseType == "income") {
        expenseFiltered = expenseFiltered
            .where((tx) =>
        tx.type.toLowerCase() == expenseType.toLowerCase())
            .toList();
      } else if (expenseType != null && expenseType == "expense") {
        expenseFiltered = expenseFiltered
            .where((tx) =>
        tx.type.toLowerCase() == expenseType.toLowerCase())
            .toList();
      }

      if (startDate != null && endDate != null) {
        expenseFiltered = expenseFiltered
            .where((tx) =>
        tx.createdAt
            .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
                tx.createdAt.isBefore(endDate.add(const Duration(days: 1))))
            .toList();
      }

      return expenseFiltered;
    } catch (e) {
      throw Exception('Failed to load filtered transactions: $e');
    }
  }
}
