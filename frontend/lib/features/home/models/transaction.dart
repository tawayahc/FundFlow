class Transaction {
  final int id;
  final String type;
  final double amount;
  final int bankId;
  final String bankNickname;
  final String bankName;
  final int categoryId;
  final String? metaData;
  final String memo;
  final String createdAt;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.bankId,
    required this.bankNickname,
    required this.bankName,
    required this.categoryId,
    this.metaData,
    required this.memo,
    required this.createdAt,
  });
}
