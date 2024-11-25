// features/categorized/ui/categorized_summary_view.dart
import 'package:flutter/material.dart';
import 'package:fundflow/core/widgets/overview/summary_card.dart';
import 'package:fundflow/features/overview/model/categorized_summary.dart';
import 'package:fundflow/features/overview/model/category_model.dart';
import 'package:fundflow/features/overview/ui_test/categorize_summary_screen.dart';
import 'package:fundflow/features/overview/widget/category_summary.dart';
import 'categorized_filter_view.dart';
import 'package:fl_chart/fl_chart.dart'; // Assuming you use fl_chart for charts

class CategorizedSummaryView extends StatelessWidget {
  final List<CategoryModel> categories;
  final Map<String, CategorizedSummary> categorizedSummaries;

  const CategorizedSummaryView({
    Key? key,
    required this.categories,
    required this.categorizedSummaries,
  }) : super(key: key);

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
          Container(
            height: 200,
            padding: const EdgeInsets.all(16.0),
            child: PieChart(
              PieChartData(
                sections: [
                  PieChartSectionData(
                    color: Colors.green,
                    value: totalIncome,
                    title: 'Income\n${totalIncome.toStringAsFixed(2)}',
                    radius: 50,
                    titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  PieChartSectionData(
                    color: Colors.red,
                    value: totalExpense,
                    title: 'Expense\n${totalExpense.toStringAsFixed(2)}',
                    radius: 50,
                    titleStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
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
                            final categoryKey = categorizedSummaries.keys.elementAt(index);
                            final summary = categorizedSummaries[categoryKey]!;

                            return CategorySummaryItem(
                              categoryName: summary.category,
                              categoryColor: summary.categoryColor,
                              totalIn: summary.totalIncome,
                              totalOut: summary.totalExpense,
                              balance: summary.totalIncome - summary.totalExpense,
                            );
                            /*GestureDetector(
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Net Total",
                                              style: TextStyle(
                                                  color: summary.categoryColor)),
                                          Text(
                                              (summary.totalIncome - summary.totalExpense)
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
                            );*/
                          },
                        )
                      : const Center(
                          child: Text('No categories found for the selected criteria.'),
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
