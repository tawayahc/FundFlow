import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/home/models/transaction.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate =
        dateFormatter.format(DateTime.parse(transaction.createdAt));

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        String categoryName = 'No Memo';
        Color categoryColor = Colors.grey;

        // Fetch category details for expenses
        if (state is CategoriesLoaded &&
            isExpense &&
            transaction.categoryId != 0) {
          final category = state.categories.firstWhere(
            (cat) => cat.id == transaction.categoryId,
            orElse: () => Category(
              id: 0,
              name: 'No Category',
              amount: 0.0,
              color: Colors.grey,
            ),
          );
          categoryName = category.name;
          categoryColor = category.color;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.lightGrey), // Light border
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category Color Box (only for expenses)
                if (isExpense)
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                if (isExpense) const SizedBox(width: 12),
                // Memo and Category Name
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.memo.isNotEmpty
                            ? transaction.memo // Use Memo if available
                            : categoryName, // Otherwise, fallback to category name
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkGrey,
                        ),
                      ),
                      if (isExpense)
                        const SizedBox(
                            height: 4), // Space between memo and category
                      if (isExpense)
                        Text(
                          categoryName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF757575),
                          ),
                        ),
                    ],
                  ),
                ),
                // Amount and Date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '฿ ${transaction.amount.toString()}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF757575),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
