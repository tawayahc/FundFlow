import 'package:dio/dio.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/transaction.dart';
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
}
