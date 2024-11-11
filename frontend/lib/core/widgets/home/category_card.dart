import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/global_padding.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
            height: 10,
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
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                Text(
                  '฿ ${formatter.format(category.amount)}',
                  style: TextStyle(
                    fontSize: 16,
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

class CustomDraggableCategoryCard extends StatefulWidget {
  final Category category;

  const CustomDraggableCategoryCard({
    super.key,
    required this.category,
  });

  @override
  _CustomDraggableCategoryCardState createState() =>
      _CustomDraggableCategoryCardState();
}

class _CustomDraggableCategoryCardState
    extends State<CustomDraggableCategoryCard> {
  Offset position = Offset.zero; // Initial position

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Update position based on the drag details
          position += details.delta;
        });
      },
      onPanEnd: (details) {
        // Reset position to initial position when dragging ends
        setState(() {
          position = Offset.zero;
        });
      },
      child: Transform.translate(
        offset: position,
        child: CategoryCard(
          category: widget.category,
        ),
      ),
    );
  }
}
