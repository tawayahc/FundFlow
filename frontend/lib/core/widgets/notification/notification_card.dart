import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/transaction/model/transaction_reponse.dart';

class NotificationCard extends StatelessWidget {
  final TransactionResponse transaction;

  const NotificationCard({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';
    bool isUnread = !transaction.isRead;
    logger.d('Building NotificationCard: isRead = ${transaction.isRead}');

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        String categoryName = 'ไม่มีหมวดหมู่';
        Color categoryColor = Colors.grey;

        if (transaction.categoryId != -1 && state is CategoriesLoaded) {
          final category = state.categories.firstWhere(
            (cat) => cat.id == transaction.categoryId,
            orElse: () => Category(
              id: -1,
              name: 'ไม่มีหมวดหมู่',
              amount: 0.0,
              color: Colors.grey,
            ),
          );
          categoryName = category.name;
          categoryColor = category.color;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isUnread ? Colors.blue[50] : Colors.white,
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12),

                // Text and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.memo != null && transaction.memo!.isNotEmpty
                            ? transaction.memo!
                            : 'No Memo',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isUnread ? FontWeight.bold : FontWeight.normal,
                          color: const Color(0xFF414141),
                        ),
                      ),
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount and date
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '฿ ${transaction.amount.toString()}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isUnread ? FontWeight.bold : FontWeight.normal,
                        color: const Color(0xFF414141),
                      ),
                    ),
                    Text(
                      transaction.date ?? 'ไม่มีวันที่',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.lightBlack,
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
