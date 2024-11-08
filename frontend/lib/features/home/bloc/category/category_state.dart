// category_state.dart
import 'package:fundflow/features/home/models/category.dart';

abstract class CategoryState {}

class CategorysLoading extends CategoryState {}

class CategorysLoaded extends CategoryState {
  final double cashBox;
  final List<Category> categorys;

  CategorysLoaded({required this.cashBox, required this.categorys});
}

class CategoryError extends CategoryState {}
