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
}
