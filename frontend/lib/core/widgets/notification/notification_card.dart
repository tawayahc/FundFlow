import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        Color categoryColor = Colors.grey;

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
          categoryColor = category.color;
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
            padding: const EdgeInsets.all(15.0),
            child: Row(
              children: [
                // Icon box
                Container(
                  width: 30, // ปรับขนาดให้เล็กลง
                  height: 30, // ปรับขนาดให้เล็กลง
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(width: 12), // ลดระยะห่างระหว่าง Icon กับข้อความ

                // Text and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.memo.isNotEmpty
                            ? notification.memo
                            : categoryName,
                        style: const TextStyle(
                          fontSize: 14, // ลดขนาดตัวอักษร
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF414141),
                        ),
                      ),
                      Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 12, // ลดขนาดตัวอักษร
                          color: Color(0xFF414141),
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
                      '฿ ${notification.amount.toString()}',
                      style: const TextStyle(
                        fontSize: 14, // ลดขนาดตัวอักษร
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF414141),
                      ),
                    ),
                    Text(
                      notification.date,
                      style: const TextStyle(
                        fontSize: 12, // ลดขนาดตัวอักษร
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
