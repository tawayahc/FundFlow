import 'package:equatable/equatable.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();

  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class BanksAndCategoriesLoaded extends TransactionState {
  final List<Bank> banks;
  final List<Category> categories;

  const BanksAndCategoriesLoaded(
      {required this.banks, required this.categories});

  @override
  List<Object> get props => [banks, categories];
}

class TransactionSuccess extends TransactionState {}

class TransactionFailure extends TransactionState {
  final String error;

  const TransactionFailure(this.error);

  @override
  List<Object> get props => [error];
}
