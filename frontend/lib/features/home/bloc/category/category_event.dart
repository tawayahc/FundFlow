// category_event.dart
import 'package:flutter/material.dart';

abstract class CategoryEvent {}

class LoadCategorys extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String categoryName;
  final double amount;
  final Color color;

  AddCategory({
    required this.categoryName,
    required this.amount,
    required this.color,
  });
}
