import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/features/overview/ui/bar_chart.dart';

class TabCategorized extends StatefulWidget {
  const TabCategorized({super.key});

  @override
  State<TabCategorized> createState() => TabCategorizedState();
}

class TabCategorizedState extends State<TabCategorized> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          child: ExpenseBarChart(),
        )
      ],
    );
  }
}
