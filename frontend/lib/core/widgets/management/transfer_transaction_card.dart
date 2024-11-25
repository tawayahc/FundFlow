import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/features/home/models/transfer.dart';

class TransferTransactionCard extends StatelessWidget {
  final Transfer transfer;
  final int currentBankId;

  const TransferTransactionCard({
    Key? key,
    required this.transfer,
    required this.currentBankId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isIncoming = transfer.toBankId == currentBankId;
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate =
        dateFormatter.format(DateTime.parse(transfer.createdAt));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Direction and Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isIncoming ? 'ย้ายเงินเข้า' : 'ย้ายเงินออก',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${transfer.amount}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: From/To Bank Name and Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isIncoming
                      ? 'จาก ${transfer.fromBankName}'
                      : 'ไปยัง ${transfer.toBankName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  formattedDate,
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
