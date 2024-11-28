// features/overview/ui/routine_summary_item.dart
import 'package:flutter/material.dart';

class RoutineSummaryItem extends StatelessWidget {
  final String dateString;
  final double totalIn;
  final double totalOut;
  final double balance;

  const RoutineSummaryItem({
    Key? key,
    required this.dateString,
    required this.totalIn,
    required this.totalOut,
    required this.balance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(
              color: Colors.white, // Color of the top border
              width: 1.0, // Width of the top border
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 3,
              offset: const Offset(0, 0),
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dateString,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("เงินเข้าทั้งหมด",
                    style: TextStyle(color: Colors.grey[600])),
                Text(totalIn.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("เงินออกทั้งหมด",
                    style: TextStyle(color: Colors.grey[600])),
                Text(totalOut.toStringAsFixed(2),
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("สรุปยอด", style: TextStyle(color: Colors.grey[600])),
                Text(balance.toStringAsFixed(2),
                    style: TextStyle(
                        color: balanceColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
