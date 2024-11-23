import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/category.dart';

import '../../../features/home/models/bank.dart';

class CategoryBalanceBox extends StatelessWidget {
  final Color color;
  final Category category;
  final String date;
  const CategoryBalanceBox({super.key, required this.color, required this.category, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          0, 8, 4, 0), // padding (left, top, right, bottom)
      width: double.infinity, // สุดขอบ
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(width: 16),
              Text(
                'ยอดเงินคงเหลือ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          const Divider(
            color: Colors.white,
            thickness: 2,
            height: 3,
            indent: 2,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '฿ ${category.amount.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'ข้อมูล ณ $date',
              style: const TextStyle(color: Colors.white, fontSize: 11),
              textAlign: TextAlign.right,
            ),
          )
        ],
      ),
    );
  }
}