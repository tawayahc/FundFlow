class TransactionResponse {
  final String metadata;
  final String bank;
  final String type;
  final double amount;
  final int categoryId;
  final String date;
  final String time;
  final String memo;

  TransactionResponse({
    required this.metadata,
    required this.bank,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.time,
    required this.memo,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      metadata: json['metadata'] as String,
      bank: json['bank'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      categoryId: json['category_id'] as int,
      date: json['date'] as String,
      time: json['time'] as String,
      memo: json['memo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'metadata': metadata,
      'bank': bank,
      'type': type,
      'amount': amount,
      'category_id': categoryId,
      'date': date,
      'time': time,
      'memo': memo,
    };
  }
}
