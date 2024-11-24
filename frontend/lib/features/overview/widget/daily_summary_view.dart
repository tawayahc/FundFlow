// features/overview/ui/daily_summary_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/widget/routine_summary_item.dart';
import 'package:fundflow/features/overview/widget/expense_type_dropdown.dart';

import '../model/daily_summary.dart';

class DailySummaryView extends StatelessWidget {
  final Map<DateTime, DailySummary> dailySummaries;
  final SingleValueDropDownController dropDownController;
  final Function(String?)? onFilterChanged;
  final Function(DateTimeRange?)? onDateRangeSelected;

  const DailySummaryView({
    Key? key,
    required this.dailySummaries,
    required this.dropDownController,
    this.onFilterChanged,
    this.onDateRangeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedDates = dailySummaries.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Add logging
    logger.d('DailySummaryView: sortedDates length: ${sortedDates.length}');

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ประเภทรายการ',
                  ),
                  SizedBox(
                    width: 120,
                    height: 40,
                    child: ExpenseTypeDropDown(
                      controller: dropDownController,
                      onChanged: onFilterChanged!,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
          child: sortedDates.isNotEmpty
              ? ListView.builder(
                  itemCount: sortedDates.length,
                  itemBuilder: (context, index) {
                    final date = sortedDates[index];
                    final summary = dailySummaries[date];

                    // Add logging
                    // logger.d('Date: $date, Summary: $summary');

                    if (summary == null) {
                      logger.e('Warning: summary is null for date $date');
                      return Container(); // or some placeholder widget
                    }

                    return RoutineSummaryItem(
                      dateString: '${date.day}/${date.month}/${date.year}',
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
