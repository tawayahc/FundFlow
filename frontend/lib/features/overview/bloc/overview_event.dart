// features/overview/bloc/overview_event.dart
import 'package:equatable/equatable.dart';

abstract class OverviewEvent extends Equatable {
  const OverviewEvent();

  @override
  List<Object?> get props => [];
}

class FetchTransactionsEvent extends OverviewEvent {}
