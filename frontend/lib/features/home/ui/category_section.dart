import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/core/widgets/layout.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/home/cash_box.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
          // Optionally do something when the categories are loaded
          // like showing a snack bar or any other action
        } else if (state is CategoryError) {
          // Handle error state, show a SnackBar for example
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to load categories')),
          );
        }
      },
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          return Stack(
            children: [
              Column(
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: CashBox(cashBox: state.cashBox),
                  ),
                  const SizedBox(height: 10),
                  ..._buildCategoryRows(state.categories),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: CustomDraggableCashBox(cashBox: state.cashBox),
              ),
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
          child: CustomDraggableCategoryCard(
            category: categories[i],
          ),
        ),
      );

      // Second card or a spacer if only one card in the row
      if (i + 1 < categories.length) {
        rowChildren.add(const SizedBox(width: 10)); // Space between cards
        rowChildren.add(
          Expanded(
            child: CustomDraggableCategoryCard(
              category: categories[i + 1],
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
