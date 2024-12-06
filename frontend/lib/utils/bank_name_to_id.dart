import 'package:fundflow/models/bank_model.dart';

int _getBankIdByName(String bankName, List<Bank> userBanks) {
  final bank = userBanks.firstWhere(
    (bank) => bank.bankName.toLowerCase() == bankName.toLowerCase(),
    orElse: () => throw Exception('Bank not found: $bankName'),
  );
  return bank.id;
}
