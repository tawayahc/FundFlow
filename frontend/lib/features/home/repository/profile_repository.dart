import 'package:dio/dio.dart';

import 'package:fundflow/app.dart';
import 'package:fundflow/models/bank_model.dart';

import 'package:fundflow/models/user_model.dart';
import 'package:fundflow/utils/api_helper.dart';

class ProfileRepository {
  final Dio dio;

  ProfileRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  Future<User> getUserProfile() async {
    try {
      final response = await dio.get('/profile');
      logger.d('Fetched user profile: ${response.data}');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      logger.e('Failed to fetch user profile: ${e.response?.data}');
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<Map<String, dynamic>> getCashBox() async {
    try {
      final response = await dio.get("/categories/all");

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;

        final cashBoxData =
            data.firstWhere((item) => item['id'] == 0, orElse: () => {});

        double cashBox = (cashBoxData['amount'] as num).toDouble();

        return {
          'cashBox': cashBox,
        };
      } else {
        logger.e('Failed to load categories ${response.data}');
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      logger.e('Error fetching categories: $error');
      throw Exception('Error fetching categories: $error');
    }
  }

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
}
