class CreateTransferRequest {
  final int fromBankId;
  final int toBankId;
  final double amount;
  final String createdAtDate;
  final String? createdAtTime;

  CreateTransferRequest({
    required this.fromBankId,
    required this.toBankId,
    required this.amount,
    required this.createdAtDate,
    this.createdAtTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'from_bank_id': fromBankId,
      'to_bank_id': toBankId,
      'amount': amount,
      'created_at_date': createdAtDate,
      'created_at_time': createdAtTime ?? '00:00:00',
    };
  }
}
