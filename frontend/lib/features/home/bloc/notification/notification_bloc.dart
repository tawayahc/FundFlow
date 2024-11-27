import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/transaction/model/bank_model.dart';
import 'package:fundflow/features/transaction/model/create_transaction_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../transaction/model/transaction.dart';
import '../../../transaction/repository/transaction_repository.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import 'dart:convert';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final TransactionAddRepository _transactionRepository;

  NotificationBloc({required TransactionAddRepository transactionAddRepository})
      : _transactionRepository = transactionAddRepository,
        super(NotificationsLoading()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<UpdateNotification>(_onUpdateNotification);
    on<RemoveNotification>(_onRemoveNotification);
  }

  Future<void> _onLoadNotifications(
      LoadNotifications event, Emitter<NotificationState> emit) async {
    emit(NotificationsLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> storedNotifications =
          prefs.getStringList('notifications') ?? [];

      List<TransactionResponse> notifications =
          storedNotifications.map((jsonString) {
        final jsonMap = jsonDecode(jsonString);
        return TransactionResponse.fromJson(jsonMap);
      }).toList();

      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError(error: e.toString()));
    }
  }

  Future<void> _onUpdateNotification(
      UpdateNotification event, Emitter<NotificationState> emit) async {
    if (state is NotificationsLoaded) {
      final notifications = List<TransactionResponse>.from(
          (state as NotificationsLoaded).notifications);

      final index = notifications.indexWhere(
          (transaction) => transaction.metadata == event.transaction.metadata);

      if (index != -1) {
        notifications[index] = event.transaction;

        // Save updated notifications back to local storage
        await _saveNotificationsToLocalStorage(notifications);

        emit(NotificationsLoaded(notifications: notifications));
      }
    }
  }

  Future<void> _onRemoveNotification(
      RemoveNotification event, Emitter<NotificationState> emit) async {
    if (state is NotificationsLoaded) {
      final notifications = List<TransactionResponse>.from(
          (state as NotificationsLoaded).notifications);

      final transactionHash = event.transaction.transactionHash;
      final userBanks = await _transactionRepository.fetchBanks();

      notifications.removeWhere(
          (transaction) => transaction.transactionHash == transactionHash);

      // Save updated notifications back to local storage
      await _saveNotificationsToLocalStorage(notifications);

      emit(NotificationsLoaded(notifications: notifications));

      // Proceed to add the transaction
      try {
        final createTransactionRequest = CreateTransactionRequest(
          bankId: _getBankIdByName(event.transaction.bank, userBanks),
          type: event.transaction.type,
          amount: event.transaction.amount,
          categoryId: event.transaction.categoryId,
          createdAtDate: event.transaction.date!,
          createdAtTime: event.transaction.time,
          memo: event.transaction.memo,
          metadata: event.transaction.metadata,
        );

        await _transactionRepository.addTransaction(createTransactionRequest);
      } catch (e) {
        emit(NotificationsError(error: e.toString()));
      }
    }
  }

  Future<void> _saveNotificationsToLocalStorage(
      List<TransactionResponse> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> notificationsJson = notifications.map((transaction) {
      return jsonEncode(transaction.toJson());
    }).toList();

    await prefs.setStringList('notifications', notificationsJson);
  }
}

int _getBankIdByName(String bankName, List<Bank> userBanks) {
  final bank = userBanks.firstWhere(
    (bank) => bank.bankName.toLowerCase() == bankName.toLowerCase(),
    orElse: () => throw Exception('Bank not found: $bankName'),
  );
  return bank.id;
}
