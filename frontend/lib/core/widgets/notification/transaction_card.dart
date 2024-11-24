import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/models/transaction.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        String categoryName = 'undefined';

        // Find category name if state is loaded and it's an expense
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
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Memo and Amount in the same row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction.memo.isNotEmpty
                          ? transaction.memo // Display memo if available
                          : categoryName, // Display categoryName if memo is empty
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414141),
                      ),
                    ),
                    Text(
                      '฿ ${transaction.amount.toString()}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414141),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8), // Space between rows

                // Timeline/Date aligned to the right
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end, // Align to the right
                  children: [
                    Text(
                      transaction.createdAt,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF5A5A5A),
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
