import 'package:fundflow/features/home/models/category.dart';

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
