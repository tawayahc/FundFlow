class Transaction {
  final double amount;
  final String category;
  final String memo;
  final String? date;

  Transaction({required this.amount, required this.category, required this.memo, this.date});
}