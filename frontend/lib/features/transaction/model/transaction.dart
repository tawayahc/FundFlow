class TransactionResponse {
  final String bank;
  final String type;
  final double amount;
  final int category;
  final String date;
  final String time;
  final String memo;

  TransactionResponse({
    required this.bank,
    required this.type,
    required this.amount,
    required this.category,
    required this.date,
    required this.time,
    required this.memo,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) {
    return TransactionResponse(
      bank: json['bank'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      category: json['category'],
      date: json['date'],
      time: json['time'],
      memo: json['memo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bank': bank,
      'type': type,
      'amount': amount,
      'category': category,
      'date': date,
      'time': time,
      'memo': memo,
    };
  }
}
