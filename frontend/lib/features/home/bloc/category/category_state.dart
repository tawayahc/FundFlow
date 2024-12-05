// category_state.dart
import 'package:fundflow/models/category_model.dart';

abstract class CategoryState {}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final double cashBox;
  final List<Category> categories;

  CategoriesLoaded({required this.cashBox, required this.categories});
}

class CategoryAdded extends CategoryState {}

class CategoryUpdated extends CategoryState {}

class CategoryDeleted extends CategoryState {}

class CategoryTransferred extends CategoryState {}

class CategoryAmountUpdated extends CategoryState {}

class CategoryError extends CategoryState {}
