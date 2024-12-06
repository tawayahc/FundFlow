// features/categorized/ui/categorized_filter_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/core/themes/app_styles.dart';
import 'package:fundflow/core/widgets/custom_modal.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_event.dart';
import 'package:fundflow/features/overview/widget/date_range.dart';

class CategorizedFilterView extends StatefulWidget {
  final List<Category> categories;

  const CategorizedFilterView({
    super.key,
    required this.categories,
  });

  @override
  State<CategorizedFilterView> createState() => _CategorizedFilterViewState();
}

bool _isDialogShowing = false;

void _showModal(BuildContext context, String text) {
  if (_isDialogShowing) {
    return;
  }

  _isDialogShowing = true;
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.1),
    builder: (BuildContext context) {
      return CustomModal(text: text);
    },
  ).then((_) {
    _isDialogShowing = false;
  });
}

class _CategorizedFilterViewState extends State<CategorizedFilterView> {
  final SingleValueDropDownController _categoryDropDownController =
      SingleValueDropDownController();
  DateTimeRange? selectedDateRange;
  String? _selectedDateRange;
  String? selectedExpenseType;

  @override
  void dispose() {
    _categoryDropDownController.dispose();
    super.dispose();
  }

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
    final String? selectedCategory =
        _categoryDropDownController.dropDownValue?.value as String?;
    final DateTime? startDate = selectedDateRange?.start;
    final DateTime? endDate = selectedDateRange?.end;

    if (startDate == null || endDate == null) {
      _showModal(context, 'กรุณาเลือกช่วงเวลาที่ถูกต้อง');

      return;
    }

    context.read<CategorizedBloc>().add(ApplyFiltersEvent(
          categoryName: selectedCategory,
          startDate: startDate,
          endDate: endDate,
        ));

    logger.d(
        'Applying Filters - Category: $selectedCategory, Start: $startDate, End: $endDate');
  }

  void _clearFilters() {
    setState(() {
      _categoryDropDownController.clearDropDown();
      _selectedDateRange = null;
      selectedDateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Dropdown and Date Picker Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Category Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ประเภทรายการ'),
                  SizedBox(
                    width: 143,
                    height: 30,
                    child: DropDownTextField(
                      textFieldDecoration: const InputDecoration(
                        hintText: 'เลือกหมวดหมู่',
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
                            left: 2, right: 2, top: 10, bottom: 10),
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
                      controller: _categoryDropDownController,
                      clearOption: false,
                      dropDownItemCount: widget.categories.length + 1,
                      dropDownList: [
                        const DropDownValueModel(name: 'All', value: "all"),
                        ...widget.categories
                            // Brute force method to exclude 'income' category from showing
                            .where((category) =>
                                category.name.toLowerCase() != 'income')
                            .map((category) => DropDownValueModel(
                                name: category.name, value: category.name))
                            .toList(),
                      ],
                      onChanged: (val) {
                        logger.d('Category Selected: ${val?.value}');
                      },
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

              // Date Range Picker
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ช่วงเวลา'),
                  GestureDetector(
                    onTap: () => _selectDateRange(context),
                    child: Container(
                      width: 143,
                      height: 30,
                      //padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      padding: const EdgeInsets.only(
                          left: 2, right: 2, top: 10, bottom: 4),
                      decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: Colors.grey)),
                        //borderRadius: BorderRadius.circular(8),
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
      ],
    );
  }
}
