import 'package:dio/dio.dart';
import '../model/transaction_model.dart';

class TransactionRepository {
  final Dio dio;

  TransactionRepository({required this.dio});

  Future<void> addTransaction(Transaction transaction) async {
    try {
      await dio.post('/transactions', data: {
        'userId': transaction.userId,
        'amount': transaction.amount,
        'category': transaction.category,
        'note': transaction.note,
        'date': transaction.date.toIso8601String(),
      });
      print("Transaction added successfully : $transaction");
    } catch (e) {
      print('Failed to add transaction: $e');
      throw Exception('Failed to add transaction: $e');
    }
  }
}
