// features/categorized/ui/categorized_filter_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_event.dart';
import 'package:fundflow/features/overview/widget/expense_type_dropdown.dart';
import 'package:fundflow/features/overview/widget/date_range.dart';
import 'package:fundflow/features/overview/model/category_model.dart';

class CategorizedFilterView extends StatefulWidget {
  final List<CategoryModel> categories;

  const CategorizedFilterView({
    super.key,
    required this.categories,
  });

  @override
  State<CategorizedFilterView> createState() => _CategorizedFilterViewState();
}

class _CategorizedFilterViewState extends State<CategorizedFilterView> {
  final SingleValueDropDownController _categoryDropDownController =
      SingleValueDropDownController();
  DateTimeRange? selectedDateRange;

  @override
  void dispose() {
    _categoryDropDownController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final String? selectedCategory =
        _categoryDropDownController.dropDownValue?.value as String?;
    final DateTime? startDate = selectedDateRange?.start;
    final DateTime? endDate = selectedDateRange?.end;

    if (startDate == null || endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid date range')),
      );
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
                        contentPadding: EdgeInsets.only(left: 2, right: 2, top: 10, bottom: 10), 
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
                      clearOption: true,
                      dropDownItemCount: widget.categories.length + 1,
                      dropDownList: [
                        const DropDownValueModel(name: 'All', value: "all"),
                        ...widget.categories
                            // Brute force method to exclude 'income' category from showing
                            .where((category) => category.name.toLowerCase() != 'income')
                            .map((category) => DropDownValueModel(
                            name: category.name, value: category.name))
                            .toList(),
                      ],
                      onChanged: (val) {
                        logger.d('Category Selected: ${val?.value}');
                      },
                    ),
                  ),
                  SizedBox(height: 12,),
                  Container(
                    width: 143,
                    height: 30,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF41486d),
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
                  DateRangeDropdown(
                    onDateRangeSelected: (picked) {
                      setState(() {
                        selectedDateRange = picked;
                      });
                    },
                  ),
                  SizedBox(height: 12,),
                  Container(
                    width: 143,
                    height: 30,
                    child: OutlinedButton(
                      onPressed:  _clearFilters,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFF41486d), 
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
        // Buttons Row
        /*Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 143,
              height: 30,
              child: OutlinedButton(
                onPressed: _applyFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF41486d), 
                    width: 1.0, 
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              width: 143,
              height: 30,
              child: OutlinedButton(
                onPressed: _clearFilters,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Color(0xFF41486d), 
                    width: 1.0, 
                  ),
                ),
                child: const Text(
                  'Clear Filters',
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
          
        ),*/
      ],
    );
  }
}

