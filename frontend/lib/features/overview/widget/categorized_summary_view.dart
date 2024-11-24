// features/categorized/ui/categorized_summary_view.dart
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/overview/summary_card.dart';
import 'package:fundflow/features/overview/model/categorized_summary.dart';
import 'package:fundflow/features/overview/model/category_model.dart';
import 'package:fundflow/features/overview/ui_test/categorize_summary_screen.dart';
import 'package:fundflow/features/overview/widget/pie_chart.dart';
import 'categorized_filter_view.dart';
import 'package:fl_chart/fl_chart.dart'; // Assuming you use fl_chart for charts

class CategorizedSummaryView extends StatelessWidget {
  final List<CategoryModel> categories;
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

    return Column(
      children: [
        // Chart Section
        CategorizedPieChart(categorizedSummaries: categorizedSummaries, categories: categories),
        const SizedBox(height: 10),
        // Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SummaryCard(
                type: true,
                title: 'Total Income (THB)',
                amount: totalIncome,
                items: categorizedSummaries.length,
                avgPerMonth: 0.0, // Customize as needed
              ),
              SummaryCard(
                type: false,
                title: 'Total Expense (THB)',
                amount: totalExpense,
                items: categorizedSummaries.length,
                avgPerMonth: 0.0, // Customize as needed
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Filter View
        CategorizedFilterView(
          categories: categories,
        ),
        const SizedBox(height: 10),
        // Expanded ListView
        Expanded(
          child: categorizedSummaries.isNotEmpty
              ? ListView.builder(
                  itemCount: categorizedSummaries.length,
                  itemBuilder: (context, index) {
                    final categoryKey =
                        categorizedSummaries.keys.elementAt(index);
                    final summary = categorizedSummaries[categoryKey]!;

                    return GestureDetector(
                      onTap: () {
                        // Navigate to detailed category screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategorizedSummaryScreen(
                              categoryName: summary.category,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: summary.categoryColor.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                summary.category,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: summary.categoryColor,
                                ),
                              ),
                              const Divider(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Income",
                                      style: TextStyle(
                                          color: summary.categoryColor)),
                                  Text(summary.totalIncome.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: summary.categoryColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total Expense",
                                      style: TextStyle(
                                          color: summary.categoryColor)),
                                  Text(summary.totalExpense.toStringAsFixed(2),
                                      style: TextStyle(
                                          color: summary.categoryColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Net Total",
                                      style: TextStyle(
                                          color: summary.categoryColor)),
                                  Text(
                                      (summary.totalIncome -
                                              summary.totalExpense)
                                          .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: summary.categoryColor,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text('No categories found for the selected criteria.'),
                ),
        ),
      ],
    );
  }
}
