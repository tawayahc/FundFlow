import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/models/bank_model.dart';
import 'package:fundflow/utils/bank_logo_util.dart';
import 'package:intl/intl.dart';
import 'package:fundflow/features/home/models/transfer.dart';

class TransferTransactionCard extends StatelessWidget {
  final Transfer transfer;
  final int currentBankId;
  final List<Bank> banks;

  const TransferTransactionCard({
    Key? key,
    required this.transfer,
    required this.currentBankId,
    required this.banks,
  }) : super(key: key);

  String _mapBankName(String bankName) {
    final bank = banks.firstWhere(
      (b) => b.name == bankName || b.bankName == bankName,
      orElse: () => Bank(
        id: 0,
        name: 'Unknown',
        bankName: 'Unknown Bank',
        amount: 0.0,
      ),
    );
    return bank.bankName;
  }

  @override
  Widget build(BuildContext context) {
    final isIncoming = transfer.toBankId == currentBankId;
    final dateFormatter = DateFormat('dd/MM/yyyy');
    final formattedDate =
        dateFormatter.format(DateTime.parse(transfer.createdAt));

    final bankName = isIncoming
        ? _mapBankName(transfer.fromBankName)
        : _mapBankName(transfer.toBankName);

    // Get bank logo
    final bankLogo = BankLogoUtil.getBankLogo(bankName);

    // Dynamic color based on transfer type
    final textColor =
        isIncoming ? const Color(0xFF80D084) : const Color(0xFFFF5C5C);

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

            // Transfer Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Direction and Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isIncoming ? 'ย้ายเงินเข้า' : 'ย้ายเงินออก',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: textColor, // Dynamic color
                        ),
                      ),
                      Text(
                        '฿ ${transfer.amount}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: textColor, // Amount color matches direction
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
                        bankName,
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
