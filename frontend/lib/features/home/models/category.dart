import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final double amount;
  final Color color;

  Category(
      {required this.id,
      required this.name,
      required this.amount,
      required this.color});
}
