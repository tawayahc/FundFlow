import 'package:dio/dio.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:fundflow/features/home/models/transfer.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/utils/api_helper.dart';

class BankRepository {
  final Dio dio;

  BankRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  Future<Map<String, dynamic>> getBanks() async {
    try {
      final response = await dio.get("/banks/all");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final banks = data
            .map((item) => Bank(
                id: item['id'],
                name: item['name'],
                bankName: item['bank_name'],
                amount: (item['amount'] as num).toDouble()))
            .toList();
        return {'banks': banks};
      } else {
        logger.e('Failed to load banks ${response.data}');
        throw Exception('Failed to load banks');
      }
    } catch (error) {
      logger.e('Error fetching banks: $error');
      throw Exception('Error fetching banks: $error');
    }
  }

  Future<List<Transfer>> getTransfers() async {
    try {
      final response = await dio.get("/banks/transfer");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final transfers = data.map((item) => Transfer.fromJson(item)).toList();
        return transfers;
      } else {
        throw Exception('Failed to load transfers: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching transfers: $error');
    }
  }

  // Add a new bank to the server
  Future<void> addBank(Bank bank) async {
    try {
      final response = await dio.post("/banks/create", data: {
        'name': bank.name,
        'bank_name': bank.bankName,
        'amount': bank.amount,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to add bank, Response: ${response.data}');
        throw Exception('Failed to add bank');
      }
    } catch (error) {
      logger.e('Error adding bank: $error');
      throw Exception('Error adding bank: $error');
    }
  }

  Future<void> editBank(Bank originalBank, Bank bank) async {
    try {
      logger.i('Editing bank: ${bank.amount} ${bank.name} ${bank.bankName}');
      logger.i(
          'Edit original bank: ${originalBank.amount} ${originalBank.name} ${originalBank.bankName} ');

      // Initialize the payload
      Map<String, dynamic> data = {};

      // Check for changes and add to data if necessary
      if (bank.name != originalBank.name) {
        data['new_name'] = bank.name;
      }
      if (bank.amount != originalBank.amount) {
        data['new_amount'] = bank.amount;
      }
      if (bank.bankName != originalBank.bankName) {
        data['new_bank_name'] = bank.bankName;
      }

      // If nothing has changed, we can skip the API call
      if (data.isEmpty) {
        logger.i('No changes to update');
        return;
      }

      // Send the request with the updated data
      final response = await dio.put(
        "/banks/${bank.id}",
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to edit bank, Response: ${response.data}');
        throw Exception('Failed to edit bank');
      }
    } catch (error) {
      // Detailed error logging
      if (error is DioException) {
        logger.e('Dio Error: ${error.response?.data ?? error.message}');
      } else {
        logger.e('Error editing bank: $error');
      }
      throw Exception('Error editing bank: $error');
    }
  }

  Future<void> deleteBank(int bankId) async {
    try {
      final response = await dio.delete("/banks/$bankId");

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to delete bank, Response: ${response.data}');
        throw Exception('Failed to delete bank');
      }
    } catch (error) {
      logger.e('Error deleting bank: $error');
      throw Exception('Error deleting bank: $error');
    }
  }

  Future<Map<String, List<Transaction>>> getBankTransactions(int bankId) async {
    try {
      final response = await dio.get("/banks/$bankId");

      if (response.statusCode == 200) {
        // Ensure response data is parsed correctly
        final Map<String, dynamic> data = response.data;

        if (data.containsKey('transactions') && data['transactions'] is List) {
          final List<dynamic> transactionsData = data['transactions'];

          final bankTransactions = transactionsData
              .map((item) => Transaction(
                    id: item['id'],
                    bankId: item['bank_id'],
                    amount: (item['amount'] as num).toDouble(),
                    memo: item['memo'],
                    type: item['type'],
                    categoryId: item['category_id'] ?? 0,
                    bankNickname: item['bank_nickname'],
                    bankName: item['bank_name'],
                    createdAt: item['created_at'],
                  ))
              .toList();

          return {
            'transactions': bankTransactions,
          };
        } else {
          throw Exception('Invalid transactions format in response');
        }
      } else {
        logger.e('Failed to load banks: ${response.data}');
        throw Exception('Failed to load banks');
      }
    } catch (error) {
      logger.e('Error fetching banks: $error');
      throw Exception('Error fetching banks: $error');
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
