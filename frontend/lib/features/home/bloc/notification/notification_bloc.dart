import 'package:bloc/bloc.dart';
import 'package:fundflow/features/home/bloc/notification/notification_event.dart';
import 'package:fundflow/features/home/bloc/notification/notification_state.dart';
import 'package:fundflow/features/home/repository/notification_repository.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc({required this.notificationRepository})
      : super(NotificationsLoading()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationsLoading());
      try {
        final data = await notificationRepository.getNotifications();
        emit(NotificationsLoaded(notifications: data['notifications']));
      } catch (error) {
        emit(NotificationsLoadError("Failed to load notification history"));
      }
    });
  }
}
