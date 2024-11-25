class Transfer {
  final int fromBankId;
  final String fromBankNickname;
  final String fromBankName;
  final int toBankId;
  final String toBankNickname;
  final String toBankName;
  final double amount;
  final String createdAt;

  Transfer({
    required this.fromBankId,
    required this.fromBankNickname,
    required this.fromBankName,
    required this.toBankId,
    required this.toBankNickname,
    required this.toBankName,
    required this.amount,
    required this.createdAt,
  });

  factory Transfer.fromJson(Map<String, dynamic> json) {
    return Transfer(
      fromBankId: json['from_bank_id'],
      fromBankNickname: json['from_bank_nickname'] ?? '',
      fromBankName: json['from_bank_name'],
      toBankId: json['to_bank_id'],
      toBankNickname: json['to_bank_nickname'] ?? '',
      toBankName: json['to_bank_name'],
      amount: (json['amount'] as num).toDouble(),
      createdAt: json['created_at'],
    );
  }
}
