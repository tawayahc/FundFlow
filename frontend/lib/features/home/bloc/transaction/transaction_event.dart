abstract class TransactionEvent {}

class LoadTransactions extends TransactionEvent {}

class DeleteTransaction extends TransactionEvent {
  final int transactionId;

  DeleteTransaction({required this.transactionId});
}
