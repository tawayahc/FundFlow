// core/widgets/overview/summary_card.dart
import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final bool type; // true for income, false for expense
  final String title;
  final double amount;
  final int items;
  final double avgPerMonth;

  const SummaryCard({
    Key? key,
    required this.type,
    required this.title,
    required this.amount,
    required this.items,
    required this.avgPerMonth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                amount.toStringAsFixed(2),
                style: TextStyle(
                    fontSize: 13, color: type ? Colors.green : Colors.red),
              ),
              Row(
                children: [
                  Text(
                    "รายการ",
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    items.toStringAsFixed(0),
                    style: TextStyle(
                        fontSize: 10, color: type ? Colors.green : Colors.red),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'เฉลี่ยต่อเดือน',
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Text(
                    avgPerMonth.toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: 10, color: type ? Colors.green : Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
