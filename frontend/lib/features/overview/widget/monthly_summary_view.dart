// features/overview/ui/monthly_summary_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fundflow/features/overview/widget/routine_summary_item.dart';
import 'package:fundflow/features/overview/widget/expense_type_dropdown.dart';

import '../model/monthly_summary.dart';

class MonthlySummaryView extends StatelessWidget {
  final Map<DateTime, MonthlySummary> monthlySummaries;
  final SingleValueDropDownController dropDownController;
  final Function(String?)? onFilterChanged;
  final Function(DateTimeRange?)? onDateRangeSelected;

  const MonthlySummaryView({
    Key? key,
    required this.monthlySummaries,
    required this.dropDownController,
    this.onFilterChanged,
    this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedMonths = monthlySummaries.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filters and Dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text('ประเภทรายการ'),
                  SizedBox(
                    width: 150,
                    child: ExpenseTypeDropDown(
                      controller: dropDownController,
                      onChanged: onFilterChanged!,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('ช่วงเวลา'),
                  // Implement Date Picker here
                  TextButton(
                    onPressed: () async {
                      final picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        onDateRangeSelected!(picked);
                      }
                    },
                    child: const Text('เลือกช่วงเวลา'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: sortedMonths.isNotEmpty
              ? ListView.builder(
                  itemCount: sortedMonths.length,
                  itemBuilder: (context, index) {
                    final month = sortedMonths[index];
                    final summary = monthlySummaries[month]!;

                    return RoutineSummaryItem(
                      dateString: '${month.month}/${month.year}',
                      totalIn: summary.totalIncome,
                      totalOut: summary.totalExpense,
                      balance: summary.netTotal,
                    );
                  },
                )
              : const Center(
                  child:
                      Text('No transactions found for the selected criteria.')),
        ),
      ],
    );
  }
}
