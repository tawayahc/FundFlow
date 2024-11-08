import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/home/cash_box.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const CircularProgressIndicator();
        } else if (state is CategoriesLoaded) {
          return Column(
            children: [
              CashBox(cashBox: state.cashBox),
              const SizedBox(height: 10),
              ..._buildCategoryRows(state.categories),
            ],
          );
        } else if (state is CategoryError) {
          return const Text('Failed to load categories');
        } else {
          return const Text('Unknown error');
        }
      },
    );
  }

  // Function to group categories in pairs and return rows
  List<Widget> _buildCategoryRows(List<Category> categories) {
    List<Widget> rows = [];

    for (int i = 0; i < categories.length; i += 2) {
      List<Widget> rowChildren = [];

      // First card
      rowChildren.add(
        Expanded(
          child: CategoryCard(
            categoryName: categories[i].category,
            amount: categories[i].amount,
            color: categories[i].color, // Pass amount and color from category
          ),
        ),
      );

      // Second card or a spacer if only one card in the row
      if (i + 1 < categories.length) {
        rowChildren.add(const SizedBox(width: 10)); // Space between cards
        rowChildren.add(
          Expanded(
            child: CategoryCard(
              categoryName: categories[i + 1].category,
              amount: categories[i + 1].amount,
              color: categories[i + 1]
                  .color, // Pass amount and color from category
            ),
          ),
        );
      } else {
        rowChildren.add(const SizedBox(width: 10)); // Space for consistency
        rowChildren.add(
          const Spacer(), // Spacer to keep the single card at half width
        );
      }

      // Add the row with the two cards (or one card + spacer)
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rowChildren,
          ),
        ),
      );
    }

    return rows;
  }
}
