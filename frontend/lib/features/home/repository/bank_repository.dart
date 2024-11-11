import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/bank.dart';
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
                bank_name: item['bank_name'],
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

  // Add a new bank to the server
  Future<void> addBank(Bank bank) async {
    try {
      final response = await dio.post("/banks/create", data: {
        'name': bank.name,
        'bank_name': bank.bank_name,
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
      logger.i('Editing bank: ${bank.amount} ${bank.name} ${bank.bank_name}');
      logger.i(
          'Edit original bank: ${originalBank.amount} ${originalBank.name} ${originalBank.bank_name} ');

      // Initialize the payload
      Map<String, dynamic> data = {};

      // Check for changes and add to data if necessary
      if (bank.name != originalBank.name) {
        data['new_name'] = bank.name;
      }
      if (bank.amount != originalBank.amount) {
        data['new_amount'] = bank.amount;
      }
      if (bank.bank_name != originalBank.bank_name) {
        data['new_bank_name'] = bank.bank_name;
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
}
