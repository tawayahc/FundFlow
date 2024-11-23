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

  factory CreateTransactionRequest.fromJson(Map<String, dynamic> json) {
    return CreateTransactionRequest(
      bankId: json['bank_id'],
      type: json['type'],
      amount: json['amount'].toDouble(),
      categoryId: json['category_id'],
      createdAtDate: json['created_at_date'],
      createdAtTime: json['created_at_time'],
      memo: json['memo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank_id': bankId,
      'type': type,
      'amount': amount,
      'category_id': categoryId,
      'created_at_date': createdAtDate,
      'created_at_time': createdAtTime,
      'memo': memo,
    };
  }
}
