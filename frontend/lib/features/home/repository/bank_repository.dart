import 'package:dio/dio.dart';
import 'package:fundflow/features/home/models/bank.dart';

class BankRepository {
  final Dio _dio = Dio();
  final String apiUrl = 'http://10.0.2.2:3000/api/banks';

  // Fetch all banks from the API and return List<Bank>
  Future<List<Bank>> getBanks() async {
    try {
      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        // Parse JSON data into List<Bank>
        final List<dynamic> data = response.data;
        return data.map((item) => Bank.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load banks');
      }
    } catch (error) {
      throw Exception('Error fetching banks: $error');
    }
  }

  // Add a new bank to the server
  Future<void> addBank(Bank bank) async {
    try {
      final response = await _dio.post(apiUrl, data: {
        'name': bank.name,
        'bank_name': bank.bank_name,
        'amount': bank.amount,
      });

      if (response.statusCode != 201) {
        throw Exception('Failed to add bank');
      }
    } catch (error) {
      throw Exception('Error adding bank: $error');
    }
  }
}
