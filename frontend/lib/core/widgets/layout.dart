import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GlobalPadding extends StatelessWidget {
  final Widget child;

  const GlobalPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      child: child,
    );
  }
}

final formatter = NumberFormat('#,##0.00');
