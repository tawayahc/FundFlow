import 'package:equatable/equatable.dart';
import 'package:fundflow/features/overview/model/categorized_summary.dart';
import 'package:fundflow/features/overview/model/category_model.dart';

abstract class CategorizedState extends Equatable {
  const CategorizedState();

  @override
  List<Object?> get props => [];
}

class CategorizedInitial extends CategorizedState {}

class CategorizedLoading extends CategorizedState {}

class CategorizedLoaded extends CategorizedState {
  final List<CategoryModel> categories;
  final Map<String, CategorizedSummary> categorizedSummaries;

  const CategorizedLoaded({
    required this.categories,
    required this.categorizedSummaries,
  });

  @override
  List<Object?> get props => [categories, categorizedSummaries];
}

class CategorizedError extends CategorizedState {
  final String message;

  const CategorizedError({required this.message});

  @override
  List<Object?> get props => [message];
}