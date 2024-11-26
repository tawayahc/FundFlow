import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/models/category.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final double width;
  final double height;
  final double fontSize;
  final double amountFontSize;

  const CategoryCard(
      {super.key,
      required this.category,
      this.width = double.infinity,
      this.height = 102.0, // Default height, adjust as needed
      this.fontSize = 12,
      this.amountFontSize = 16});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height, // Set height to make the card taller
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGrey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 15),
            height: 15,
            decoration: BoxDecoration(
              color: category.color,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 2),
            height: 2,
            decoration: BoxDecoration(
              color: category.color.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF414141)),
                ),
                Text(
                  '฿ ${formatter.format(category.amount)}', // No formatter needed
                  style: TextStyle(
                    fontSize: amountFontSize,
                    fontWeight: FontWeight.w600,
                    color: category.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryWhenDragging extends StatelessWidget {
  final double width;
  final double height;

  const CategoryWhenDragging({
    super.key,
    this.width = double.infinity,
    this.height = 90.0, // Default height, adjust as needed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }
}
