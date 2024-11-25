// features/overview/bloc/overview_event.dart
import 'package:equatable/equatable.dart';
import 'package:fundflow/features/overview/model/summary.dart';

import '../../model/daily_summary.dart';
import '../../model/monthly_summary.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchTransactionsEvent extends OverviewEvent {}

class ApplyExpenseFiltersEvent extends OverviewEvent {
  final String? expenseType;
  final DateTime? startDate;
  final DateTime? endDate;

  const ApplyExpenseFiltersEvent({
    required this.expenseType,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [];
}