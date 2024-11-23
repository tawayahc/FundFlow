class Notification {
  final String bankName;
  final String type;
  final double amount;
  final int categoryId;
  final String date;
  final String time;
  final String memo;

  Notification({
    required this.bankName,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.date,
    required this.time,
    required this.memo,
  });

  /// Convert Notification to JSON
  Map<String, dynamic> toJson() {
    return {
      'bankName': bankName,
      'type': type,
      'amount': amount,
      'categoryId': categoryId,
      'date': date,
      'time': time,
      'memo': memo,
    };
  }

  /// Create Notification from JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      bankName: json['bankName'],
      type: json['type'],
      amount: json['amount'],
      categoryId: json['categoryId'],
      date: json['date'],
      time: json['time'],
      memo: json['memo'],
    );
  }
}
