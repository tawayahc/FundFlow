import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/layout.dart';
import 'package:fundflow/features/home/models/bank.dart';
import 'package:auto_size_text/auto_size_text.dart';

class BankCard extends StatelessWidget {
  final Bank bank;
  final Map<String, Color> bankColorMap;

  const BankCard({super.key, required this.bank, required this.bankColorMap});

  @override
  Widget build(BuildContext context) {
    Color color = bankColorMap[bank.bank_name] ?? Colors.grey;
    return Container(
      margin: const EdgeInsets.only(right: 16),
      width: 170, // Set the width to avoid overflow
      decoration: BoxDecoration(
        color: Colors.white, // Set background color to white
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Placeholder for bank logo
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.9), // Placeholder color
                  ),
                ),
                const SizedBox(width: 8),
                // Bank Name and Subtitle with Flexible to prevent overflow
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        bank.name,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            height: 1.1), // Set text color to black
                        maxLines: 1,
                        minFontSize: 10, // Minimum size when shrinking
                        overflow: TextOverflow.ellipsis, // Ellipsis if too long
                      ),
                      AutoSizeText(
                        bank.bank_name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        minFontSize: 10, // Minimum size when shrinking
                        overflow: TextOverflow.ellipsis, // Ellipsis if too long
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
                height: 8), // Adjust space between text and gradient box
            // Aligned gradient box for balance with fixed size
            Align(
              alignment: Alignment.center, // Center the box horizontally
              child: Container(
                width: double.infinity, // Fixed width for the gradient box
                height: 30, // Fixed height for the gradient box
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      color.darken(0.1), // Darker shade of the bank.color
                      color, // Original color
                      color.withOpacity(0.7), // Lighter shade with 20% opacity
                    ],
                    stops: const [
                      0.0,
                      0.6,
                      1.0
                    ], // Control the position of the color transitions
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center, // Ensure elements are centered
                  children: [
                    // Center both '฿' and balance
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center, // Center horizontally
                        crossAxisAlignment:
                            CrossAxisAlignment.center, // Center vertically
                        children: [
                          const Text(
                            '฿', // The fixed size currency symbol
                            style: TextStyle(
                              fontSize:
                                  20, // Fixed size for the currency symbol
                              fontWeight: FontWeight.normal,
                              color:
                                  Colors.white, // Set the text color to white
                            ),
                          ),
                          const SizedBox(
                              width:
                                  4), // Adjust spacing between '฿' and balance
                          Flexible(
                            child: AutoSizeText(
                              formatter.format(bank.amount),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors.white, // Set the text color to white
                              ),
                              maxLines: 1,
                              minFontSize: 5, // Allow shrinking for balance
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign
                                  .left, // Align the balance text to the left
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
