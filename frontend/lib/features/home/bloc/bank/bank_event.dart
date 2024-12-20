// bank_event.dart

import 'package:fundflow/models/bank_model.dart';

abstract class BankEvent {}

class LoadBanks extends BankEvent {}

class LoadTransfers extends BankEvent {}

class AddBank extends BankEvent {
  final Bank bank;
  AddBank({required this.bank});
}

class EditBank extends BankEvent {
  final Bank originalBank;
  final Bank bank; // The bank with new details

  EditBank({required this.originalBank, required this.bank});
}

class DeleteBank extends BankEvent {
  final int bankId;

  DeleteBank({required this.bankId});
}
