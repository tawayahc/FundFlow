// transaction_card_for_category.dart

import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/utils/bank_logo_util.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/features/home/models/transaction.dart';

class TransactionCardForCategory extends StatelessWidget {
  final Transaction transaction;

  const TransactionCardForCategory({Key? key, required this.transaction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'expense';
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate =
        dateFormatter.format(DateTime.parse(transaction.createdAt));

    // Get bank logo
    final bankLogo = BankLogoUtil.getBankLogo(transaction.bankName);

    // Dynamic color based on transaction type
    final textColor = isExpense ? AppColors.darkGrey : const Color(0xFF80D084);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey), // Light border
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Bank Logo
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    Colors.grey.shade200, // Background color for missing logos
              ),
              child: ClipOval(
                child: Image.asset(
                  bankLogo,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.account_balance,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12), // Space between logo and text

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Memo and Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.memo.isNotEmpty
                            ? transaction.memo
                            : 'ไม่มีบันทึกช่วยจำ',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor, // Dynamic color
                        ),
                      ),
                      Text(
                        '฿ ${transaction.amount}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor, // Amount color matches type
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4), // Reduced space

                  // Bank Name and Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transaction.bankName.isNotEmpty
                            ? transaction.bankName
                            : 'ธนาคารไม่รู้จัก',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
