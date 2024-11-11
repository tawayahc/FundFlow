// bank_state.dart
import 'package:fundflow/features/home/models/bank.dart';

abstract class BankState {}

class BanksLoading extends BankState {}

class BanksLoaded extends BankState {
  final List<Bank> banks;

  BanksLoaded({required this.banks});
}

class BankAdded extends BankState {}

class BankUpdated extends BankState {}

class BankError extends BankState {}
