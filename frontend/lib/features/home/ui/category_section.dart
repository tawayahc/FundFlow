import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/home/cash_box.dart';
import 'package:fundflow/features/manageCategory/ui/category_page.dart';

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
          double screenWidth = MediaQuery.of(context).size.width;
          double horizontalPadding =
              16.0 * 2; // Assuming 16 padding on each side
          double cashBoxWidth = (screenWidth - horizontalPadding);
          return Stack(
            children: [
              Column(
                children: [
                  Draggable(
                      feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                              child: CashBox(
                                  cashBox: state.cashBox,
                                  width: cashBoxWidth - 50))),
                      childWhenDragging: const CashBoxWhenDragging(),
                      child:
                          CashBox(cashBox: state.cashBox, width: cashBoxWidth)),
                  const SizedBox(height: 10),
                  ..._buildCategoryRows(context, state.categories),
                ],
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
  List<Widget> _buildCategoryRows(
      BuildContext context, List<Category> categories) {
    List<Widget> rows = [];

    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = 16.0 * 2;
    double spacingBetweenCards = 10.0;
    double cardWidth =
        (screenWidth - horizontalPadding - spacingBetweenCards) / 2;

    for (int i = 0; i < categories.length; i += 2) {
      List<Widget> rowChildren = [];

      // First card
      rowChildren.add(
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPage(category: categories[i]),
                ),
              );
            },
            child: Draggable(
              feedback: Material(
                color: Colors.transparent,
                child: SizedBox(
                  child: CategoryCard(
                    category: categories[i],
                    width: cardWidth - 25,
                  ),
                ),
              ),
              childWhenDragging: const CategoryWhenDragging(),
              child: CategoryCard(
                category: categories[i],
                width: cardWidth,
              ),
            ),
          ),
        ),
      );

      // Second card or a spacer if only one card in the row
      if (i + 1 < categories.length) {
        rowChildren.add(const SizedBox(width: 10)); // Space between cards
        rowChildren.add(
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryPage(category: categories[i + 1]),
                  ),
                );
              },
              child: Draggable(
                feedback: Material(
                  color: Colors.transparent,
                  child: SizedBox(
                    child: CategoryCard(
                      category: categories[i + 1],
                      width: cardWidth - 25,
                    ),
                  ),
                ),
                childWhenDragging: const CategoryWhenDragging(),
                child: CategoryCard(
                  category: categories[i + 1],
                  width: cardWidth,
                ),
              ),
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
