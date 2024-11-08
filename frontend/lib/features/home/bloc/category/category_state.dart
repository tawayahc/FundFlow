// category_state.dart
import 'package:fundflow/features/home/models/category.dart';

abstract class CategoryState {}

class CategoriesLoading extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  final double cashBox;
  final List<Category> categories;

  CategoriesLoaded({required this.cashBox, required this.categories});
}

class CategoryError extends CategoryState {}
