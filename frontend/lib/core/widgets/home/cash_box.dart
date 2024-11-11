import 'package:flutter/material.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/global_padding.dart';

class CashBox extends StatelessWidget {
  final double cashBox;

  const CashBox({super.key, required this.cashBox});

  @override
  Widget build(BuildContext context) {
    return Container(
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

class CustomDraggableCashBox extends StatefulWidget {
  final double cashBox;

  const CustomDraggableCashBox({super.key, required this.cashBox});

  @override
  _CustomDraggableCashBoxState createState() => _CustomDraggableCashBoxState();
}

class _CustomDraggableCashBoxState extends State<CustomDraggableCashBox> {
  Offset position = Offset.zero; // Starting position
  final Offset initialPosition =
      Offset.zero; // Save initial position to reset later

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Update the position based on the drag
          position += details.delta;
        });
      },
      onPanEnd: (details) {
        // Reset the position to the initial position when drag ends
        setState(() {
          position = initialPosition;
        });
      },
      child: Stack(
        children: [
          Transform.translate(
            offset: position,
            child: CashBox(cashBox: widget.cashBox),
          ),
        ],
      ),
    );
  }
}
