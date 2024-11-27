import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../model/categorized_summary.dart';
import '../model/category_model.dart';

class CategorizedPieChart extends StatefulWidget {
  final List<CategoryModel> categories;
  final Map<String, CategorizedSummary> categorizedSummaries;

  const CategorizedPieChart({
    super.key,
    required this.categorizedSummaries,
    required this.categories,
  });

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State<CategorizedPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    // Check if categorizedSummaries or categories is empty
    if (widget.categorizedSummaries.isEmpty || widget.categories.isEmpty) {
      return const SizedBox(
        height: 335,
        child: const Center(
          child: Text(
            'No data available',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
      );
    }

    return SizedBox(
      height: 335,
      //aspectRatio: 1.3,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(30.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  'เงินเข้า-เงินออก', 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                  ),),
            ),
          ),
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: PieChart(
                PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex =
                            pieTouchResponse.touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                  borderData: FlBorderData(show: true),
                  sectionsSpace: 1.2,
                  centerSpaceRadius: 0,
            
                  //Data part
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    // Calculate the total expense for all categories
    final totalExpense = widget.categorizedSummaries.values.fold<double>(
      0,
      (sum, summary) => sum + summary.totalExpense,
    );

    // Safeguard against division by zero
    if (totalExpense == 0) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: 'No Data',
          radius: 100,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xffffffff),
          ),
        ),
      ];
    }

    // Sort categorizedSummaries by totalExpense in descending order
    final sortedEntries = widget.categorizedSummaries.entries.toList()
      ..sort((a, b) => b.value.totalExpense.compareTo(a.value.totalExpense));

    // Generate dynamic sections for the pie chart based on totalExpense
    return sortedEntries
        .map((entry) {
          final summary = entry.value;

          // Find the corresponding CategoryModel based on the name
          final categoryModel = widget.categories.firstWhere(
            (category) => category.name == summary.category,
            orElse: () => CategoryModel(
              id: -1,
              name: 'Undefined',
              colorCode: '#FFFFFFFF',
              amount: 0,
            ),
          );

          // Skip if no matching category is found
          if (categoryModel.id == -1) return null;

          // Handle touch interaction
          final index =
              widget.categorizedSummaries.keys.toList().indexOf(entry.key);
          final isTouched = index == touchedIndex;
          final fontSize = isTouched ? 14.0 : 12.0;
          final radius = isTouched ? 110.0 : 100.0;
          final widgetSize = isTouched ? 55.0 : 40.0;
          const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

          // Calculate percentage contribution
          final percentage = (summary.totalExpense / totalExpense) * 100;

          return PieChartSectionData(
            borderSide: const BorderSide(width: 1.3, color: Colors.black12),
            color: summary.categoryColor, // Use the category color
            value: summary.totalExpense,
            title:
                '${percentage.toStringAsFixed(1)}%', // Include the category name
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            // badge section
            badgePositionPercentageOffset: .98,
            badgeWidget: AnimatedContainer(
              duration: PieChart.defaultDuration,
              width: widgetSize,
              height: widgetSize,
              decoration: BoxDecoration(
                color: summary.categoryColor.withOpacity(0.9),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.9),
                  width: 2,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(.5),
                    blurRadius: 3,
                  ),
                ],
              ),
              padding: EdgeInsets.all(widgetSize * .15),
              child: Center(child: Text(categoryModel.name[0],style: TextStyle(fontSize: fontSize + 2,),
              )),
            ),
          );
        })
        .whereType<PieChartSectionData>()
        .toList(); // Filter out nulls
  }
}
