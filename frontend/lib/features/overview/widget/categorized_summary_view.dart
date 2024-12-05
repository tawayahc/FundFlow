// features/categorized/ui/categorized_summary_view.dart
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/overview/summary_card.dart';
import 'package:fundflow/models/category_model.dart';
import 'package:fundflow/features/overview/model/categorized_summary.dart';
import 'package:fundflow/features/overview/widget/pie_chart.dart';
import 'package:fundflow/features/overview/widget/category_summary.dart';
import 'categorized_filter_view.dart';

class CategorizedSummaryView extends StatelessWidget {
  final List<Category> categories;
  final Map<String, CategorizedSummary> categorizedSummaries;

  const CategorizedSummaryView({
    super.key,
    required this.categories,
    required this.categorizedSummaries,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total income and expense for chart
    double totalIncome = categorizedSummaries.values
        .map((e) => e.totalIncome)
        .fold(0.0, (a, b) => a + b);
    double totalExpense = categorizedSummaries.values
        .map((e) => e.totalExpense)
        .fold(0.0, (a, b) => a + b);

    return SingleChildScrollView(
      child: Column(
        children: [
          // Chart Section
          CategorizedPieChart(
              categorizedSummaries: categorizedSummaries,
              categories: categories),
          const SizedBox(height: 10),
          // Summary Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SummaryCard(
                  type: true,
                  title: 'ยอดรวมเงินเข้า (บาท)',
                  amount: totalIncome,
                  items: categorizedSummaries.length,
                  avgPerMonth: 0.0, // Customize as needed
                ),
                SummaryCard(
                  type: false,
                  title: 'ยอดรวมเงินออก (บาท)',
                  amount: totalExpense,
                  items: categorizedSummaries.length,
                  avgPerMonth: 0.0, // Customize as needed
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Filter View
                CategorizedFilterView(
                  categories: categories,
                ),
                // ListView with Fixed Height
                SizedBox(
                  height: 400, // Adjust height as needed
                  child: categorizedSummaries.isNotEmpty
                      ? ListView.builder(
                          itemCount: categorizedSummaries.length,
                          itemBuilder: (context, index) {
                            final categoryKey =
                                categorizedSummaries.keys.elementAt(index);
                            final summary = categorizedSummaries[categoryKey]!;

                            return CategorySummaryItem(
                              categoryName: summary.category,
                              categoryColor: summary.categoryColor,
                              totalIn: summary.totalIncome,
                              totalOut: summary.totalExpense,
                              balance:
                                  summary.totalIncome - summary.totalExpense,
                            );
                          },
                        )
                      : const Center(
                          child: Text(
                              'No categories found for the selected criteria.'),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
