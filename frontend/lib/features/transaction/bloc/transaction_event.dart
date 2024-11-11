import 'package:equatable/equatable.dart';
import '../model/create_transfer_request.dart';
import '../model/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class FetchBanksAndCategories extends TransactionEvent {}

class AddTransactionEvent extends TransactionEvent {
  final CreateTransactionRequest transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class AddTransferEvent extends TransactionEvent {
  final CreateTransferRequest request;

  const AddTransferEvent(this.request);

  @override
  List<Object> get props => [request];
}
