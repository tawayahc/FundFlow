import 'package:fundflow/features/home/models/bank.dart' as HomeBank;
import 'package:fundflow/features/transaction/model/bank_model.dart'
    as TransactionBank;

class BankMapper {
  static TransactionBank.Bank toTransactionBank(HomeBank.Bank homeBank) {
    return TransactionBank.Bank(
      id: homeBank.id,
      name: homeBank.name,
      bankName: homeBank.bank_name,
    );
  }

  static HomeBank.Bank toHomeBank(TransactionBank.Bank transactionBank,
      {double amount = 0.0}) {
    return HomeBank.Bank(
      id: transactionBank.id,
      name: transactionBank.name,
      bank_name: transactionBank.bankName,
      amount: amount, // Provide a default or real value
    );
  }
}
