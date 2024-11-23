import 'package:flutter/material.dart';

class CategorizedSummary {
  final String category;
  double totalIncome;
  double totalExpense;
  final Color categoryColor; // Added

  CategorizedSummary({
    required this.category,
    required this.totalIncome,
    required this.totalExpense,
    required this.categoryColor,
  });
}
