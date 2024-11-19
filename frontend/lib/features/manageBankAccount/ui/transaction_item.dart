import 'package:flutter/material.dart';

import '../../../core/themes/app_styles.dart';

class TransactionItem extends StatelessWidget {
  final double amount;
  final String category;
  final String type;

  const TransactionItem({
    super.key,
    required this.amount,
    required this.category,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    bool isIncome = amount > 0;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(AppSpacing.medium),
      decoration: BoxDecoration(
        color: isIncome ? Colors.green[400] : Colors.red[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Container(
                  width: 50,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: TextStyle(color: Colors.grey[600], fontSize: 10),
                    ),
                  ))
            ],
          ),
          Row(
            children: [
              Text(
                '฿ ${amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.edit, color: Colors.grey[300]),
                onPressed: () {
                  Navigator.pushNamed(context, '/edit_transaction');
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
