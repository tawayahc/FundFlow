import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final Color color;
  Category({required this.id, required this.name, required this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: _getColorFromJson(json['color_code']),
    );
  }
  static Color _getColorFromJson(dynamic colorValue) {
    return Color(int.parse(colorValue.replaceFirst('#', '0xFF')));
  }
}



