import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/bank.dart';

class BankRepository {
  final Dio dio;
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final String baseUrl;

  BankRepository({required this.baseUrl})
      : dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
          },
        )) {
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    String? token = await storage.read(key: 'token');
    if (token != null) {
      dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  Future<Map<String, dynamic>> getBanks() async {
    try {
      final response = await dio.get("/banks/all");
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final banks = data
            .map((item) => Bank(
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
      await _initializeToken();

      final response = await dio.post("/banks/create", data: {
        'name': bank.name,
        'bank_name': bank.bank_name,
        'amount': bank.amount,
      });

      if (response.statusCode != 200 && response.statusCode != 201) {
        logger.e('Failed to add category, Response: ${response.data}');
        throw Exception('Failed to add category');
      }
    } catch (error) {
      logger.e('Error adding bank: $error');
      throw Exception('Error adding bank: $error');
    }
  }
}
