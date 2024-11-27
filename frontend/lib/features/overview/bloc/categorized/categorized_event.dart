import 'package:equatable/equatable.dart';

abstract class CategorizedEvent extends Equatable {
  const CategorizedEvent();

  @override
  List<Object?> get props => [];
}

class FetchCategorizedTransactionsEvent extends CategorizedEvent {}

class ApplyFiltersEvent extends CategorizedEvent {
  final String? categoryName;
  final DateTime? startDate;
  final DateTime? endDate;

  const ApplyFiltersEvent({
    this.categoryName,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [categoryName, startDate, endDate];
}
