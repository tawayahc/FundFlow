class CreateTransactionRequest {
  final int bankId;
  final String type;
  final double amount;
  final int? categoryId;
  final String createdAtDate;
  final String? createdAtTime;
  final String memo;

  CreateTransactionRequest({
    required this.bankId,
    required this.type,
    required this.amount,
    this.categoryId,
    required this.createdAtDate,
    this.createdAtTime,
    required this.memo,
  });

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'type': type,
      'amount': amount,
      'category_id': categoryId,
      'created_at_date': createdAtDate,
      'created_at_time': createdAtTime ?? '00:00:00',
      'memo': memo,
    };
  }
}
