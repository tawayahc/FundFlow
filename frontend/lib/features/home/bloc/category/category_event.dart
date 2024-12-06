import 'package:fundflow/models/category_model.dart';

abstract class CategoryEvent {}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final Category category; // Accept the Category object

  AddCategory({required this.category});
}

class EditCategory extends CategoryEvent {
  final Category originalCategory;
  final Category category; // The category with new details

  EditCategory({required this.originalCategory, required this.category});
}

class DeleteCategory extends CategoryEvent {
  final int categoryId;

  DeleteCategory({required this.categoryId});
}

class TransferAmount extends CategoryEvent {
  final int fromCategoryId;
  final int toCategoryId;
  final double amount;

  TransferAmount(
      {required this.fromCategoryId,
      required this.toCategoryId,
      required this.amount});
}

class UpdateAmount extends CategoryEvent {
  final int categoryId;
  final double newAmount;

  UpdateAmount({required this.categoryId, required this.newAmount});
}
