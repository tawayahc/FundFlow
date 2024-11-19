import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';

class CashBox extends StatelessWidget {
  final double cashBox;
  final double width;

  const CashBox(
      {super.key, required this.cashBox, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.grey, // Placeholder for a profile or image
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'แคชบ๊อกซ์',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                '฿ ${formatter.format(cashBox)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkBlue,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 15),
              Text(
                'กดค้างและลาก\nเพื่อจัดสรร',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CashBoxWhenDragging extends StatelessWidget {
  final double width;
  final double height;

  const CashBoxWhenDragging({
    super.key,
    this.width = double.infinity,
    this.height = 94.0, // Set default height to match CategoryCard if needed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.withOpacity(0.5),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );
  }
}
