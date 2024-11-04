import 'package:equatable/equatable.dart';
import '../model/transaction_model.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object> get props => [];
}

class AddTransactionEvent extends TransactionEvent {
  final Transaction transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}
