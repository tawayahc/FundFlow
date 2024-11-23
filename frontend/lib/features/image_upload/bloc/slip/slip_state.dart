import 'package:equatable/equatable.dart';
import 'package:fundflow/features/transaction/model/category_model.dart';

abstract class SlipState extends Equatable {
  const SlipState();

  @override
  List<Object?> get props => [];
}

class SlipInitial extends SlipState {}

class SlipLoading extends SlipState {}

class SlipSuccess extends SlipState {}

class SlipFailure extends SlipState {
  final String error;

  const SlipFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoriesLoaded extends SlipState {
  final List<Category> categories;

  const CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}
