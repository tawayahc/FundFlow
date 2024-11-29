import 'package:flutter/material.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fundflow/utils/bank_color_util.dart';
import 'package:fundflow/utils/bank_logo_util.dart';
import 'package:intl/intl.dart';

class BankCard extends StatelessWidget {
  final Bank bank;

  const BankCard({super.key, required this.bank});

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'th_TH', symbol: '฿');
    // Normalize bank name before lookup
    final normalizedBankName = normalizeBankName(bank.bank_name);
    Color color = BankColorUtil.getBankColor(normalizedBankName);

    debugPrint('Normalized Bank Name: "$normalizedBankName", Color: $color');

    return Material(
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        width: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Bank Logo
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        _getBankLogo(normalizedBankName),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint(
                              'Error loading image for $normalizedBankName');
                          return Icon(Icons.error, color: Colors.red);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bank Name and Subtitle
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText(
                          bank.name,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              height: 1.1),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        AutoSizeText(
                          bank.bank_name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          minFontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: double.infinity,
                  height: 25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.9),
                        color,
                        color.withOpacity(0.7),
                      ],
                      stops: const [0.0, 0.6, 1.0],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: AutoSizeText(
                      formatter.format(
                          bank.amount), // Already includes the "฿" symbol
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      minFontSize: 5,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String normalizeBankName(String bankName) {
    return bankName.replaceAll(RegExp(r'\s+'), '').trim();
  }

  String _getBankLogo(String bankName) {
    final normalizedBankName = normalizeBankName(bankName);
    final path = BankLogoUtil.getBankLogo(normalizedBankName);

    return path ?? 'assets/CashBox.png';
  }
}
