import 'package:equatable/equatable.dart';
import '../../../transaction/model/transaction.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class UpdateNotification extends NotificationEvent {
  final TransactionResponse transaction;

  const UpdateNotification({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}

class RemoveNotification extends NotificationEvent {
  final TransactionResponse transaction;

  const RemoveNotification({required this.transaction});

  @override
  List<Object?> get props => [transaction];
}
