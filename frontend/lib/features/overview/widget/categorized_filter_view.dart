// features/categorized/ui/categorized_filter_view.dart
import 'package:flutter/material.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fundflow/app.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_bloc.dart';
import 'package:fundflow/features/overview/bloc/categorized/categorized_event.dart';
import 'package:fundflow/features/overview/model/category_model.dart';

class CategorizedFilterView extends StatefulWidget {
  final List<CategoryModel> categories;

  const CategorizedFilterView({
    Key? key,
    required this.categories,
  }) : super(key: key);

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
  }

  void _applyFilters() {
    final String? selectedCategory =
        _categoryDropDownController.dropDownValue?.value as String?;
    final DateTime? startDate = selectedDateRange?.start;
    final DateTime? endDate = selectedDateRange?.end;

    // Dispatch ApplyFiltersEvent to BLoC
    context.read<CategorizedBloc>().add(ApplyFiltersEvent(
          categoryName: selectedCategory,
          startDate: startDate,
          endDate: endDate,
        ));

    logger.d(
        'Applying Filters - Category: $selectedCategory, Start: $startDate, End: $endDate');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Dropdown
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropDownTextField(
            textFieldDecoration: const InputDecoration(
              hintText: 'Select Category',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            controller: _categoryDropDownController,
            clearOption: true,
            dropDownItemCount: 10,
            dropDownList: [
              const DropDownValueModel(name: 'All', value: "all"),
              ...widget.categories
                  .map((category) => DropDownValueModel(
                      name: category.name, value: category.name))
                  .toList(),
            ],
            onChanged: (val) {
              logger.d('Category Selected: ${val?.value}');
            },
          ),
        ),
        // Date Range Picker
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton.icon(
            onPressed: () => _selectDateRange(context),
            icon: const Icon(Icons.date_range),
            label: Text(selectedDateRange == null
                ? 'Select Date Range'
                : '${selectedDateRange!.start.toLocal().toString().split(' ')[0]} - ${selectedDateRange!.end.toLocal().toString().split(' ')[0]}'),
          ),
        ),
        const SizedBox(height: 10),
        // Apply Filters Button
        Center(
          child: ElevatedButton(
            onPressed: _applyFilters,
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }
}
