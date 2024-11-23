import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';
import 'package:fundflow/features/home/bloc/category/category_bloc.dart';
import 'package:fundflow/features/home/bloc/category/category_state.dart';
import 'package:fundflow/features/home/models/category.dart';
import 'package:fundflow/features/home/models/notification.dart' as fundflow;

class NotificationCard extends StatelessWidget {
  final fundflow.Notification notification;

  const NotificationCard({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final isExpense = notification.type == 'expense';

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        String categoryName = 'undefined';
        if (notification.categoryId != -1 && state is CategoriesLoaded) {
          final category = state.categories.firstWhere(
            (cat) => cat.id == notification.categoryId,
            orElse: () => Category(
              id: -1,
              name: 'No Category',
              amount: 0.0,
              color: Colors.grey,
            ),
          );
          categoryName = category.name;
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
                      notification.memo.isNotEmpty ? notification.memo : '',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (isExpense && categoryName == 'undefined')
                              ? const Color(0xFFFF5C5C)
                              : AppColors.darkGrey),
                    ),
                    Text(
                      formatter.format(notification.amount),
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
                      categoryName,
                      style: TextStyle(fontSize: 14, color: categoryColor),
                    ),
                    Text(
                      notification.date,
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
