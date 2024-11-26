import 'package:fundflow/features/home/models/notification.dart';

abstract class NotificationState {}

class NotificationsLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<Notification> notifications;

  NotificationsLoaded({required this.notifications});
}

class NotificationsLoadError extends NotificationState {
  final String message;

  NotificationsLoadError(this.message);
}
