import 'package:flutter/foundation.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:fundflow/features/home/models/transaction.dart';

abstract class OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final List<Bank> banks;
  final List<Category> category;
  final List<Transaction> transaction;

  OverviewLoaded({required this.banks, required this.category, required this.transaction});
}

class OverviewLoadError extends OverviewState {}