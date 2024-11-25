import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
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
        String categoryName = 'undefined';
        if (state is CategoriesLoaded) {
          // Only set "undefined" for expenses with invalid or missing categoryId
          if (isExpense && transaction.categoryId != 0) {
            final category = state.categories.firstWhere(
              (cat) => cat.id == transaction.categoryId,
              orElse: () => Category(
                id: 0,
                name: 'undefined',
                amount: 0.0,
                color: Colors.grey,
              ),
            );
            categoryName = category.name;
          } else if (!isExpense) {
            categoryName = ''; // Do not show "undefined" for incomes
          }
        }

        final categoryColor = (isExpense && categoryName == 'undefined')
            ? const Color(0xFFFF5C5C)
            : Colors.grey;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.memo.isNotEmpty ? transaction.memo : '',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: (isExpense && categoryName == 'undefined')
                            ? const Color(0xFFFF5C5C)
                            : AppColors.darkGrey,
                      ),
                    ),
                    Text(
                      formatter.format(transaction.amount),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: (isExpense && categoryName == 'undefined')
                            ? categoryColor
                            : isExpense
                                ? Colors.red
                                : Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      categoryName.isNotEmpty ? categoryName : '',
                      style: TextStyle(fontSize: 14, color: categoryColor),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14, color: categoryColor),
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
