import 'package:fundflow/features/home/models/transaction.dart';

abstract class TransactionState {}

class TransactionsLoading extends TransactionState {}

class TransactionsLoaded extends TransactionState {
  final List<Transaction> transactions;

  TransactionsLoaded({required this.transactions});
}

class TransactionsLoadError extends TransactionState {
  final String message;

  TransactionsLoadError(this.message);
}
