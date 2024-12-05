import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/home/category_card.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/core/widgets/home/cash_box.dart';
import 'package:fundflow/features/home/pages/category/transfer_category_amount.dart';
import 'package:fundflow/features/home/pages/category/category_page.dart';

class CategorySection extends StatelessWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state is CategoriesLoaded) {
        } else if (state is CategoryError) {}
      },
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          double screenWidth = MediaQuery.of(context).size.width;
          double horizontalPadding =
              16.0 * 2; // Assuming 16 padding on each side
          double cashBoxWidth = (screenWidth - horizontalPadding);

          List<Category> sortedCategories = List.from(state.categories)
            ..sort((a, b) => a.id.compareTo(b.id));
          return Stack(
            children: [
              Column(
                children: [
                  DragTarget<Category>(
                    onAcceptWithDetails: (fromCategory) {
                      if (fromCategory.data.id != -1) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TransferCategoryAmount(
                              fromCategory: fromCategory.data,
                              toCategory: Category(
                                  id: -1,
                                  name: 'CashBox',
                                  amount: state.cashBox,
                                  color: AppColors.darkGrey),
                            );
                          },
                        );
                      }
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Draggable(
                        feedback: Material(
                          color: Colors.transparent,
                          child: SizedBox(
                            child: CashBox(
                              cashBox: state.cashBox,
                              width: cashBoxWidth - 50,
                            ),
                          ),
                        ),
                        childWhenDragging: const CashBoxWhenDragging(),
                        data: Category(
                            id: -1,
                            name: 'CashBox',
                            amount: state.cashBox,
                            color: AppColors.darkGrey),
                        child: CashBox(
                            cashBox: state.cashBox, width: cashBoxWidth),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ..._buildCategoryRows(context, sortedCategories),
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

      // First card with DragTarget
      rowChildren.add(
        Expanded(
          child: DragTarget<Category>(
            onAcceptWithDetails: (draggedCategory) {
              if (draggedCategory.data.id != categories[i].id) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TransferCategoryAmount(
                      fromCategory: draggedCategory.data,
                      toCategory: categories[i],
                    );
                  },
                );
              }
            },
            builder: (context, candidateData, rejectedData) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CategoryPage(category: categories[i])),
                  );
                },
                child: Draggable<Category>(
                  data: categories[i],
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
              );
            },
          ),
        ),
      );

      // Second card or a spacer if only one card in the row
      if (i + 1 < categories.length) {
        rowChildren.add(const SizedBox(width: 12)); // Space between cards
        rowChildren.add(
          Expanded(
            child: DragTarget<Category>(
              onAcceptWithDetails: (draggedCategory) {
                if (draggedCategory.data.id != categories[i + 1].id) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return TransferCategoryAmount(
                        fromCategory: draggedCategory.data,
                        toCategory: categories[i + 1],
                      );
                    },
                  );
                }
              },
              builder: (context, candidateData, rejectedData) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CategoryPage(category: categories[i + 1])),
                    );
                  },
                  child: Draggable<Category>(
                    data: categories[i + 1],
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
                );
              },
            ),
          ),
        );
      } else {
        rowChildren.add(const SizedBox(width: 10));
        rowChildren.add(const Spacer());
      }

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
