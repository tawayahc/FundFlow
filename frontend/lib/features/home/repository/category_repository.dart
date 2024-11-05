import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/category.dart';

class CategoryRepository {
  // This function simulates fetching data from an API or a local database
  Future<Map<String, dynamic>> getCategorys() async {
    // Simulating network delay
    await Future.delayed(Duration(seconds: 1));

    // Return mock data (you can replace this with API call)
    return {
      'cashBox': 17873.82,
      'categorys': [
        //use this color for food 41486D

        Category(
            category: 'ค่าอาหาร',
            amount: 10000.00,
            color: const Color(0xFF41486D)),
        Category(
            category: 'ค่าเดินทาง',
            amount: 2500.00,
            color: const Color(0xFFFF9595)),
        Category(
            category: 'ค่าของใช้',
            amount: 20000.00,
            color: const Color(0xFFFFB459)),
      ]
    };
  }
}
