// features/overview/bloc/overview_state.dart
import 'package:equatable/equatable.dart';
import '../../model/daily_summary.dart';
import '../../model/monthly_summary.dart';
import '../../model/summary.dart';

abstract class OverviewState extends Equatable {
  const OverviewState();

  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}

class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final Summary summary;
  final Map<DateTime, DailySummary> dailySummaries;
  final Map<DateTime, MonthlySummary> monthlySummaries;

  const OverviewLoaded({
    required this.summary,
    required this.dailySummaries,
    required this.monthlySummaries,
  });

  @override
  List<Object?> get props => [summary, dailySummaries, monthlySummaries];
}

class OverviewError extends OverviewState {
  final String message;

  const OverviewError({required this.message});

  @override
  List<Object?> get props => [message];
}
