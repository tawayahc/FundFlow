import 'package:equatable/equatable.dart';
import '../../../transaction/model/transaction_reponse.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationsLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<TransactionResponse> notifications;

  const NotificationsLoaded({required this.notifications});

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationState {
  final String error;

  const NotificationsError({required this.error});

  @override
  List<Object?> get props => [error];
}
