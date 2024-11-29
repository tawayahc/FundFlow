import 'package:dio/dio.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/home/models/notification.dart';
import 'package:fundflow/utils/api_helper.dart';
import 'package:intl/intl.dart';

class NotificationRepository {
  final Dio dio;

  NotificationRepository({required ApiHelper apiHelper}) : dio = apiHelper.dio;

  Future<Map<String, dynamic>> getNotifications() async {
    try {
      final response = await dio.get("/transactions/all");
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;

        final notifications = data.map((item) {
          final createdAt = item['created_at'];

          DateTime dateTime;
          if (createdAt.contains('+')) {
            dateTime = DateTime.parse(createdAt);
          } else {
            dateTime = DateTime.parse(createdAt.replaceAll(' ', 'T'));
          }

          final intermediateDate = DateFormat('dd MMM yyyy').format(dateTime);

          final parsedIntermediateDate =
              DateFormat('dd MMM yyyy').parse(intermediateDate);

          final finalFormattedDate =
              DateFormat('dd/MM/yy').format(parsedIntermediateDate);

          final intermediateTime = DateFormat('hh:mm a').format(dateTime);

          final parsedIntermediateTime =
              DateFormat('hh:mm a').parse(intermediateTime);

          final formattedTime =
              DateFormat('HH:mm').format(parsedIntermediateTime).toLowerCase();

          logger.d('Fetched Notifications: $finalFormattedDate $formattedTime');

          return Notification(
            bankName: item['bank_name'],
            type: item['type'],
            amount: (item['amount'] as num).toDouble(),
            categoryId: item['category_id'] ?? -1,
            date: finalFormattedDate,
            time: formattedTime,
            memo: item['memo'],
          );
        }).toList();
        return {
          'notifications': notifications,
        };
      } else {
        logger.e('Failed to load Notifications ${response.data}');
        throw Exception('Failed to load Notifications');
      }
    } catch (error) {
      logger.e('Error fetching Notifications: $error');
      throw Exception('Error fetching Notifications: $error');
    }
  }
}
