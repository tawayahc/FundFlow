// bank_state.dart
import 'package:fundflow/features/home/models/transfer.dart';
import 'package:fundflow/models/bank_model.dart';

abstract class BankState {}

class BanksLoading extends BankState {}

class BanksLoaded extends BankState {
  final List<Bank> banks;

  BanksLoaded({required this.banks});
}

class TransfersLoading extends BankState {}

class TransfersLoaded extends BankState {
  final List<Transfer> transfers;
  final List<Bank>? banks;

  TransfersLoaded({required this.transfers, this.banks});
}

class BankAdded extends BankState {}

class BankUpdated extends BankState {}

class BankDeleted extends BankState {}

class BankError extends BankState {}
