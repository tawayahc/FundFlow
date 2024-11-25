// features/overview/ui/monthly_summary_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/features/overview/widget/routine_summary_item.dart';

import '../../../app.dart';
import '../bloc/overview/overview_bloc.dart';
import '../bloc/overview/overview_event.dart';
import '../model/monthly_summary.dart';

class MonthlySummaryView extends StatefulWidget {
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
  State<MonthlySummaryView> createState() => _MonthlySummaryViewState();
}

class _MonthlySummaryViewState extends State<MonthlySummaryView> {
  DateTimeRange? selectedDateRange;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year - 5);
    final DateTime lastDate = DateTime(now.year + 1);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: firstDate,
      lastDate: lastDate,
      initialDateRange: selectedDateRange ??
          DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          ),
    );

    if (picked != null && picked != selectedDateRange) {
      setState(() {
        selectedDateRange = picked;
      });
      logger.d('Selected Date Range: ${picked.start} - ${picked.end}');
    }
    _applyFiltered();
  }

  void _applyFiltered () {
    final String? selectedExpenseType =
    widget.dropDownController.dropDownValue?.value as String?;
    final DateTime? startDate = selectedDateRange?.start;
    final DateTime? endDate = selectedDateRange?.end;

    // Dispatch ApplyFiltersEvent to BLoC
    context.read<OverviewBloc>().add(ApplyExpenseFiltersEvent(
      expenseType: selectedExpenseType,
      startDate: startDate,
      endDate: endDate,
    ));

    logger.d('Applying Filters: $selectedExpenseType');
  }

  @override
  Widget build(BuildContext context) {
    final sortedMonths =  widget.monthlySummaries.keys.toList()
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
                    child: DropDownTextField(
                      textFieldDecoration: const InputDecoration(
                        hintText: 'เงินเข้า-เงินออก',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                      ),
                      controller:  widget.dropDownController,
                      clearOption: true,
                      clearIconProperty: IconProperty(color: Colors.green),
                      validator: (value) {
                        if (value == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 3,
                      dropDownList: const [
                        DropDownValueModel(name: 'เงินเข้า-เงินออก', value: "all"),
                        DropDownValueModel(name: 'เงินเข้า', value: "income"),
                        DropDownValueModel(name: 'เงินออก', value: "expense"),
                      ],
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                      ),
                      onChanged: (val) {
                        _applyFiltered();
                      },
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('ช่วงเวลา'),
                  // Implement Date Picker here
                  ElevatedButton.icon(
                    onPressed: () => _selectDateRange(context),
                    icon: const Icon(Icons.date_range),
                    label: Text(selectedDateRange == null
                        ? 'Select Date Range'
                        : '${selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}'),
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
              final summary = widget.monthlySummaries[month]!;

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


