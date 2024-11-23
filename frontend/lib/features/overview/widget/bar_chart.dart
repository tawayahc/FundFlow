import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fundflow/features/overview/model/monthly_summary.dart';

class ExpenseBarChart extends StatefulWidget {
  final Map<DateTime, MonthlySummary> monthlySummaries;
  const ExpenseBarChart({super.key, required this.monthlySummaries});
  final Color leftBarColor = const Color(0xff80d084);
  final Color rightBarColor = const Color(0xffff9595);
  final Color avgColor = Colors.orange;

  @override
  State<StatefulWidget> createState() => ExpenseBarChartState();
}

class ExpenseBarChartState extends State<ExpenseBarChart> {
  final double barWidth = 30;
  final double heightPartition = 100;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    // List<Bar>
    super.initState();

    // Sort the dailySummaries by date (ascending order)
    final sortedSummaries = widget.monthlySummaries.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    // Generate BarChartGroupData from sorted summaries
    rawBarGroups = sortedSummaries.asMap().entries.map((entry) {
      final index = entry.key; // Index for the x-axis
      final monthlySummary = entry.value.value; // DailySummary object
      return makeGroupData(
        index,
        monthlySummary.totalIncome,
        monthlySummary.totalExpense,
      );
    }).toList();

    // Initialize showingBarGroups
    showingBarGroups = List.of(rawBarGroups);
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.25,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('เงินเข้า-เงินออกรายเดือน'),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: barWidth * 2.5 * showingBarGroups.length,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.center,
                      maxY: heightPartition,
                      baselineY: 10,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: ((group) {
                            return Colors.grey;
                          }),
                          getTooltipItem: (a, b, c, d) => null,
                        ),
                        // touchCallback: (FlTouchEvent event, response) {
                        //   if (response == null || response.spot == null) {
                        //     setState(() {
                        //       touchedGroupIndex = -1;
                        //       showingBarGroups = List.of(rawBarGroups);
                        //     });
                        //     return;
                        //   }
                        //
                        //   touchedGroupIndex = response.spot!.touchedBarGroupIndex;
                        //
                        //   setState(() {
                        //     if (!event.isInterestedForInteractions) {
                        //       touchedGroupIndex = -1;
                        //       showingBarGroups = List.of(rawBarGroups);
                        //       return;
                        //     }
                        //     showingBarGroups = List.of(rawBarGroups);
                        //     if (touchedGroupIndex != -1) {
                        //       var sum = 0.0;
                        //       for (final rod
                        //       in showingBarGroups[touchedGroupIndex].barRods) {
                        //         sum += rod.toY;
                        //       }
                        //       final avg = sum /
                        //           showingBarGroups[touchedGroupIndex]
                        //               .barRods
                        //               .length;
                        //
                        //       showingBarGroups[touchedGroupIndex] =
                        //           showingBarGroups[touchedGroupIndex].copyWith(
                        //             barRods: showingBarGroups[touchedGroupIndex]
                        //                 .barRods
                        //                 .map((rod) {
                        //               return rod.copyWith(
                        //                   toY: avg, color: widget.avgColor);
                        //             }).toList(),
                        //           );
                        //     }
                        //   });
                        // },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles, // Pass formatted dates
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: false),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    if (value == 0) {
      text = '1K';
    } else if (value == 10) {
      text = '5K';
    } else if (value == 20) {
      text = '10K';
    } else {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 1,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    // List of month names
    const List<String> monthNames = [
    'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];

    // Retrieve the sorted list of dates
    final sortedDates = widget.monthlySummaries.keys.toList()
      ..sort((a, b) => a.compareTo(b)); // Sort dates in ascending order

    // Ensure the value corresponds to a valid index
    if (value.toInt() < 0 || value.toInt() >= sortedDates.length) {
      return Container(); // Return an empty container if out of bounds
    }

    // Get the corresponding date
    final date = sortedDates[value.toInt()];
    // Map the month number to its short name
    final formattedDate = monthNames[date.month - 1];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 6, // Space between the axis and the label
      child: Text(
        formattedDate,
        style: const TextStyle(
          color: Color(0xff7589a2),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 0,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: barWidth,
          borderRadius: const BorderRadius.all(Radius.zero),
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: barWidth,
          borderRadius: const BorderRadius.all(Radius.zero),
        ),
      ],
    );
  }
}