// features/overview/ui/monthly_summary_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:fundflow/features/overview/widget/routine_summary_item.dart';
import 'package:fundflow/features/overview/widget/expense_type_dropdown.dart';
import 'package:fundflow/features/overview/widget/date_range.dart';
import '../model/monthly_summary.dart';

class MonthlySummaryView extends StatelessWidget {
  final Map<DateTime, MonthlySummary> monthlySummaries;
  final SingleValueDropDownController dropDownController;
  final Function(String?)? onFilterChanged;
  final Function(DateTimeRange?)? onDateRangeSelected;

  const MonthlySummaryView({
    super.key,
    required this.monthlySummaries,
    required this.dropDownController,
    this.onFilterChanged,
    this.onDateRangeSelected,
  });

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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ประเภทรายการ',),
                  SizedBox(
                    width: 143,
                    height: 30,
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
                  DateRangeDropdown(
                    onDateRangeSelected: onDateRangeSelected),
                  
                  // Implement Date Picker here
                  /*TextButton(
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
                  ),*/
                  
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: sortedMonths.isNotEmpty
              ? ListView.builder(
                  itemCount: sortedMonths.length,
                  itemBuilder: (context, index) {
                    final month = sortedMonths[index];
                    final summary = monthlySummaries[month]!;

                    const monthNames = {
                      1: 'ม.ค.',
                      2: 'ก.พ.',
                      3: 'มี.ค.',
                      4: 'เม.ย.',
                      5: 'พ.ค.',
                      6: 'มิ.ย.',
                      7: 'ก.ค.',
                      8: 'ส.ค.',
                      9: 'ก.ย.',
                      10: 'ต.ค.',
                      11: 'พ.ย.',
                      12: 'ธ.ค.',
                    };

                    return RoutineSummaryItem(
                      dateString: '${monthNames[month.month]} ${(month.year+543) % 100}',
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
