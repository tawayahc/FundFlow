// model/transaction_model.dart
class Transaction {
  final String userId;
  final String type; // 'income', 'expense', 'transfer'
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  Transaction({
    required this.userId,
    required this.type,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  // Optional: Methods for JSON serialization/deserialization if needed
}
