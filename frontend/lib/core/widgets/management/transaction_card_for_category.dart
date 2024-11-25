// transaction_card_for_category.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/home/models/transaction.dart';

class TransactionCardForCategory extends StatelessWidget {
  final Transaction transaction;

  const TransactionCardForCategory({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';

    // Formatter for amount
    final formatter = NumberFormat.currency(
      locale: 'en_US',
      symbol: '', // No currency symbol
      decimalDigits: 2,
    );

    // Formatter for date
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: memo and amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.memo.isNotEmpty ? transaction.memo : '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGrey,
                  ),
                ),
                Text(
                  formatter.format(transaction.amount),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isExpense ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: bank name and created at
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transaction.bankName.isNotEmpty
                      ? transaction.bankName
                      : 'Unknown Bank',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  dateFormatter.format(DateTime.parse(transaction.createdAt)),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
