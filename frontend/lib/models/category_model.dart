import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final double amount;
  final Color color;

  Category({
    required this.id,
    required this.name,
    required this.amount,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    String colorString = json['color_code'];

    // Handle different color code formats
    if (colorString.startsWith('#')) {
      colorString = colorString.replaceFirst('#', '0xFF');
    } else if (colorString.startsWith('0x')) {
      // Ensure it's ARGB
      if (colorString.length == 7) {
        colorString = colorString.replaceFirst('0x', '0xFF');
      }
    } else {
      // Default to opaque if format is unexpected
      colorString = '0xFF$colorString';
    }

    return Category(
      id: json['id'],
      name: json['name'],
      amount: (json['amount'] as num).toDouble(),
      color: Color(int.parse(colorString)),
    );
  }

  Map<String, dynamic> toJson() {
    // Convert Color back to hex string
    String colorCode = color.value.toRadixString(16).padLeft(8, '0');
    // Remove alpha if not needed
    colorCode = '#${colorCode.substring(2)}';

    return {
      'id': id,
      'name': name,
      'amount': amount,
      'color_code': colorCode,
    };
  }
}
