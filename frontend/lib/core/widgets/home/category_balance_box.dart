import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:intl/intl.dart'; // Import intl package

class CategoryBalanceBox extends StatelessWidget {
  final Color color; // Main color for the lines
  final Category category;
  final String date;

  const CategoryBalanceBox({
    super.key,
    required this.color,
    required this.category,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    // Create a formatter for the currency with commas and two decimals
    final currencyFormatter = NumberFormat("#,##0.00", "en_US");

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.only(
          top: 20, bottom: 16), // Remove horizontal padding
      decoration: BoxDecoration(
          color: Colors.white, // Background color
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Subtle shadow color
              offset: const Offset(0, 0), // Centered shadow
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
          borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Top bar (thicker solid line)
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 15, // Height of the first bar
                  color: color, // Matches the category color
                ),
              ),
            ],
          ),
          const SizedBox(height: 3), // Space between the two lines

          // Second thin line with lighter opacity
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 2, // Height of the second line
                  color: color.withOpacity(0.5), // Semi-transparent line
                ),
              ),
            ],
          ),

          // Spacing below the lines
          const SizedBox(height: 16),

          // Centered amount text
          Text(
            '฿ ${currencyFormatter.format(category.amount)}', // Format with commas
            style: const TextStyle(
              color: AppColors.darkGrey, // Text color
              fontSize: 24, // Font size for amount
              fontWeight: FontWeight.normal,
            ),
          ),
          const SizedBox(height: 16), // Space below the amount
        ],
      ),
    );
  }
}
