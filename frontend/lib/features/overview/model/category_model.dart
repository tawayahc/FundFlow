// features/categorized/models/category_model.dart
import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final String colorCode; // Hexadecimal color code as a string
  final double amount;

  CategoryModel({
    required this.id,
    required this.name,
    required this.colorCode,
    required this.amount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'],
      colorCode: json['color_code'],
      amount: (json['amount'] as num).toDouble(),
    );
  }

  /// Converts the hex color code string to a [Color] object.
  Color get color {
    // Remove the "0x" prefix if present
    String hex = colorCode.replaceAll("0x", "");
    // Ensure the string is 8 characters long (ARGB)
    if (hex.length == 6) {
      hex = "FF$hex"; // Add opaque alpha value
    }
    return Color(int.parse(hex, radix: 16));
  }
}
