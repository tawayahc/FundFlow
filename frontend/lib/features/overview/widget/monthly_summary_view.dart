import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/features/overview/widget/routine_summary_item.dart';
import 'package:fundflow/features/overview/widget/date_range.dart';
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
  String? _selectedDateRange;

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
        _selectedDateRange =
            '${picked.start.toLocal().toShortDateString()} - ${picked.end.toLocal().toShortDateString()}';
      });
      logger.d('Selected Date Range: ${picked.start} - ${picked.end}');
    }
  }

  void _applyFilters() {
    String? selectedExpenseType =
        widget.dropDownController.dropDownValue?.value as String?;
    final DateTime? startDate = selectedDateRange?.start;
    final DateTime? endDate = selectedDateRange?.end;

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid date range')),
      );
      return;
    }

    context.read<OverviewBloc>().add(ApplyExpenseFiltersEvent(
          expenseType: selectedExpenseType,
          startDate: startDate,
          endDate: endDate,
        ));

    logger.d('Applying Filters: $selectedExpenseType');
  }

  void _clearFilters() {
    setState(() {
      widget.dropDownController.clearDropDown();
      _selectedDateRange = null;
      selectedDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedMonths = widget.monthlySummaries.keys.toList()
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
                  const Text(
                    'ประเภทรายการ',
                  ),
                  SizedBox(
                    width: 143,
                    height: 30,
                    child: DropDownTextField(
                      textFieldDecoration: const InputDecoration(
                        hintText: 'เงินเข้า-เงินออก',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 4.0),
                          child: Icon(Icons.arrow_drop_down),
                        ),
                        suffixIconColor: Colors.grey,
                        contentPadding: EdgeInsets.only(
                            left: 2, right: 2, top: 10, bottom: 4),
                        isDense: true,
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
                      controller: widget.dropDownController,
                      clearOption: false,
                      //clearIconProperty: IconProperty(color: Colors.green),
                      validator: (value) {
                        if (value == null) {
                          return "Required field";
                        } else {
                          return null;
                        }
                      },
                      dropDownItemCount: 3,
                      dropDownList: const [
                        DropDownValueModel(
                            name: 'เงินเข้า-เงินออก', value: "all"),
                        DropDownValueModel(name: 'เงินเข้า', value: "income"),
                        DropDownValueModel(name: 'เงินออก', value: "expense"),
                      ],
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 143,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      onPressed: _applyFilters,
                      child: const Text(
                        'เพิ่มตัวกรอง',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ช่วงเวลา'),
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      width: 143,
                      height: 30,
                      padding: const EdgeInsets.only(
                          left: 2, right: 2, top: 10, bottom: 4),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey)),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedDateRange ?? 'เลือกช่วงเวลา',
                            style: TextStyle(
                              fontSize: 11,
                              color: _selectedDateRange == null
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          const Icon(Icons.calendar_today,
                              color: Colors.grey, size: 15),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    width: 143,
                    height: 30,
                    child: OutlinedButton(
                      onPressed: _clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primary,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'ลบตัวกรอง',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        Expanded(
          child: sortedMonths.isNotEmpty
              ? ListView.builder(
                  itemCount: sortedMonths.length,
                  itemBuilder: (context, index) {
                    final month = sortedMonths[index];
                    final summary = widget.monthlySummaries[month]!;

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
                      dateString:
                          '${monthNames[month.month]} ${(month.year + 543) % 100}',
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
